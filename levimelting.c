/*
 * levimelting.c
 *
 * Created: 09.02.2016 23:31:09
 * Author: Falcon
 */

#include <io.h>
#include <delay.h>

#define LED PORTB.5

/*
//прерывание для энкодера
// Pin change 16-23 interrupt service routine
interrupt [PC_INT2] void pin_change_isr2(void)
{
//PCMSK2=0;

 if (!PIND.4) {
  if (PIND.5) {if(OCR2B>0) OCR2B--;}
  else {if(OCR2B<255) OCR2B++;}
  delay_us(800);
 }
 while( (!PIND.4) || (!PIND.5) );
}
*/

// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void){
PORTB.0=1;
delay_us(1);
PORTB.0=0;
}

void main(void){
  int i=1;
  
  DDRD.2=DDRD.3=1;
  DDRB.5=1;
  
  DDRD.4=DDRD.5=0;
  PORTD.4=PORTD.5=1;
  
  DDRB.0=1;
  PORTB.0=0;
  
  //таймер, уравляющий ШИМ
  TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
  TCCR2B=(1<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
  TCNT2=0x00;
  OCR2A=255;   //общий период
  OCR2B=20;    //время высокого уровня
  
  // Настройка Прерывания для энкодера
  PCICR=(1<<PCIE2);
  PCMSK2=(1<<PCINT20);
  PCIFR=(1<<PCIF2);
  
  // Analog Comparator initialization
  // Interrupt on Rising Output Edge
  ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
  ADCSRB=(0<<ACME);
  // Digital input buffer on AIN0: Off
  // Digital input buffer on AIN1: Off
  DIDR1=(1<<AIN0D) | (1<<AIN1D);
        
  while (1){
  #asm("sei") 
  //PCMSK2=(1<<PCINT20);
  //OCR2B=50;
    //for (OCR2B=0; OCR2B<180; OCR2B++) delay_ms(10);
    
    //for (OCR2B=180; OCR2B>1; OCR2B--) delay_ms(10);
  }
}
