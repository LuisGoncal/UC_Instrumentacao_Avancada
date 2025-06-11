#include <xc.inc>

GLOBAL _int_handler, _getch     ;declare global functions
    
PSECT intcode

#define parcel_msb 0

_int_handler:    ;when an interrupt happens, this function is called. It is your job to verify what interrupt happened and act accordingly
    
    BANKSEL PIR3
    BTFSC PIR3,5  ;Q: check if the EUSART1 RX flag is set. If so, go to the C function _getch. If not, skip.  
    call _getch
    
    RETFIE
;    goto _timer0_int_handler ;so realiza isto se tiver 1; se nao salta pra seguinte
;    
;    
;    BANKSEL PIR1 ;quando PIR0=0 passa para aqui ; PIR1 é do ADC; se tiver PIR1=1 -> interrupção do ADC
;    BTFSC  PIR1, 0   ; Q: Check if the ADC interrupt flag is set. If so, go to 
;    ; _getch. If not, skip.
;    
;    GOTO _adc_int_handler
;    
;    ; quando a anterio esta a zero; PIR1=0
;    BANKSEL PIR3 ; PIR3 É a flag do RX--> pc pro micro
;    
;    BTFSC PIR3, 5  ; PIR3=1 (bit 5) realiza esta instrução
;    ; Q: check if the EUSART1 RC GLAG IS SER
;    
;    call _getch   ; esta na main
;    
;    RETFIE
;    
;; quando o set esta em 1 vimos para aqui:
;    
;_timer0_int_handler:
;    BANKSEL ADCON0 ; registro do controlo de ADC --> qd o timer chega ao maximo
;    ; --> dá o print da conversão
;    BSF ADCON0, 0  ; É aqui que faz a conversao de anaofioc --> digital  --> adc-->set
;    ; Q: WE CAN USE THE TIMR TO CONTROL THE ADC SAMPLING RATE STAR AN ADC CONVERSION HERE
;    
;    BTG PORTA, 5   ; TOGGLE LED ON PROTA, 5
;    ;-> ta a inverter o sinal -> liga desligado , liga. ou seja, cada vez que o led pisca o tempo acaba
;    ;-> cada vez que o timer acaba, o led pisca
;    
;    BANKSEL PIR0    ; PIR0 pq a interrupçao foi feita e o PIR0 esta a 1
;    
;    BCF  PIR0,5 ;clear timer_int flag  ; queremos dar resert ao PIR0 e fica a 0
;    
;    
;    RETFIE      ; return from interruption ; volta a instruçao de cima
;    
;    
;  ;QUANDO PIR1=1
;  
;_adc_int_handler:
;   
;    
;    BANKSEL ADRESH   ; registro do resultado, quando faz  a conversão vai para
;    ;AQUI ; H--> HIGHEST
;    
;    
;    MOVFF ADRESH, parcel_msb   ; put the highest 8 bits of the conversion result in parcel_msb
;    
;    ; ESTAMOS A GUARDAR OS 8 BITS CONVERTIDOS NO PARCEL
;    
;    ; here Iam just changing the value of the byte read by the ADC converion in the UART TX
;    ; DEBUG PURPOSES
;    
;    ; parcel msb no lata 
;    
;    BANKSEL LATA
;    MOVFF   parcel_msb, LATA  ; ou PORTA ou LATA
;    
;    
;    
;    
;  
;    MOVLW 0b11111111
;    MOVWF parcel_msb
;    
;    BANKSEL TX1REG ;REGISTRO DO TX
;    MOVFF TX1REG
;    
    ;passamos os 8 bits para o registro do TX
                               ;Q: put the 8 MSB of the ADC conversion in the UART TX.
    
;    
;    BANKSEL PIR1
;    
;    BCF PIR1, 0  ;clear the ADC interrupt flag   ;volta o PIR1 a zero
;    RETFIE      ;return from interruption            ;volta pra cima
;     
;    
    
    
 


