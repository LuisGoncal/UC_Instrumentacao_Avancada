#include <xc.inc>

GLOBAL _config7
    
PSECT text0, local, class=CODE, reloc=2

 
CONFIG FEXTOSC=0b100

CONFIG CSWEN=0b1
 
CONFIG WDTE=OFF
 
_config7:
    
    
    ;===============
    ;CONFIGURE PORTA  LIGAR ATUADOR
    
    ;===============
    
    
    BANKSEL LATA 
    
    CLRF LATA,1
    
    
    
    BANKSEL TRISA 
    
    CLRF TRISA,1
    
    
    
    BANKSEL ANSELA 
    
    CLRF ANSELA, 1
    
    
    ;===================
    ;PORTA B  ; HARDWARE PARA MICRO
    ;==================
    BANKSEL LATB
    CLRF LATB, 1
    
    BANKSEL TRISB
    CLRF TRISB, 1
    BSF TRISB, 1
     
    BANKSEL ANSELB 
    
    CLRF ANSELB, 1
    BSF ANSELB, 1
    
    
    
    ;===================
    ;CONFIGURE PORTC
    ;  LIGAÇAO BILATERAL TX E RX
    ;==================
    
    
    BANKSEL LATC
    CLRF LATC, 1
    
    BANKSEL TRISC
    CLRF TRISC,1
    BSF TRISC,7
    
    BANKSEL ANSELC
    
    CLRF ANSELC,1
    
    BANKSEL RC4PPS  ;TX RC4 ; MICRO - PC
    
    MOVLW 0b0001001
    
    MOVWF RC4PPS
    
    BANKSEL RX1PPS
    
    MOVLW 0b00010111   ; RC7__RX ; PC-MICRO
    
    MOVWF RX1PPS
    
    
    ;===========
    ;CONFIGURE CLOCK 
    ;================
    
    BANKSEL OSCCON1
    MOVLW 0b01100000  ; tava 0b0110000
    
    MOVWF OSCCON1,1
    
    
    BANKSEL OSCFRQ
    
    MOVLW 0b00001000 ; 0b01100010
    
    MOVWF OSCFRQ, 1
    
    BANKSEL OSCEN 
    
    MOVLW 0b01000000  ; corrigi pk tinha menos 2 zeros
    MOVWF OSCEN,1
    
    
    
    ;================
    ; CONFIGURE USART
    ;================
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    
    
    BANKSEL SP1BRGL
    
    MOVLW 51       ; 19 200 baud rate 
    
    MOVWF SP1BRGL
    
    MOVLW 0
    
    MOVWF  SP1BRGH
    
    BANKSEL TX1STA
    
    MOVLW 0b10100000    ; isto n mudei
    
    
    MOVWF TX1STA
    
    MOVLW 0b10010000
    BANKSEL RC1STA
     
    MOVWF RC1STA
    
    
    ;================
    ;CONFIGURE ADC
    ;===============
    ; Vref- é zero pk nao temos vref negativo
    ;vref + é 10 pk a nossa vref é 3.6V
    ; alimentação negativa ??DIGITALLAB _______ PERGUNTAR AO PROFESSOR 
    
    BANKSEL ADPCH
    MOVLW 0b00001001   ;RB0 Hardware para o micro
    
    MOVWF ADPCH, 1
    
    BANKSEL ADREF    ; 
    MOVLW   0b00000000 ; MUDAR O ADPREF [1:0]
    MOVWF ADREF, 1
    
    
    
    BANKSEL ADCLK 
    MOVLW 0b00001111
    
    MOVWF ADCLK, 1
    
    BANKSEL ADCON0
    
    MOVLW 0b10000100 ;;;;;;;;;;;;;;;;;, vr
    
    MOVWF ADCON0, 1
    
    
    ;=================
    ;  CONFIGURE TIME 0
    ;=================================
    
    
    BANKSEL T0CON0
    
    CLRF  T0CON0
    
    BANKSEL T0CON1
    
    MOVLW 0b01101110  ;1111 
    
    MOVWF T0CON1
    BANKSEL TMR0L
    CLRF TMR0L
    
    ;=================
    ;ENABLE INTERRUPTS
    ;====================
    
    
    
    BANKSEL PIR0
    BCF PIR0, 5
    
    BANKSEL PIR1
    BCF PIR1, 0
    
    BANKSEL PIR3
    
    BCF  PIR3, 5
    
    BANKSEL PIE0
    
    BSF  PIE0, 5
    
    BANKSEL PIE1
    
    BSF PIE1,0
    
    BANKSEL PIE3
    
    BSF PIE3, 5
    
    BANKSEL T0CON0 
    BSF T0CON0, 7
    BANKSEL ADCON0
    BSF ADCON0, 7
    
    ; q :here you mus enable perioheral interruption and 
    ; global interruptions
    ;Dar enable as interrupçoes globais e perifericas 
    BANKSEL INTCON
    ; bit 6--> perifeivco 1 
    MOVLW 0b11000111  ; 111-- pk qd o  timer chega ao final tem de dar  interrup
    
    MOVWF INTCON, 1
    
    
    RETURN 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    