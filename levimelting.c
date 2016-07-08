/*
 * levimelting.c
 *
 * Created: 09.02.2016 23:31:09
 * Author: Falcon
 */

#include <io.h>

#asm
        .equ __w1_port=0xB
        .equ __w1_bit=6
#endasm
    
#include <ds18b20.h>
#include <delay.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR)) //��������� ��������� ��� ���
#define TOK_KOEF 5
#define LED PORTB.5  
#define RELAY_CAP_ON  PORTD.5=0
#define RELAY_CAP_OFF PORTD.5=1
#define RELAY_PWR_ON  PORTD.4=0
#define RELAY_PWR_OFF PORTD.4=1
#define MAX_ERRORS 5 //����� ������ ��� ������������, ����� �������� ������ � ������
#define WARM_TIME 30 //������ �� �������
#define MELT_TIME 90 //������ �� ������

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input){
  int i;
  unsigned long adc_summ=0;
  ADMUX=adc_input | (0<<REFS1) | (1<<REFS0) | (0<<ADLAR);
  // Delay needed for the stabilization of the ADC input voltage
  delay_us(10);

   for (i=1; i<100; i++){
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    adc_summ+=ADCW;
   }
  return adc_summ/100;
}

unsigned int tok, tok_old;
unsigned char errors;

/* maximum number of DS18B20 connected to the 1 Wire bus */
#define MAX_DEVICES 2

/* DS18B20 devices ROM code storage area */
unsigned char rom_code[MAX_DEVICES][9];

void main(void){
  unsigned int i=0, fet_temp, water_temp;
  unsigned char j,devices;
  
  RELAY_CAP_OFF;
  RELAY_PWR_OFF;
  
  DDRB.0=DDRB.3=DDRB.5=DDRD.2=DDRD.3=DDRD.4=DDRD.5=1;
  PORTB.0=0;
   
  //������, ����������� ��� ��� �������� ������ � ��� ���������� �������
  TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
  TCCR2B=(0<<WGM22) | (1<<CS22) | (1<<CS21) | (0<<CS20);
  TCNT2=0;
  OCR2B=0;    //������ ��� ������� (������ = ������� ����)
  OCR2A=40;   //������ ��� ������ (������ = ������ ����� � ������ ��������)
    
  // ADC initialization 125,000 kHz  AVCC pin ADC Stopped
  DIDR0=(1<<ADC5D) | (1<<ADC4D) | (1<<ADC3D) | (1<<ADC2D) | (1<<ADC1D) | (0<<ADC0D);
  ADCSRA=(1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
  
  // USART initialization 8 Data, 1 Stop, No Parity Asynchronous Baud Rate: 9600
  UCSR0B=(1<<TXEN0);
  UCSR0C=((1<<UCSZ01) | (1<<UCSZ00));
  UBRR0L=0x67;
  
  OCR2B=0;
                                              
  printf("LOADING...");
  
  /*searching for ds18b20 sensors*/
  devices=w1_search(0xf0,rom_code);
  if (devices == 2) printf("Temp. control ready",devices);
  else printf("Error: %u temp.sensor(s) not found",devices, (2-devices));
  /* configure each DS18B20 device */
  for (i=0;i<devices;)
    if (!ds18b20_init(&rom_code[i++][0],20,30,DS18B20_9BIT_RES))
       {
       printf("Init error for device #%u",i);
       while (1); /* stop here if init error */
       };

//  while (1)
//      {
//          printf(" t(FETs)=%i C",(int)ds18b20_temperature(&rom_code[1][0]));
//          printf("t(Water)=%i C",(int)ds18b20_temperature(&rom_code[0][0]));
//          delay_ms(1000);
//      }; 
     
  for(i=0;i<3;i++){
  delay_ms(500);
  LED=1;
  delay_ms(500);
  LED=0;
  }
  
  RELAY_CAP_ON;
     
  printf("t(FETs)=  %i C",(int)ds18b20_temperature(&rom_code[0][0]));
  printf("t(Water)= %i C",(int)ds18b20_temperature(&rom_code[1][0]));
  
  delay_ms(500);
  
  RELAY_PWR_ON;
  
  printf("WARM-UP IN PROGRESS...");

 //===���� ������. ������� ������� ������� ������� �����      
  #asm("sei")
  while (i < (WARM_TIME*3)) { //���� WARM_TIME ������, ���� ����������
  i++; 
  tok=read_adc(0);
  
  //����, ���������� ��� � ���������� ������� ����� � ���������
  while (tok>30 && tok<315 && OCR2B<110){  //��� ������ ������������, �.�. ������� ������� ������, � ������ ����������
   OCR2B++;
   tok_old=tok;
   tok=read_adc(0);
   if (tok_old > tok)errors++; //������� ���������� ������, ����� ��������� ������� �������� � ��������� ���� �� � �� ������� (������ ����� ��������)
   if (errors > MAX_ERRORS){   //� ���� ������ ������� ����� - ������ � ������
    OCR2B=0;
    printf("Error: Auto-Ajust Failed");
    delay_ms(500);
    RELAY_PWR_OFF;
    while(1);
   }
  }
  errors=0;
  
  //���� ��� ���������, �������� ������� ������ �� ���������
   while (tok>325 && OCR2B>=0) {
   OCR2B--;
   tok_old=tok;
   tok=read_adc(0);
   if (tok_old < tok) errors++; //������� ���������� ������
   if (errors > MAX_ERRORS){    //� ���� ������� ����� - ������ � ������
   OCR2B=0;
   printf("Error: Auto-Ajust Failed");
   delay_ms(500);
   RELAY_PWR_OFF;
   while(1); 
   }
  }
  errors=0; 
  
  if (tok<30){
  OCR2B=0; //���� ������� ������� ������� - ������� ������� �� ��������� ������� (��������)
  printf("Error: Supply Under-Voltage");
  delay_ms(500);
  RELAY_PWR_OFF;
  while(1);
  }
  
  //������������� ��������
  fet_temp =   (int)ds18b20_temperature(&rom_code[0][0]);
  water_temp = (int)ds18b20_temperature(&rom_code[1][0]);
  
  if (fet_temp > 60)
  {
    OCR2B=0; //�������� ������� = �������� ���
    delay_ms(500); //���� �������
    RELAY_PWR_OFF; //�������� ������� �������
    printf("Error: FETs over-heat");
  }
  if (water_temp > 70)
  {
    OCR2B=0; //�������� ������� = �������� ���
    delay_ms(500); //���� �������
    RELAY_PWR_OFF; //�������� ������� �������
    printf("Error: Cooling Water over-heat");
  }
  printf("temp: %iC(FETs), %iC(Water)", fet_temp, water_temp);
 }
 
 if ((OCR2B < 30) || (OCR2B > 200)){    //���� ������� ������, �� ���������� OCR2B �� �������� � ��������, ���� ��������� - ����� ������ ���������� ������� �������
   OCR2B=0;
   printf("Error: Need to manual ajustment");
   delay_ms(500);
   RELAY_PWR_OFF;
   while(1); 
   }
 
 //---����� ������� �����
 
 printf("tok: %u, OCR2B: %u", tok, OCR2B);
 
 delay_ms(50);
 printf("WARM-UP SUCCESS");
 
 //===���� ������. ����������� ������� ��� �������
 //�������� ������� (�������� ���) � �������, ����� ��������� �������
   while (tok>240 && OCR2B>=0) {
   OCR2B--;
   tok=read_adc(0); 
   }
    
  printf("Place sample into inductor in 10 seconds");
  
  i=0;
  while(i < MELT_TIME)
  {
    i++;
    
    //������������� ��������
    fet_temp =   (int)ds18b20_temperature(&rom_code[0][0]);
    water_temp = (int)ds18b20_temperature(&rom_code[1][0]);
    
    if (fet_temp > 60)
    {
      OCR2B=0; //�������� ������� = �������� ���
      delay_ms(500); //���� �������
      RELAY_PWR_OFF; //�������� ������� �������
      printf("Error: FETs over-heat");
    }
    if (water_temp > 70)
    {
      OCR2B=0; //�������� ������� = �������� ���
      delay_ms(500); //���� �������
      RELAY_PWR_OFF; //�������� ������� �������
      printf("Error: Cooling Water over-heat");
    }
    printf("temp: %iC(FETs), %iC(Water)", fet_temp, water_temp);
    delay_ms(700); //������ ���� �����, ����� MELT_TIME � ������� ����� ��������������� �������� (����� ���� ���� ���������� �� 1 �������)
  }
  
  //---����� ������� �����
  
  OCR2B=0;
  printf("Melting overtime. Turn-Off.");
  delay_ms(500);
  RELAY_PWR_OFF;
}
