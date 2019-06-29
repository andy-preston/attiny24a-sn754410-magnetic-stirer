    .device ATtiny24A
    .def zeroReg = r1
    .def timeRegH = r16
    .def timeRegL = r17
    .def quickReg = r18
    .def seqAReg = r19
    .def seqBReg = r20
    .def Z = r30
    .def ZL = r30
    .def ZH = r31
    .org 0x0000

    cli

    ldi quickReg, (1 << PB1) | (1 << PB0)
    out DDRB, quickReg          ; H-bridge enable pins

    ldi quickReg, (1 << PA3) | (1 << PA2) | (1 << PA1) | (1 << PA0)
    out DDRA, quickReg          ; H-bridge forward/reverse pins

    ldi quickReg, (1 << ADC7D)  ; disable PA7 (for the analogue pin)
    out DIDR0, quickReg

    ldi quickReg, (1 << MUX2) | (1 << MUX1) | (1 << MUX0)
    out ADMUX, quickReg         ; Use Vcc as VREF - ADC7 as single ended input

    ldi quickReg, (1 << ADEN) | (1 << ADSC)
    out ADCSRA, quickReg        ;  enable adc and start conversion

    ldi quickReg, (1 << CS12) | (1 << CS10)
    out TCCR1B, quickReg        ; prescale timer /1024

    clr zeroReg
    clr timeRegH
    ldi timeRegL, 0b0000.0001

.macro restartOutputSequence
    ldi ZL, low(sequence << 1)  ; BYTE ADDRESS (word address*2) of the table
    ldi ZH, high(sequence << 1) ; of output values
.endm
    restartOutputSequence

checkTimerTicks:
    cpi timeRegH, 0             ; If the delay is set to zero
    brne startTicking
    cpi timeregL, 0
    brne startTicking

    ldi timeRegL, 0b0000.0001   ; make it one - or the timer will spaz out

startTicking:
    out OCR1AH, timeRegH        ; Set the number of timer ticks
    out OCR1AL, timeRegL

    out TCNT1H, zeroReg         ; start the timer
    out TCNT1L, zeroReg

getSequenceStep:
    lpm seqAReg, Z+
    lpm seqBReg, Z+
    cpi seqAReg, 0xff           ; end of data marker
    brne readAnalogue           ; normal data - get on with it
    restartOutputSequence       ; end of data - start again
    rjmp getSequenceStep

readAnalogue:
    sbic ADCSRA, ADSC           ; skip ADC read if ADC still converting
    rjmp waitForTimer

    in timeRegL, ADCL
    in timeRegH, ADCH
    sbi ADCSRA, ADSC

waitForTimer:
    sbis TIFR1, OCF1A           ; if TIFR1 has OCF1A set skip out of the loop
    rjmp waitForTimer           ; wait till the timer overflow flag is SET

    out PORTA, seqAReg          ; output to the forward/reverse pins
    out PORTB, seqBReg          ; output to the enable pins

    sbi TIFR1, OCF1A            ; clear timer1 overflow flag (by setting it?????)

    rjmp checkTimerTicks

    .equ endS = 0xff

    .equ forA = 0b00000001
    .equ revA = 0b00000010
    .equ forB = 0b00000100
    .equ revB = 0b00001000

    .equ enA = 0b00000001
    .equ enB = 0b00000010

sequence:
    .db forA        , enA       ; 1
    .db forA | forB , enA | enB ; 2
    .db        forB ,       enB ; 3
    .db revA | forB , enA | enB ; 4
    .db revA        , enA       ; 5
    .db revA | revB , enA | enB ; 6
    .db        revB ,       enB ; 7
    .db forA | revB , enA | enB ; 8
    .db    ends     ,   ends
