    .device ATtiny24A

    .def timeRegH = r16
    .def timeRegL = r17
    .def quickReg = r18

    .org 0x0000

    cli

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; should be shift register pins but this is just the 4 LED tester ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldi quickReg, (1 << PA3) | (1 << PA2) | (1 << PA1) | (1 << PA0)
    out DDRA, quickReg

    clr timeRegH
    clr timeRegL

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;                                                 ;
    ; OC0B is disabled by default                     ;
    ; Make sure it stays disbled when timer is set up ;
    ;                                                 ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldi quickReg, (1 << ADC7D) ; disable PORTA/7 (analogue pin)
    out DIDR0, quickReg

    ;; REFS1 ;  REFS0  ;; MUX5 ; MUX4 ; MUX3 ; MUX2 ; MUX1 ; MUX0 ;;
    ;;   0   ;    0    ;;  0   ;  0   ;  0   ;  1   ;  1   ;  1   ;;
    ;; Use Vcc as VREF ;;     Use ADC7 as single ended input      ;;

    ldi quickReg, (1 << MUX2) | (1 << MUX1) | (1 << MUX0)
    out ADMUX, quickReg

    ;; ADEN   ;; ADSC  ;; ADATE  ;; ADIF ; ADIE ;; ADPS2 ; ADPS1 ; ADPS0 ;;
    ;;   1    ;;   0   ;;   0    ;;   0  ;   0  ;;   1   ;   1   ;   1   ;;
    ;; Enable ;; Start ;; Auto T ;;  Interrupt  ;;      Prescale 128     ;;

    ldi quickReg, (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0)
    out ADCSRA, quickReg

startAnalog:
    sbi ADCSRA, ADSC

mainLoop:
    sbis ADSC, ADSC ; skip ADC read if ADC still converting
    rjmp readAnalog

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; quick test for before shift reg is in place ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ANDI timeRegL, 0b1100.0000
    LSR timeRegL
    LSR timeRegL
    LSR timeRegL
    LSR timeRegL
    LSR timeRegL
    LSR timeRegL
    ANDI timeRegH, 0b0000.0011
    LSL timeRegH
    LSL timeRegH
    OR timeRegH, timeRegL

    OUT PORTA, timeRegH

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; end of test                                 ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    rjmp mainLoop

readAnalog:
    in timeRegL, ADCL
    in timeRegH, ADCH
    rjmp startAnalog
