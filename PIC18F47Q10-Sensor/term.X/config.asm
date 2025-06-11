#include <xc.inc>
    
GLOBAL _config

PSECT text0, local,class=CODE,reloc=2
 
CONFIG FEXTOSC=0b100
CONFIG CSWEN=0b1
CONFIG WDTE=OFF
 
 
_config:
    
    ;=============
    ;CONFIGURE PORTA
    ;=============
    
    BANKSEL LATA   ;Seleciona o registrador LATA, ou seja, da porta A
    
    CLRF LATA,1  ; Set all LatchA bits to zero
    
    MOVLW 0b00000001    ; colocado o registrador w = 0b00000001
    BANKSEL TRISA       ;; Chama o registrador TRISA , que indica se os pinos sao output ou input.
    MOVWF TRISA,1
    
    MOVLW 0b00000001
    BANKSEL ANSELA     ;Chama o registrador ANSELA, que define os pinos que são analógicos e os que são digitais.
    MOVWF ANSELA, 1     ;  o pino RA0 é "1" -> analogico. Os restantes são zero.
    
    ;=====================
    ;CONFIGURE PORTC
    ;==================
    
    BANKSEL LATC    ; seleciona o registrador da porta C, LATC
    
    CLRF LATC, 1   ; Set all LatchD bits to zero
    
    BANKSEL TRISC
    CLRF TRISC,1  ;;All pins are output--- bits tds a zero
    BSF TRISC,7  ;except RC7, that will be used as RX - microchip specifies RX as input pin
                 ; ou seja  RC7 vai ligar ao RX ou seja o bit 7 vai tomar valor 1, RC7=1
                  
    
    BANKSEL ANSELC
    CLRF ANSELC,1  ;All digital pins conversao de analogio a f«digital, tds os pines a zero ent tudo digital
    
    
    BANKSEL RC4PPS ; seleciona o registro RC4PPS
		    ;RC4=pin 4 da porta C
		    ; PPS = pin periferico . QUEREMOS LIGAR RC4 A UM periferico que vai ser EUSAT1 TX(TX=PINO DE TRANSMISSÃO)
    ; para passarmos um valor para um registro, primeiro temos de o armazenar em W(0b00000001)
   
    ;TABELA 17.2--> 0X09(hexadecimal). BINARIO=0b0001001
    
    MOVLW 0x09  ; Q: WHAT VALUE MUST WE GIVE TO RC4PPS TO PUT THE EUSART1 TX IN PIN RC4? HINT: look in the 17.2 section of the datasheet, table 17.2
    MOVWF RC4PPS, 1    ;place the EUSART1 (TX/CK) in RC4
    
    BANKSEL RX1PPS   ;agr vamos ver onde está conectado o RX
     ; RC7, BITS 4 e 3-- TEM QUE SER DA PORTA C--> 1 0 (respetivamente)
     ; 2,1,0 ---> pin 7 ent ta tudo a 1,--> 1 1 1
     ; os restantes sao neutro ent vao a 0
    MOVLW  0x17 ; ; Q: WHAT VALUE MUST WE GIVE TO RX1PPS TO PUT THE EUSART1 RX IN PIN RC7? HINT: look in the PPS chapter of the datasheet
    MOVWF RX1PPS, 1       ;place the EUSART1 (RX) in RC7
    
    
    
    
    ; =================
    ; CONFIGURE CLOCK
    ; ================
    
    BANKSEL OSCCON1    ; frequencia de controlo do osciloscopio
    MOVLW 0b01100000  ;  NOSC=0110(internal high speed osc)  ; maxima  voltagem 
    
    MOVWF  OSCCON1, 1  ; NDIV=0000 (divider=1, clk divided by 1)
 
    BANKSEL OSCFRQ     ; voltagem de referencia
    MOVLW 0b0000110 ; HFFRQ 0110 ->  CLK=32MHz
    
    MOVWF OSCFRQ, 1
    
    
    BANKSEL OSCEN
    MOVLW 0b01000000  ; internal clock @freq=OSCFRQ ativo
    MOVWF OSCEN, 1
    
    
    ;==============
    ;CONFIGURE USART
    ;===============
    ;BR=9600 @ CLK=32MHz
    
    ; Q: WHAT VALUE SHOULD WE PUT IN SP1BRGL AND SP1BRG1H TO GET A BAUD RATE OF 9600 BPS
    ; FOR A CLOCK SPEED OF 32 MHZ ? HINT: CHECK SECTION 28.2
    
    BANKSEL SP1BRGL     ; taxa de transmissão 
    
    MOVLW 51           ; 0x33 assincrone
    
    MOVWF SP1BRGL
    
    MOVLW  0x00         ; nao usamos nada que tenha mais q 8bits
    
    MOVWF  SP1BRGH
    
    BANKSEL TX1STA 
    MOVLW 0b10100000   ; 8 data bits, TX enabled, ASYNC
    
    MOVWF TX1STA
    
    
    ;; Q: HERE YOU MUST ENABLE THE USART AND THE RECEIVER WITH REGISTER RC1STA
    
    MOVLW 0b10010000     ;USART enabled, 8 data bits / enable receiver
    BANKSEL RC1STA
    
    MOVWF  RC1STA
    
;     ;=============
;    ;CONFIGURE ADC
;    ;=============
;    BANKSEL ADPCH
;    MOVLW 0b00000000   ;set RA0 as ADC input
;    MOVWF ADPCH, 1
;    
;    BANKSEL ADREF
;    MOVLW 0b00000000  ;Vref set to vdd and vss
;    MOVWF ADREF, 1
;    
;    BANKSEL ADCLK  
;    MOVLW 0b00001111  ; Q: SET THE ADC CLOCK FREQUENCY TO 1 MHZ, KNOWING THAT FOSC = 32 MHZ
;    MOVWF ADCLK, 1
;    
;    BANKSEL ADCON0
;    MOVLW 0b10000000  ;Q: SET THE ADC TO: results left-justified, clock=Fosc/div, non-continuous operation
;    MOVWF ADCON0, 1
;    
;    
;    
;    ;================
;    ;CONFIGURE TIMER0
;    ;================
;    BANKSEL T0CON0
;    CLRF T0CON0
;    
;    BANKSEL T0CON1
;    MOVLW 0b01101110   //Q: SET THE PRESCALER TO ~= 16000
;    MOVWF T0CON1
;    
;   
;    BANKSEL TMR0L
;    CLRF TMR0L  ;clear the counter
;    
    
    ;===========
    ; ENABLE INTERRUPTS
    ;===============0
    
    
    ;=================
    ;ENABLE INTERRUPTS
    ;=================
    BANKSEL PIR0
    BCF PIR0, 5 ;clear timer interrupt flag
    BANKSEL PIR1
    BCF PIR1,0  ;clear ADC interrupt flag
    BANKSEL PIR3 
    BCF PIR3,5 ;clear RX1 interrupt flag
    
    BANKSEL PIE0
    BSF PIE0, 5  ; Q: enable timer int
    BANKSEL PIE1
    BSF PIE1, 0 ; Q: enable adc int
    BANKSEL PIE3
    BSF PIE3, 5; Q: enable RX1 int
    
    BANKSEL T0CON0
    BSF T0CON0, 7   ;start timer 0
    BANKSEL ADCON0  
    BSF ADCON0, 7   ;ENABLE ADC
    ; q: here you must enable peripheral interruptions and
    ; global interruptions 
    ; Dar enable às interrupcoues globais e perifericas
    
    Banksel INTCON ; interruptor de controlo ; bit 7--> global --> 1
    ; bit 6__> periferico--> 1(queremos dar enable)
    MOVLW 0b11000111 ; 111 --> Pk qd o timer chega ao final ter de dar interrupte
    
    MOVWF INTCON, 1
    
    
  
    
    
    RETURN 
    
    
    
    
    
    
    
    
    
    
    
    

    
    