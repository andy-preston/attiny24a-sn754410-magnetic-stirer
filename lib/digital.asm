;PORTA pin
.EQU pinClock = 0
.EQU pinData = 1
.EQU pinEnable = 2
.EQU pinAnalog = 3
.EQU pinBlink = 7

.macro blink
    IN ioReg, PORTA
    LDI quickReg, 0b10000000
    EOR ioReg, quickReg
    OUT PORTA, ioReg
.endm

.macro setupPortA
    SBI DDRA, pinClock | pinData | pinEnable | pinBlink
    SBI PORTA, pinBlink
.endm
