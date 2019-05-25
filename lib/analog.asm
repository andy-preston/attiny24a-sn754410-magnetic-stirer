; Internal 1.1V voltage reference, by datasheet external capacitor should be
; connected to Aref calibrated for actual chip (e.g. 1.197V)
;equ INTERNAL_VREF = (1.197 / 1024)

.equ muxAdc7 = 0b00000111

.equ useVccARef = 0           ; disconnected from PA0 (AREF)
.equ useExtAref = (1<<REFS0)  ; PA0 (AREF), internal voltage ref. off
.equ useIRef =    (1<<REFS1)  ; Internal 1.1V reference

.equ prescale2   =                           (1<<ADPS0)
.equ prescale4   =              (1<<ADPS1)
.equ prescale8   =              (1<<ADPS1) | (1<<ADPS0)
.equ prescale16  = (1<<ADPS2)
.equ prescale32  = (1<<ADPS2)              | (1<<ADPS0)
.equ prescale64  = (1<<ADPS2) | (1<<ADPS1)
.equ prescale128 = (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)

.macro setupAnalog
    ; Switch ADC off
    CBI ADCSRA, ADEN
    ; disable digital pin
    LDI quickReg, 1 << pinAnalog
    OUT DIDR0, quickReg
    ; set up multiplexer
    LDI quickReg, useIRef | 0b00111
    OUT ADMUX, quickReg
    ; High byte has 2 bits, low byte has 8 bits
    CBI ADCSRB, ADLAR
    ; Set prescale to 128
    IN quickReg, ADCSRA
    ORI quickReg, prescale128
    OUT ADCSRA, quickReg
    ; Switch ADC on
    SBI ADCSRA, ADEN
.endm

.macro analogStart
    SBI ADCSRA, ADSC
.endm

; it might be a good idea to take 10 readings and average them
; and multiply by INTERNAL_VREF
.macro analogRead
analogReadWait:
    SBIS ADCSRA, ADSC
    RJMP analogReadWait
    IN inputLreg, ADCL                ; "Someone on Stack Overflow" said
    IN inputHreg, ADCH                ; you must read ADCL first then ADCH
.endm
