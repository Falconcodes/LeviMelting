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
////PORTD = 0; //оба выхода в нижний уровень
////PORTD = ~portbuf; //меняем состояние выводовна противоположное тому, что было
////portbuf = PORTD;  //запоминаем новое состояние буфера
//PORTD = ~PORTD;
//}

void main(void){
  
  DDRD.2=DDRD.3=1;
  
/*  
//  TCCR0A=(1<<WGM01);
//  TCCR0B=(1<<CS00);
//  OCR0A=0x20;

  
//  //Настройка прерывания по таймеру
//  TIMSK0=(1<<OCIE0A);
  
//  PORTD.2=1; //первоначальное состояние
//  portbuf = PORTD; //вносим состояние порта в буфер
*/

  TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
  TCCR2B=(1<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
  TCNT2=0x00;
  OCR2A=0x4F;   //общий период
  OCR2B=0xF;    //время высокого уровня
  
  
  // Global enable interrupts
  #asm("sei")
      
  while (1){};

}
