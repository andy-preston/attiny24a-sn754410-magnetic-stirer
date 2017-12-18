; ATtiny24A - L293D laboratory stirer

            .include "TN13DEF.INC"

            .def rDelay=R16
            .def rCount=R17
            .def rTemp=R18
            .def rOut=R19
            .def rMask=R20

            .org 0x0000             ; reset vector
            rjmp reset

            .org 0x000E             ; ADC Conversion Complete Interrupt vector:
            rjmp ADC_ISR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

reset:      ldi rTemp, low(RAMEND)  ; stack setup; set SPH:SPL to RAMEND
            out SPL, rTemp
            ldi rTemp, high(RAMEND)
            out SPH, rTemp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

            ldi rTemp, 0b0000_1111
            out DDRA, rTemp         ; set lower 4 PortA pins as output
            out DDRB, rTemp         ; set lower 4 PortB pins as output

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

            ldi rOut, 0b0001_0001   ; output bits
            mov rMask, rOut         ; initial mask is the same
mainloop:   out PORTA, rOut         ; ouput lower 4 bits to Port A
            out PORTB, rOut         ; and Port B
            rcall pause

            mov rTemp, rMask
            rol rTemp               ; squeeze the correct value into carry
            rol rMask               ; do the "real" rotate left

            or rOut, rMask
            out PORTA, rOut         ; ouput lower 4 bits to Port A
            out PORTB, rOut         ; and Port B
            rcall pause

            and rOut, rMask

            rjmp mainloop           ; and loop forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pause:      ldi rTemp, 2            ; select ADC channel 4 (PA4)
            out ADMUX, rTemp

            ldi rTemp, 0b1110_0111  ; from left to right:
                                    ; ADC Enable,
                                    ; Start Conversion,
                                    ; Free-Running Mode,
                                    ; write zero to ADC Int flag,
                                    ; disable int,
                                    ; prescaler: 111 for XTAL/128
            out ADCSR, rTemp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

            mov rCount, rDelay      ; start the proper pause routine

pauseloop:  in rTemp, TIFR0         ; read timer status
            andi rTemp, 0b0000_0010 ; check overflow flag
            breq pauseloop

            ldi rTemp, 0b0000_0010  ; reset overflow (with a 1 not a zero)
            out TIFR0, rTemp

            dec rCount
            breq pauseloop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

adcloop:    in rTemp, ADCSR
            andi rTemp, 0b0100_0000 ; has analogue conversion finsihed
            breq adcloop

            in rDelay, ADCL         ; get the last ADC result, low byte first,
            in rTemp, ADCH          ; then high byte

            lsr rTemp               ; shift ADC result right (2 bits)
            ror rDelay              ; by first shifting out bit 0 of r16,
            lsr rTemp               ; then shifting it into r17
            ror rDelay              ; (twice)

            ret
