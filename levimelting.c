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

PORTD = 0; //оба выхода в нижний уровень
PORTD = ~portbuf; //мен€ем состо€ние выводовна противоположное тому, что было
portbuf = PORTD;  //запоминаем новое состо€ние буфера

}

void main(void){
  PORTD=0;
  DDRD.2=DDRD.3=1;
  PORTD=0;  
  
  // Timer/Counter 0 initialization. ќстальные регистры остаютс€ по умолчанию - нулевые.
  TCCR0B=(1<<CS00);
  TCNT0=0xFE; 
    
  PORTD.2=1; //первоначальное состо€ние
  portbuf = PORTD; //вносим состо€ние порта в буфер
  
  //Ќастройка прерывани€ по таймеру
  TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

  // Global enable interrupts
  #asm("sei")
  
  while (1){};

}
