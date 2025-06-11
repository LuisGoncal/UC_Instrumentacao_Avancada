#include <xc.h>
#include <stdio.h>
#define _XTAL_FREQ 32000000

// Função de atraso em milissegundos
void delay_ms(unsigned int ms) {
    for(unsigned int i = 0; i < ms; i++) {
        __delay_ms(1);
    }
}

void config4(void);
   

void main(void) {
    config4();
    
    while (1) {
        PORTA = 0b01100000;  // Liga o LED (RA5)
        delay_ms(1000);     // Aguarda um atraso de 1000 ms
        PORTA = 0b00100000;  // Desliga o LED (RA5)
        delay_ms(1000); // Aguarda um atraso de 1000 ms
        PORTA = 0b01100000;
        delay_ms(1000);
        PORTA = 0b01000000;
        delay_ms(1000);
        
    }
    
    return;
}
