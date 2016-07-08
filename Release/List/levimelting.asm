
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width, precision
;(s)scanf features      : long, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _tok=R3
	.DEF _tok_msb=R4
	.DEF _tok_old=R5
	.DEF _tok_old_msb=R6
	.DEF _errors=R8

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_conv_delay_G100:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G100:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

_0x0:
	.DB  0x4C,0x4F,0x41,0x44,0x49,0x4E,0x47,0x2E
	.DB  0x2E,0x2E,0x0,0x54,0x65,0x6D,0x70,0x2E
	.DB  0x20,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C
	.DB  0x20,0x72,0x65,0x61,0x64,0x79,0x0,0x45
	.DB  0x72,0x72,0x6F,0x72,0x3A,0x20,0x25,0x75
	.DB  0x20,0x74,0x65,0x6D,0x70,0x2E,0x73,0x65
	.DB  0x6E,0x73,0x6F,0x72,0x28,0x73,0x29,0x20
	.DB  0x6E,0x6F,0x74,0x20,0x66,0x6F,0x75,0x6E
	.DB  0x64,0x0,0x49,0x6E,0x69,0x74,0x20,0x65
	.DB  0x72,0x72,0x6F,0x72,0x20,0x66,0x6F,0x72
	.DB  0x20,0x64,0x65,0x76,0x69,0x63,0x65,0x20
	.DB  0x23,0x25,0x75,0x0,0x74,0x28,0x46,0x45
	.DB  0x54,0x73,0x29,0x3D,0x20,0x20,0x25,0x69
	.DB  0x20,0x43,0x0,0x74,0x28,0x57,0x61,0x74
	.DB  0x65,0x72,0x29,0x3D,0x20,0x25,0x69,0x20
	.DB  0x43,0x0,0x57,0x41,0x52,0x4D,0x2D,0x55
	.DB  0x50,0x20,0x49,0x4E,0x20,0x50,0x52,0x4F
	.DB  0x47,0x52,0x45,0x53,0x53,0x2E,0x2E,0x2E
	.DB  0x0,0x45,0x72,0x72,0x6F,0x72,0x3A,0x20
	.DB  0x41,0x75,0x74,0x6F,0x2D,0x41,0x6A,0x75
	.DB  0x73,0x74,0x20,0x46,0x61,0x69,0x6C,0x65
	.DB  0x64,0x0,0x45,0x72,0x72,0x6F,0x72,0x3A
	.DB  0x20,0x53,0x75,0x70,0x70,0x6C,0x79,0x20
	.DB  0x55,0x6E,0x64,0x65,0x72,0x2D,0x56,0x6F
	.DB  0x6C,0x74,0x61,0x67,0x65,0x0,0x45,0x72
	.DB  0x72,0x6F,0x72,0x3A,0x20,0x46,0x45,0x54
	.DB  0x73,0x20,0x6F,0x76,0x65,0x72,0x2D,0x68
	.DB  0x65,0x61,0x74,0x0,0x45,0x72,0x72,0x6F
	.DB  0x72,0x3A,0x20,0x43,0x6F,0x6F,0x6C,0x69
	.DB  0x6E,0x67,0x20,0x57,0x61,0x74,0x65,0x72
	.DB  0x20,0x6F,0x76,0x65,0x72,0x2D,0x68,0x65
	.DB  0x61,0x74,0x0,0x74,0x65,0x6D,0x70,0x3A
	.DB  0x20,0x25,0x69,0x43,0x28,0x46,0x45,0x54
	.DB  0x73,0x29,0x2C,0x20,0x25,0x69,0x43,0x28
	.DB  0x57,0x61,0x74,0x65,0x72,0x29,0x0,0x45
	.DB  0x72,0x72,0x6F,0x72,0x3A,0x20,0x4E,0x65
	.DB  0x65,0x64,0x20,0x74,0x6F,0x20,0x6D,0x61
	.DB  0x6E,0x75,0x61,0x6C,0x20,0x61,0x6A,0x75
	.DB  0x73,0x74,0x6D,0x65,0x6E,0x74,0x0,0x74
	.DB  0x6F,0x6B,0x3A,0x20,0x25,0x75,0x2C,0x20
	.DB  0x4F,0x43,0x52,0x32,0x42,0x3A,0x20,0x25
	.DB  0x75,0x0,0x57,0x41,0x52,0x4D,0x2D,0x55
	.DB  0x50,0x20,0x53,0x55,0x43,0x43,0x45,0x53
	.DB  0x53,0x0,0x50,0x6C,0x61,0x63,0x65,0x20
	.DB  0x73,0x61,0x6D,0x70,0x6C,0x65,0x20,0x69
	.DB  0x6E,0x74,0x6F,0x20,0x69,0x6E,0x64,0x75
	.DB  0x63,0x74,0x6F,0x72,0x20,0x69,0x6E,0x20
	.DB  0x31,0x30,0x20,0x73,0x65,0x63,0x6F,0x6E
	.DB  0x64,0x73,0x0,0x4D,0x65,0x6C,0x74,0x69
	.DB  0x6E,0x67,0x20,0x6F,0x76,0x65,0x72,0x74
	.DB  0x69,0x6D,0x65,0x2E,0x20,0x54,0x75,0x72
	.DB  0x6E,0x2D,0x4F,0x66,0x66,0x2E,0x0
__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*
; * levimelting.c
; *
; * Created: 09.02.2016 23:31:09
; * Author: Falcon
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;#asm
        .equ __w1_port=0xB
        .equ __w1_bit=6
; 0000 000D #endasm
;
;#include <ds18b20.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdint.h>
;#include <stdbool.h>
;
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR)) //настройка референса для АЦП
;#define TOK_KOEF 5
;#define LED PORTB.5
;#define RELAY_CAP_ON  PORTD.5=0
;#define RELAY_CAP_OFF PORTD.5=1
;#define RELAY_PWR_ON  PORTD.4=0
;#define RELAY_PWR_OFF PORTD.4=1
;#define MAX_ERRORS 5 //число ошибок при автопрогреве, после которого уходит в защиту
;#define WARM_TIME 30 //секунд на прогрев
;#define MELT_TIME 90 //секунд на плавку
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input){
; 0000 0021 unsigned int read_adc(unsigned char adc_input){

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0022   int i;
; 0000 0023   unsigned long adc_summ=0;
; 0000 0024   ADMUX=adc_input | (0<<REFS1) | (1<<REFS0) | (0<<ADLAR);
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
;	adc_input -> Y+6
;	i -> R16,R17
;	adc_summ -> Y+2
	LDD  R30,Y+6
	ORI  R30,0x40
	STS  124,R30
; 0000 0025   // Delay needed for the stabilization of the ADC input voltage
; 0000 0026   delay_us(10);
	__DELAY_USB 53
; 0000 0027 
; 0000 0028    for (i=1; i<100; i++){
	__GETWRN 16,17,1
_0x4:
	__CPWRN 16,17,100
	BRLT PC+3
	JMP _0x5
; 0000 0029     // Start the AD conversion
; 0000 002A     ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 002B     // Wait for the AD conversion to complete
; 0000 002C     while ((ADCSRA & (1<<ADIF))==0);
_0x6:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ PC+3
	JMP _0x8
	RJMP _0x6
_0x8:
; 0000 002D     ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 002E     adc_summ+=ADCW;
	LDS  R30,120
	LDS  R31,120+1
	__GETD2S 2
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 2
; 0000 002F    }
_0x3:
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 0030   return adc_summ/100;
	__GETD2S 2
	__GETD1N 0x64
	CALL __DIVD21U
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; 0000 0031 }
; .FEND
;
;unsigned int tok, tok_old;
;unsigned char errors;
;
;/* maximum number of DS18B20 connected to the 1 Wire bus */
;#define MAX_DEVICES 2
;
;/* DS18B20 devices ROM code storage area */
;unsigned char rom_code[MAX_DEVICES][9];
;
;void main(void){
; 0000 003C void main(void){
_main:
; .FSTART _main
; 0000 003D   unsigned int i=0, fet_temp, water_temp;
; 0000 003E   unsigned char j,devices;
; 0000 003F 
; 0000 0040   RELAY_CAP_OFF;
	SBIW R28,2
;	i -> R16,R17
;	fet_temp -> R18,R19
;	water_temp -> R20,R21
;	j -> Y+1
;	devices -> Y+0
	__GETWRN 16,17,0
	SBI  0xB,5
; 0000 0041   RELAY_PWR_OFF;
	SBI  0xB,4
; 0000 0042 
; 0000 0043   DDRB.0=DDRB.3=DDRB.5=DDRD.2=DDRD.3=DDRD.4=DDRD.5=1;
	SBI  0xA,5
	SBI  0xA,4
	SBI  0xA,3
	SBI  0xA,2
	SBI  0x4,5
	SBI  0x4,3
	SBI  0x4,0
; 0000 0044   PORTB.0=0;
	CBI  0x5,0
; 0000 0045 
; 0000 0046   //таймер, управляющий ШИМ для водяного насоса и для подстройки частоты
; 0000 0047   TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(163)
	STS  176,R30
; 0000 0048   TCCR2B=(0<<WGM22) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(6)
	STS  177,R30
; 0000 0049   TCNT2=0;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 004A   OCR2B=0;    //период для частоты (больше = частота ниже)
	STS  180,R30
; 0000 004B   OCR2A=50;   //период для насоса (больше = больше напор и громче работает)
	LDI  R30,LOW(50)
	STS  179,R30
; 0000 004C 
; 0000 004D   // ADC initialization 125,000 kHz  AVCC pin ADC Stopped
; 0000 004E   DIDR0=(1<<ADC5D) | (1<<ADC4D) | (1<<ADC3D) | (1<<ADC2D) | (1<<ADC1D) | (0<<ADC0D);
	LDI  R30,LOW(62)
	STS  126,R30
; 0000 004F   ADCSRA=(1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	STS  122,R30
; 0000 0050 
; 0000 0051   // USART initialization 8 Data, 1 Stop, No Parity Asynchronous Baud Rate: 9600
; 0000 0052   UCSR0B=(1<<TXEN0);
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 0053   UCSR0C=((1<<UCSZ01) | (1<<UCSZ00));
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0054   UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 0055 
; 0000 0056   OCR2B=0;
	LDI  R30,LOW(0)
	STS  180,R30
; 0000 0057 
; 0000 0058   printf("LOADING...");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x0
; 0000 0059 
; 0000 005A   /*searching for ds18b20 sensors*/
; 0000 005B   devices=w1_search(0xf0,rom_code);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R26,LOW(_rom_code)
	LDI  R27,HIGH(_rom_code)
	CALL _w1_search
	ST   Y,R30
; 0000 005C   if (devices == 2) printf("Temp. control ready",devices);
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x1D
	__POINTW1FN _0x0,11
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
; 0000 005D   else printf("Error: %u temp.sensor(s) not found",devices, (2-devices));
	RJMP _0x1E
_0x1D:
	__POINTW1FN _0x0,31
	CALL SUBOPT_0x1
	LDD  R30,Y+6
	LDI  R31,0
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0000 005E   /* configure each DS18B20 device */
; 0000 005F   for (i=0;i<devices;)
_0x1E:
	__GETWRN 16,17,0
_0x20:
	LD   R30,Y
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x21
; 0000 0060     if (!ds18b20_init(&rom_code[i++][0],20,30,DS18B20_9BIT_RES))
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL __MULW12U
	SUBI R30,LOW(-_rom_code)
	SBCI R31,HIGH(-_rom_code)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _ds18b20_init
	CPI  R30,0
	BREQ PC+3
	JMP _0x22
; 0000 0061        {
; 0000 0062        printf("Init error for device #%u",i);
	__POINTW1FN _0x0,66
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0x5
	CALL SUBOPT_0x2
; 0000 0063        while (1); /* stop here if init error */
_0x23:
	RJMP _0x23
_0x25:
; 0000 0064        };
_0x22:
_0x1F:
	RJMP _0x20
_0x21:
; 0000 0065 
; 0000 0066 //  while (1)
; 0000 0067 //      {
; 0000 0068 //          printf(" t(FETs)=%i C",(int)ds18b20_temperature(&rom_code[1][0]));
; 0000 0069 //          printf("t(Water)=%i C",(int)ds18b20_temperature(&rom_code[0][0]));
; 0000 006A //          delay_ms(1000);
; 0000 006B //      };
; 0000 006C 
; 0000 006D   for(i=0;i<3;i++){
	__GETWRN 16,17,0
_0x27:
	__CPWRN 16,17,3
	BRLO PC+3
	JMP _0x28
; 0000 006E   delay_ms(500);
	CALL SUBOPT_0x6
; 0000 006F   LED=1;
	SBI  0x5,5
; 0000 0070   delay_ms(500);
	CALL SUBOPT_0x6
; 0000 0071   LED=0;
	CBI  0x5,5
; 0000 0072   }
_0x26:
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 0073 
; 0000 0074   RELAY_CAP_ON;
	CBI  0xB,5
; 0000 0075 
; 0000 0076   printf("t(FETs)=  %i C",(int)ds18b20_temperature(&rom_code[0][0]));
	__POINTW1FN _0x0,92
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2
; 0000 0077   printf("t(Water)= %i C",(int)ds18b20_temperature(&rom_code[1][0]));
	__POINTW1FN _0x0,107
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2
; 0000 0078 
; 0000 0079   delay_ms(500);
	CALL SUBOPT_0x6
; 0000 007A 
; 0000 007B   RELAY_PWR_ON;
	CBI  0xB,4
; 0000 007C 
; 0000 007D   printf("WARM-UP IN PROGRESS...");
	__POINTW1FN _0x0,122
	CALL SUBOPT_0x0
; 0000 007E 
; 0000 007F  //===ЭТАП ПЕРВЫЙ. Прогрев пустого контура большим током
; 0000 0080   #asm("sei")
	sei
; 0000 0081   while (i < (WARM_TIME*3)) { //ждем WARM_TIME секунд, пока прогреется
_0x31:
	__CPWRN 16,17,90
	BRLO PC+3
	JMP _0x33
; 0000 0082   i++;
	__ADDWRN 16,17,1
; 0000 0083   tok=read_adc(0);
	CALL SUBOPT_0x9
; 0000 0084 
; 0000 0085   //цикл, повышающий ток и понижающий частоту ближе к резонансу
; 0000 0086   while (tok>30 && tok<315 && OCR2B<110){  //ток больше минимального, т.е. питание силовой подано, и меньше требуемого
_0x34:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R3
	CPC  R31,R4
	BRLO PC+3
	JMP _0x37
	LDI  R30,LOW(315)
	LDI  R31,HIGH(315)
	CP   R3,R30
	CPC  R4,R31
	BRLO PC+3
	JMP _0x37
	LDS  R26,180
	CPI  R26,LOW(0x6E)
	BRLO PC+3
	JMP _0x37
	RJMP _0x38
_0x37:
	RJMP _0x36
_0x38:
; 0000 0087    OCR2B++;
	LDI  R26,LOW(180)
	LDI  R27,HIGH(180)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0088    tok_old=tok;
	__MOVEWRR 5,6,3,4
; 0000 0089    tok=read_adc(0);
	CALL SUBOPT_0x9
; 0000 008A    if (tok_old > tok)errors++; //считаем количество ошибок, когда изменение частоты приводит к изменению тока не в ту ст ...
	__CPWRR 3,4,5,6
	BRLO PC+3
	JMP _0x39
	INC  R8
; 0000 008B    if (errors > MAX_ERRORS){   //и если ошибок слишком много - уходим в защиту
_0x39:
	LDI  R30,LOW(5)
	CP   R30,R8
	BRLO PC+3
	JMP _0x3A
; 0000 008C     OCR2B=0;
	CALL SUBOPT_0xA
; 0000 008D     printf("Error: Auto-Ajust Failed");
; 0000 008E     delay_ms(500);
	CALL SUBOPT_0x6
; 0000 008F     RELAY_PWR_OFF;
	SBI  0xB,4
; 0000 0090     while(1);
_0x3D:
	RJMP _0x3D
_0x3F:
; 0000 0091    }
; 0000 0092   }
_0x3A:
	RJMP _0x34
_0x36:
; 0000 0093   errors=0;
	CLR  R8
; 0000 0094 
; 0000 0095   //если ток превышает, повышаем частоту дальше от резонанса
; 0000 0096    while (tok>325 && OCR2B>=0) {
_0x40:
	LDI  R30,LOW(325)
	LDI  R31,HIGH(325)
	CP   R30,R3
	CPC  R31,R4
	BRLO PC+3
	JMP _0x43
	LDS  R26,180
	CPI  R26,0
	BRSH PC+3
	JMP _0x43
	RJMP _0x44
_0x43:
	RJMP _0x42
_0x44:
; 0000 0097    OCR2B--;
	LDI  R26,LOW(180)
	LDI  R27,HIGH(180)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 0098    tok_old=tok;
	__MOVEWRR 5,6,3,4
; 0000 0099    tok=read_adc(0);
	CALL SUBOPT_0x9
; 0000 009A    if (tok_old < tok) errors++; //считаем количество ошибок
	__CPWRR 5,6,3,4
	BRLO PC+3
	JMP _0x45
	INC  R8
; 0000 009B    if (errors > MAX_ERRORS){    //и если слишком много - уходим в защиту
_0x45:
	LDI  R30,LOW(5)
	CP   R30,R8
	BRLO PC+3
	JMP _0x46
; 0000 009C    OCR2B=0;
	CALL SUBOPT_0xA
; 0000 009D    printf("Error: Auto-Ajust Failed");
; 0000 009E    delay_ms(500);
	CALL SUBOPT_0x6
; 0000 009F    RELAY_PWR_OFF;
	SBI  0xB,4
; 0000 00A0    while(1);
_0x49:
	RJMP _0x49
_0x4B:
; 0000 00A1    }
; 0000 00A2   }
_0x46:
	RJMP _0x40
_0x42:
; 0000 00A3   errors=0;
	CLR  R8
; 0000 00A4 
; 0000 00A5   if (tok<30){
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R3,R30
	CPC  R4,R31
	BRLO PC+3
	JMP _0x4C
; 0000 00A6   OCR2B=0; //если пропало силовое питание - выводим частоту на начальный уровень (максимум)
	LDI  R30,LOW(0)
	STS  180,R30
; 0000 00A7   printf("Error: Supply Under-Voltage");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x0
; 0000 00A8   delay_ms(500);
	CALL SUBOPT_0x6
; 0000 00A9   RELAY_PWR_OFF;
	SBI  0xB,4
; 0000 00AA   while(1);
_0x4F:
	RJMP _0x4F
_0x51:
; 0000 00AB   }
; 0000 00AC 
; 0000 00AD   //температурный контроль
; 0000 00AE   fet_temp =   (int)ds18b20_temperature(&rom_code[0][0]);
_0x4C:
	CALL SUBOPT_0x7
	MOVW R18,R30
; 0000 00AF   water_temp = (int)ds18b20_temperature(&rom_code[1][0]);
	CALL SUBOPT_0x8
	MOVW R20,R30
; 0000 00B0 
; 0000 00B1   if (fet_temp > 60)
	__CPWRN 18,19,61
	BRSH PC+3
	JMP _0x52
; 0000 00B2   {
; 0000 00B3     OCR2B=0; //завышаем частоту = занижаем ток
	CALL SUBOPT_0xB
; 0000 00B4     delay_ms(500); //ждем реакции
; 0000 00B5     RELAY_PWR_OFF; //отрубаем питание силовой
	SBI  0xB,4
; 0000 00B6     printf("Error: FETs over-heat");
	__POINTW1FN _0x0,198
	CALL SUBOPT_0x0
; 0000 00B7   }
; 0000 00B8   if (water_temp > 70)
_0x52:
	__CPWRN 20,21,71
	BRSH PC+3
	JMP _0x55
; 0000 00B9   {
; 0000 00BA     OCR2B=0; //завышаем частоту = занижаем ток
	CALL SUBOPT_0xB
; 0000 00BB     delay_ms(500); //ждем реакции
; 0000 00BC     RELAY_PWR_OFF; //отрубаем питание силовой
	SBI  0xB,4
; 0000 00BD     printf("Error: Cooling Water over-heat");
	__POINTW1FN _0x0,220
	CALL SUBOPT_0x0
; 0000 00BE   }
; 0000 00BF   printf("temp: %iC(FETs), %iC(Water)", fet_temp, water_temp);
_0x55:
	CALL SUBOPT_0xC
	MOVW R30,R20
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
; 0000 00C0  }
	RJMP _0x31
_0x33:
; 0000 00C1 
; 0000 00C2  if ((OCR2B < 30) || (OCR2B > 200)){    //если прогрев прошел, но устойчивый OCR2B не попадает в диапазон, тоже отключае ...
	LDS  R26,180
	CPI  R26,LOW(0x1E)
	BRSH PC+3
	JMP _0x59
	LDS  R26,180
	CPI  R26,LOW(0xC9)
	BRLO PC+3
	JMP _0x59
	RJMP _0x58
_0x59:
; 0000 00C3    OCR2B=0;
	LDI  R30,LOW(0)
	STS  180,R30
; 0000 00C4    printf("Error: Need to manual ajustment");
	__POINTW1FN _0x0,279
	CALL SUBOPT_0x0
; 0000 00C5    delay_ms(500);
	CALL SUBOPT_0x6
; 0000 00C6    RELAY_PWR_OFF;
	SBI  0xB,4
; 0000 00C7    while(1);
_0x5D:
	RJMP _0x5D
_0x5F:
; 0000 00C8    }
; 0000 00C9 
; 0000 00CA  //---КОНЕЦ ПЕРВОГО ЭТАПА
; 0000 00CB 
; 0000 00CC  printf("tok: %u, OCR2B: %u", tok, OCR2B);
_0x58:
	__POINTW1FN _0x0,311
	ST   -Y,R31
	ST   -Y,R30
	__GETW1R 3,4
	CALL SUBOPT_0x5
	LDS  R30,180
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	CALL SUBOPT_0x4
; 0000 00CD 
; 0000 00CE  delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 00CF  printf("WARM-UP SUCCESS");
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x0
; 0000 00D0 
; 0000 00D1  //===ЭТАП ВТОРОЙ. Перестройка частоты под образец
; 0000 00D2  //повышаем частоту (понижаем ток) с запасом, перед внесением образца
; 0000 00D3    while (tok>240 && OCR2B>=0) {
_0x60:
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CP   R30,R3
	CPC  R31,R4
	BRLO PC+3
	JMP _0x63
	LDS  R26,180
	CPI  R26,0
	BRSH PC+3
	JMP _0x63
	RJMP _0x64
_0x63:
	RJMP _0x62
_0x64:
; 0000 00D4    OCR2B--;
	LDI  R26,LOW(180)
	LDI  R27,HIGH(180)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 00D5    tok=read_adc(0);
	CALL SUBOPT_0x9
; 0000 00D6    }
	RJMP _0x60
_0x62:
; 0000 00D7 
; 0000 00D8   printf("Place sample into inductor in 10 seconds");
	__POINTW1FN _0x0,346
	CALL SUBOPT_0x0
; 0000 00D9 
; 0000 00DA   i=0;
	__GETWRN 16,17,0
; 0000 00DB   while(i < MELT_TIME)
_0x65:
	__CPWRN 16,17,90
	BRLO PC+3
	JMP _0x67
; 0000 00DC   {
; 0000 00DD     i++;
	__ADDWRN 16,17,1
; 0000 00DE 
; 0000 00DF     //температурный контроль
; 0000 00E0     fet_temp =   (int)ds18b20_temperature(&rom_code[0][0]);
	CALL SUBOPT_0x7
	MOVW R18,R30
; 0000 00E1     water_temp = (int)ds18b20_temperature(&rom_code[1][0]);
	CALL SUBOPT_0x8
	MOVW R20,R30
; 0000 00E2 
; 0000 00E3     if (fet_temp > 60)
	__CPWRN 18,19,61
	BRSH PC+3
	JMP _0x68
; 0000 00E4     {
; 0000 00E5       OCR2B=0; //завышаем частоту = занижаем ток
	CALL SUBOPT_0xB
; 0000 00E6       delay_ms(500); //ждем реакции
; 0000 00E7       RELAY_PWR_OFF; //отрубаем питание силовой
	SBI  0xB,4
; 0000 00E8       printf("Error: FETs over-heat");
	__POINTW1FN _0x0,198
	CALL SUBOPT_0x0
; 0000 00E9     }
; 0000 00EA     if (water_temp > 70)
_0x68:
	__CPWRN 20,21,71
	BRSH PC+3
	JMP _0x6B
; 0000 00EB     {
; 0000 00EC       OCR2B=0; //завышаем частоту = занижаем ток
	CALL SUBOPT_0xB
; 0000 00ED       delay_ms(500); //ждем реакции
; 0000 00EE       RELAY_PWR_OFF; //отрубаем питание силовой
	SBI  0xB,4
; 0000 00EF       printf("Error: Cooling Water over-heat");
	__POINTW1FN _0x0,220
	CALL SUBOPT_0x0
; 0000 00F0     }
; 0000 00F1     printf("temp: %iC(FETs), %iC(Water)", fet_temp, water_temp);
_0x6B:
	CALL SUBOPT_0xC
	MOVW R30,R20
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
; 0000 00F2     delay_ms(700); //подбор этой паузы, чтобы MELT_TIME в условии цикла соответствовало секундам (чтобы весь цикл выполн ...
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	CALL _delay_ms
; 0000 00F3   }
	RJMP _0x65
_0x67:
; 0000 00F4 
; 0000 00F5   //---КОНЕЦ ВТОРОГО ЭТАПА
; 0000 00F6 
; 0000 00F7   OCR2B=0;
	LDI  R30,LOW(0)
	STS  180,R30
; 0000 00F8   printf("Melting overtime. Turn-Off.");
	__POINTW1FN _0x0,387
	CALL SUBOPT_0x0
; 0000 00F9   delay_ms(500);
	CALL SUBOPT_0x6
; 0000 00FA   RELAY_PWR_OFF;
	SBI  0xB,4
; 0000 00FB }
	ADIW R28,2
_0x70:
	RJMP _0x70
; .FEND

	.CSEG
_ds18b20_select:
; .FSTART _ds18b20_select
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	CALL _w1_init
	CPI  R30,0
	BREQ PC+3
	JMP _0x2000003
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	ADIW R28,3
	RET
_0x2000003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x2000004
	LDI  R26,LOW(85)
	CALL _w1_write
	LDI  R17,LOW(0)
_0x2000006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R26,R30
	CALL _w1_write
_0x2000005:
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO PC+3
	JMP _0x2000007
	RJMP _0x2000006
_0x2000007:
	RJMP _0x2000008
_0x2000004:
	LDI  R26,LOW(204)
	CALL _w1_write
_0x2000008:
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_ds18b20_read_spd:
; .FSTART _ds18b20_read_spd
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _ds18b20_select
	CPI  R30,0
	BREQ PC+3
	JMP _0x2000009
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	ADIW R28,6
	RET
_0x2000009:
	LDI  R26,LOW(190)
	CALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x200000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
_0x200000A:
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO PC+3
	JMP _0x200000C
	RJMP _0x200000B
_0x200000C:
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	CALL _w1_dow_crc8
	CALL __LNEGB1
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
_ds18b20_temperature:
; .FSTART _ds18b20_temperature
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL _ds18b20_read_spd
	CPI  R30,0
	BREQ PC+3
	JMP _0x200000D
	CALL SUBOPT_0xD
	RET
_0x200000D:
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL _ds18b20_select
	CPI  R30,0
	BREQ PC+3
	JMP _0x200000E
	CALL SUBOPT_0xD
	RET
_0x200000E:
	LDI  R26,LOW(68)
	CALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G100*2)
	LDI  R27,HIGH(_conv_delay_G100*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW2PF
	CALL _delay_ms
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL _ds18b20_read_spd
	CPI  R30,0
	BREQ PC+3
	JMP _0x200000F
	CALL SUBOPT_0xD
	RET
_0x200000F:
	CALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G100*2)
	LDI  R27,HIGH(_bit_mask_G100*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3D800000
	CALL __MULF12
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_ds18b20_init:
; .FSTART _ds18b20_init
	ST   -Y,R26
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL _ds18b20_select
	CPI  R30,0
	BREQ PC+3
	JMP _0x2000010
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2000010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R26,LOW(78)
	CALL _w1_write
	LDD  R26,Y+1
	CALL _w1_write
	LDD  R26,Y+2
	CALL _w1_write
	LD   R26,Y
	CALL _w1_write
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL _ds18b20_read_spd
	CPI  R30,0
	BREQ PC+3
	JMP _0x2000011
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2000011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BREQ PC+3
	JMP _0x2000013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BREQ PC+3
	JMP _0x2000013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ PC+3
	JMP _0x2000013
	RJMP _0x2000012
_0x2000013:
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2000012:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL _ds18b20_select
	CPI  R30,0
	BREQ PC+3
	JMP _0x2000015
	LDI  R30,LOW(0)
	ADIW R28,5
	RET
_0x2000015:
	LDI  R26,LOW(72)
	CALL _w1_write
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
	CALL _w1_init
	ADIW R28,5
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
_0x2020006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ PC+3
	JMP _0x2020008
	RJMP _0x2020006
_0x2020008:
	LD   R30,Y
	STS  198,R30
	ADIW R28,1
	RET
; .FEND
_put_usart_G101:
; .FSTART _put_usart_G101
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x202001C:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ADIW R30,1
	STD  Y+24,R30
	STD  Y+24+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x202001E
	MOV  R30,R17
	CPI  R30,0
	BREQ PC+3
	JMP _0x2020022
	CPI  R18,37
	BREQ PC+3
	JMP _0x2020023
	LDI  R17,LOW(1)
	RJMP _0x2020024
_0x2020023:
	CALL SUBOPT_0xE
_0x2020024:
	RJMP _0x2020021
_0x2020022:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x2020025
	CPI  R18,37
	BREQ PC+3
	JMP _0x2020026
	CALL SUBOPT_0xE
	LDI  R17,LOW(0)
	RJMP _0x2020021
_0x2020026:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+3
	JMP _0x2020027
	LDI  R16,LOW(1)
	RJMP _0x2020021
_0x2020027:
	CPI  R18,43
	BREQ PC+3
	JMP _0x2020028
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x2020021
_0x2020028:
	CPI  R18,32
	BREQ PC+3
	JMP _0x2020029
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x2020021
_0x2020029:
	RJMP _0x202002A
_0x2020025:
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x202002B
_0x202002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+3
	JMP _0x202002C
	ORI  R16,LOW(128)
	RJMP _0x2020021
_0x202002C:
	RJMP _0x202002D
_0x202002B:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x202002E
_0x202002D:
	CPI  R18,48
	BRSH PC+3
	JMP _0x2020030
	CPI  R18,58
	BRLO PC+3
	JMP _0x2020030
	RJMP _0x2020031
_0x2020030:
	RJMP _0x202002F
_0x2020031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020021
_0x202002F:
	LDI  R20,LOW(0)
	CPI  R18,46
	BREQ PC+3
	JMP _0x2020032
	LDI  R17,LOW(4)
	RJMP _0x2020021
_0x2020032:
	RJMP _0x2020033
	RJMP _0x2020034
_0x202002E:
	CPI  R30,LOW(0x4)
	BREQ PC+3
	JMP _0x2020035
_0x2020034:
	CPI  R18,48
	BRSH PC+3
	JMP _0x2020037
	CPI  R18,58
	BRLO PC+3
	JMP _0x2020037
	RJMP _0x2020038
_0x2020037:
	RJMP _0x2020036
_0x2020038:
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020021
_0x2020036:
_0x2020033:
	CPI  R18,108
	BREQ PC+3
	JMP _0x2020039
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020021
_0x2020039:
	RJMP _0x202003A
_0x2020035:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2020021
_0x202003A:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BREQ PC+3
	JMP _0x202003F
	CALL SUBOPT_0xF
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x10
	RJMP _0x2020040
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x73)
	BREQ PC+3
	JMP _0x2020042
_0x2020041:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020043
	RJMP _0x2020044
_0x2020042:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x2020045
_0x2020044:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020043:
	ANDI R16,LOW(127)
	CPI  R20,0
	BRNE PC+3
	JMP _0x2020047
	CP   R20,R17
	BRLO PC+3
	JMP _0x2020047
	RJMP _0x2020048
_0x2020047:
	RJMP _0x2020046
_0x2020048:
	MOV  R17,R20
_0x2020046:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2020049
	RJMP _0x202004A
_0x2020045:
	CPI  R30,LOW(0x64)
	BREQ PC+3
	JMP _0x202004B
_0x202004A:
	RJMP _0x202004C
_0x202004B:
	CPI  R30,LOW(0x69)
	BREQ PC+3
	JMP _0x202004D
_0x202004C:
	ORI  R16,LOW(4)
	RJMP _0x202004E
_0x202004D:
	CPI  R30,LOW(0x75)
	BREQ PC+3
	JMP _0x202004F
_0x202004E:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2020050
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x12
	LDI  R17,LOW(10)
	RJMP _0x2020051
_0x2020050:
	__GETD1N 0x2710
	CALL SUBOPT_0x12
	LDI  R17,LOW(5)
	RJMP _0x2020051
	RJMP _0x2020052
_0x202004F:
	CPI  R30,LOW(0x58)
	BREQ PC+3
	JMP _0x2020053
_0x2020052:
	ORI  R16,LOW(8)
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2020092
_0x2020054:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2020056
	__GETD1N 0x10000000
	CALL SUBOPT_0x12
	LDI  R17,LOW(8)
	RJMP _0x2020051
_0x2020056:
	__GETD1N 0x1000
	CALL SUBOPT_0x12
	LDI  R17,LOW(4)
_0x2020051:
	CPI  R20,0
	BRNE PC+3
	JMP _0x2020057
	ANDI R16,LOW(127)
	RJMP _0x2020058
_0x2020057:
	LDI  R20,LOW(1)
_0x2020058:
	SBRS R16,1
	RJMP _0x2020059
	CALL SUBOPT_0xF
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETD1P
	CALL SUBOPT_0x13
	RJMP _0x202005A
_0x2020059:
	SBRS R16,2
	RJMP _0x202005B
	CALL SUBOPT_0xF
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	CALL SUBOPT_0x13
	RJMP _0x202005C
_0x202005B:
	CALL SUBOPT_0xF
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x13
_0x202005C:
_0x202005A:
	SBRS R16,2
	RJMP _0x202005D
	LDD  R26,Y+15
	TST  R26
	BRMI PC+3
	JMP _0x202005E
	__GETD1S 12
	CALL __ANEGD1
	CALL SUBOPT_0x13
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x202005E:
	LDD  R30,Y+17
	CPI  R30,0
	BRNE PC+3
	JMP _0x202005F
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020060
_0x202005F:
	ANDI R16,LOW(251)
_0x2020060:
_0x202005D:
	MOV  R19,R20
_0x2020049:
	SBRC R16,0
	RJMP _0x2020061
_0x2020062:
	CP   R17,R21
	BRLO PC+3
	JMP _0x2020065
	CP   R19,R21
	BRLO PC+3
	JMP _0x2020065
	RJMP _0x2020066
_0x2020065:
	RJMP _0x2020064
_0x2020066:
	SBRS R16,7
	RJMP _0x2020067
	SBRS R16,2
	RJMP _0x2020068
	ANDI R16,LOW(251)
	LDD  R18,Y+17
	SUBI R17,LOW(1)
	RJMP _0x2020069
_0x2020068:
	LDI  R18,LOW(48)
_0x2020069:
	RJMP _0x202006A
_0x2020067:
	LDI  R18,LOW(32)
_0x202006A:
	CALL SUBOPT_0xE
	SUBI R21,LOW(1)
	RJMP _0x2020062
_0x2020064:
_0x2020061:
_0x202006B:
	CP   R17,R20
	BRLO PC+3
	JMP _0x202006D
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006E
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	CALL SUBOPT_0x10
	CPI  R21,0
	BRNE PC+3
	JMP _0x202006F
	SUBI R21,LOW(1)
_0x202006F:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x202006E:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x10
	CPI  R21,0
	BRNE PC+3
	JMP _0x2020070
	SUBI R21,LOW(1)
_0x2020070:
	SUBI R20,LOW(1)
	RJMP _0x202006B
_0x202006D:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BREQ PC+3
	JMP _0x2020071
_0x2020072:
	CPI  R19,0
	BRNE PC+3
	JMP _0x2020074
	SBRS R16,3
	RJMP _0x2020075
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020076
_0x2020075:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020076:
	CALL SUBOPT_0xE
	CPI  R21,0
	BRNE PC+3
	JMP _0x2020077
	SUBI R21,LOW(1)
_0x2020077:
	SUBI R19,LOW(1)
	RJMP _0x2020072
_0x2020074:
	RJMP _0x2020078
_0x2020071:
_0x202007A:
	CALL SUBOPT_0x14
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRSH PC+3
	JMP _0x202007C
	SBRS R16,3
	RJMP _0x202007D
	SUBI R18,-LOW(55)
	RJMP _0x202007E
_0x202007D:
	SUBI R18,-LOW(87)
_0x202007E:
	RJMP _0x202007F
_0x202007C:
	SUBI R18,-LOW(48)
_0x202007F:
	SBRS R16,4
	RJMP _0x2020080
	RJMP _0x2020081
_0x2020080:
	CPI  R18,49
	BRLO PC+3
	JMP _0x2020083
	__GETD2S 8
	__CPD2N 0x1
	BRNE PC+3
	JMP _0x2020083
	RJMP _0x2020082
_0x2020083:
	RJMP _0x2020085
_0x2020082:
	CP   R20,R19
	BRSH PC+3
	JMP _0x2020086
	LDI  R18,LOW(48)
	RJMP _0x2020085
_0x2020086:
	CP   R21,R19
	BRSH PC+3
	JMP _0x2020088
	SBRC R16,0
	RJMP _0x2020088
	RJMP _0x2020089
_0x2020088:
	RJMP _0x2020087
_0x2020089:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x202008A
	LDI  R18,LOW(48)
_0x2020085:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202008B
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	CALL SUBOPT_0x10
	CPI  R21,0
	BRNE PC+3
	JMP _0x202008C
	SUBI R21,LOW(1)
_0x202008C:
_0x202008B:
_0x202008A:
_0x2020081:
	CALL SUBOPT_0xE
	CPI  R21,0
	BRNE PC+3
	JMP _0x202008D
	SUBI R21,LOW(1)
_0x202008D:
_0x2020087:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x14
	CALL __MODD21U
	CALL SUBOPT_0x13
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x12
_0x2020079:
	__GETD1S 8
	CALL __CPD10
	BRNE PC+3
	JMP _0x202007B
	RJMP _0x202007A
_0x202007B:
_0x2020078:
	SBRS R16,0
	RJMP _0x202008E
_0x202008F:
	CPI  R21,0
	BRNE PC+3
	JMP _0x2020091
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x10
	RJMP _0x202008F
_0x2020091:
_0x202008E:
_0x2020092:
_0x2020040:
	LDI  R17,LOW(0)
_0x202003E:
_0x2020021:
	RJMP _0x202001C
_0x202001E:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,26
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_rom_code:
	.BYTE 0x12

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_rom_code)
	LDI  R27,HIGH(_rom_code)
	CALL _ds18b20_temperature
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__POINTW2MN _rom_code,9
	CALL _ds18b20_temperature
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(0)
	CALL _read_adc
	__PUTW1R 3,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  180,R30
	__POINTW1FN _0x0,145
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  180,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	__POINTW1FN _0x0,251
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	ADIW R28,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xE:
	ST   -Y,R18
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xF:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	__GETD1S 8
	__GETD2S 12
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x780
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x4B
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USW 0x130
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x618
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xB
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3B
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USW 0x140
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xB
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x45
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USW 0x12C
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1B
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	push r26
	ld   r26,y
	rcall _w1_write
	pop  r26
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,1
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	clr  r31
	add  r30,r26
	adc  r31,r27
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	ldd  r27,y+1
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,2
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
