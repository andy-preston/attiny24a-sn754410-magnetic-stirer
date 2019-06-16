    .device ATtiny24A
    .def zeroReg = r1
    .def timeRegH = r16
    .def timeRegL = r17
    .def quickReg = r18
    .def outputReg = r19
    .def Z = r30
    .def ZL = r30
    .def ZH = r31
    .org 0x0000

    cli

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; should be shift register pins but this is just the 4 LED tester ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldi quickReg, (1 << PA3) | (1 << PA2) | (1 << PA1) | (1 << PA0)
    out DDRA, quickReg

    ldi quickReg, (1 << ADC7D)  ; disable PORTA/7 (analogue pin)
    out DIDR0, quickReg

    ldi quickReg, (1 << MUX2) | (1 << MUX1) | (1 << MUX0)
    out ADMUX, quickReg         ; Use Vcc as VREF - ADC7 as single ended input

    ldi quickReg, (1 << ADEN) | (1 << ADSC)
    out ADCSRA, quickReg        ;  enable adc and start conversion

    ldi quickReg, (1 << CS12)   ; prescale timer /256
    out TCCR1B, quickReg

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

getNextOutput:
    lpm outputReg, Z+
    cpi outputReg, 0xff         ; end of data marker
    brne readAnalogue           ; normal data - get on with it
    restartOutputSequence       ; end of data - start again
    rjmp getNextOutput

readAnalogue:
    sbic ADSC, ADSC             ; skip ADC read if ADC still converting
    rjmp waitForTimer

    in timeRegL, ADCL
    in timeRegH, ADCH
    sbi ADCSRA, ADSC

waitForTimer:
    sbis TIFR1, OCF1A           ; if TIFR1 has OCF1A set skip out of the loop
    rjmp waitForTimer           ; wait till the timer overflow flag is SET

    out PORTA, outputReg        ; output the next sequence step
    sbi TIFR1, OCF1A            ; clear timer1 overflow flag (by setting it?????)

    rjmp checkTimerTicks

sequence:
    .db 0b0000.0001, 0b0000.0011, 0b0000.0010, 0b0000.0110
    .db 0b0000.0100, 0b0000.1100, 0b0000.1000, 0b0000.1001
    .db 0xff,  0xff
