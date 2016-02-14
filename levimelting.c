/*
 * levimelting.c
 *
 * Created: 09.02.2016 23:31:09
 * Author: Falcon
 */

#include <io.h>
#include <delay.h>

#define LED PORTB.5


//interrupt [TIM0_COMPA] void timer0_compa_isr(void)
//{
////PORTD = 0; //��� ������ � ������ �������
////PORTD = ~portbuf; //������ ��������� ��������� ��������������� ����, ��� ����
////portbuf = PORTD;  //���������� ����� ��������� ������
//PORTD = ~PORTD;
//}

void main(void){
  
  DDRD.2=DDRD.3=1;
  
/*  
//  TCCR0A=(1<<WGM01);
//  TCCR0B=(1<<CS00);
//  OCR0A=0x20;

  
//  //��������� ���������� �� �������
//  TIMSK0=(1<<OCIE0A);
  
//  PORTD.2=1; //�������������� ���������
//  portbuf = PORTD; //������ ��������� ����� � �����
*/

  TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
  TCCR2B=(1<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
  TCNT2=0x00;
  OCR2A=0x4F;   //����� ������
  OCR2B=0xF;    //����� �������� ������
  
  
  // Global enable interrupts
  #asm("sei")
      
  while (1){};

}
