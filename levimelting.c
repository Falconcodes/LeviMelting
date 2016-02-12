/*
 * levimelting.c
 *
 * Created: 09.02.2016 23:31:09
 * Author: Falcon
 */

#include <io.h>
#include <delay.h>

#define LED PORTB.5

char portbuf;


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void) {

TCNT0 = 0xEE; // Reinitialize Timer 0 value

PORTD = 0; //��� ������ � ������ �������
PORTD = ~portbuf; //������ ��������� ��������� ��������������� ����, ��� ����
portbuf = PORTD;  //���������� ����� ��������� ������

}

void main(void){
  PORTD=0;
  DDRD.2=DDRD.3=1;
  PORTD=0;  
  
  // Timer/Counter 0 initialization. ��������� �������� �������� �� ��������� - �������.
  TCCR0B=(1<<CS00);
  TCNT0=0xFE; 
    
  PORTD.2=1; //�������������� ���������
  portbuf = PORTD; //������ ��������� ����� � �����
  
  //��������� ���������� �� �������
  TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

  // Global enable interrupts
  #asm("sei")
  
  while (1){};

}
