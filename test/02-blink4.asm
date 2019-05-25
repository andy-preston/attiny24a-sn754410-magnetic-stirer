.device ATtiny24A

.org 0x0000   ; reset vector
    RJMP progStart

.include "../lib/registers.asm"
.include "../lib/digital.asm"
.include "../lib/delay.asm"

.macro blinker
    IN ioReg, PORTA
    LDI quickReg, (1 << pinClock | 1 << pinData | 1 << pinEnable | 1 << pinBlink);
    EOR ioReg, quickReg
    OUT PORTA, ioReg
.endm

progStart:
    CLI
    setupStackAndReg
    setupPortA
    LDI quickReg, 1 << pinBlink | 1 << pinData
    OUT PORTA, quickReg
seqStart:

    LDI inputHreg, 0xFF
loop:
    blinker
    delayLoop

    DEC inputHreg
    BRNE loop
    RJMP seqStart
