.device ATtiny24A

.org 0x0000   ; reset vector
    RJMP progStart

.org 0x003E
.include "../lib/registers.asm"
.include "../lib/digital.asm"
.include "test-delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupPortA
seqStart:
    LDI countReg, 0x20
loop:
    blink
    delayLoopR countReg

    DEC countReg
    BRNE loop
    RJMP seqStart
