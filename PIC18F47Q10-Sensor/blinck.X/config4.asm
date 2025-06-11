#include <xc.inc>
    
GLOBAL _config4 ;define the function to link it with the C definition

    
PSECT text0,local,class=CODE,reloc=2
    
CONFIG FEXTOSC=0b100 ;deactivate external oscillator (to allow write to RA7)
CONFIG CSWEN=0b1 ;allow editing NDIV and NOSC for CLK config
CONFIG WDTE=OFF ;required to avoid WDT restarting micro all the time

    
_config4:
    
    ;===============
    ;CONFIGURE PORTA
    ;===============
    BANKSEL LATA
    CLRF LATA,1 ; Set all LatchA bits to zero
    
    MOVLW 0b00000001 
    BANKSEL TRISA
    MOVWF TRISA,1 ;defines the pin direction. 0=out, 1=in. RA0 connects to potenciometer. All other are output pins
    
    MOVLW 0b01100000
    BANKSEL ANSELA
    MOVWF ANSELA,1 ;analog select. RA0 connects to potenciometer. The others are digital pins
    
    
    
    ;===============
    ;CONFIGURE CLOCK
    ;===============
    BANKSEL OSCCON1
    MOVLW 0b01100000  ;NOSC=0110 (internal high speed osc)
    MOVWF OSCCON1,1   ;NDIV=0000 (divider=1, clk divided by 1)
    
    BANKSEL OSCFRQ
    MOVLW 0b0000110 ; HFFRQ 0110 -> clk= 32 MHz
    MOVWF OSCFRQ,1
    
    BANKSEL OSCEN
    MOVLW 0b01000000 ;internal clock @freq=OSCFRQ ativo
    MOVWF OSCEN,1
    
    
    RETURN
