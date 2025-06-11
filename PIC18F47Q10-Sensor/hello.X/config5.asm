#include <xc.inc>

PSECT text0,local,class=CODE,reloc=2
GLOBAL _config5;
CONFIG WDTE=OFF;
CONFIG FEXTOSC=0b100 ;deactivate external oscillator (to allow write to RA7)
CONFIG CSWEN=0b1 ;allow editing NDIV and NOSC for CLK config
CONFIG WDTE=OFF ;required to avoid WDT restarting micro all the time

_config5:

    ;=================
    ;CONFIGURE CLOCK
    ;=================


    MOVLW 0b01100000;
    BANKSEL OSCCON1
    MOVWF OSCCON1,1;



    MOVLW 0b00000110;
    BANKSEL OSCFRQ
    MOVWF OSCFRQ,1;
    
    BANKSEL OSCEN
    MOVLW 0b0100000
    MOVWF OSCEN,1


    ;CONFIGURE PORTC

    ;==================

    BANKSEL LATC
    MOVLW 0b00000000
    CLRF LATC,1;

    BANKSEL TRISC
    MOVLW 0b10000000;    
    MOVWF TRISC,1;

    BANKSEL ANSELC
    MOVLW 0b00000000;
    
    MOVWF ANSELC,1;


    BANKSEL RC4PPS
    MOVLW 0x09
    MOVWF RC4PPS,1
	
	
	
	


    BANKSEL RX1PPS
    MOVLW 0b00010111;
	
    MOVWF RX1PPS,1;





	;=================
	;CONFIGURE USART
	;=================
	;BR=9600 @ CLK=32 MHz

    BANKSEL SP1BRGL
	
	;COnfigura da taxa de transmissao para 9600 bps a 32 Mhz
    MOVLW 51 ;SP1BRGH
    movwf SP1BRGL
	
	

    BANKSEL TX1STA
    MOVLW 0b00100000 ; aqui tem q ser binario 
    MOVWF TX1STA,1;
	
	

    BANKSEL RC1STA
	; Q:HERE YOU MUST ENABLE THE USART AND THE RECEIVER WITH REGISTER RC1STA
    MOVLW 0b10010000
	
	
    MOVWF RC1STA,1;
	
	
    RETURN 
	
	







