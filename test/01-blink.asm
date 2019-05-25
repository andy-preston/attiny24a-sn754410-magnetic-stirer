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
seqStart:

    LDI inputHreg, 0xFF
loop:
    blink
    delayLoop

    DEC inputHreg
    BRNE loop
    RJMP seqStart
