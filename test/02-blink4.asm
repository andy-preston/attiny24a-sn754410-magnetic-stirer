.device ATtiny24A

.org 0x0000   ; reset vector
    RJMP progStart

.include "../lib/registers.asm"
.include "../lib/digital.asm"
.include "../lib/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupPortA
    defaultDelay

    LDI inputHreg, 0xFF
    LDI shiftReg, 0b0000.1000

loop:
    LSR shiftReg
    BRNE output

    LDI shiftReg, 0b0000.1000

output:
    OUT PORTA, shiftReg

    delayLoop
    DEC inputHreg
    RJMP loop
