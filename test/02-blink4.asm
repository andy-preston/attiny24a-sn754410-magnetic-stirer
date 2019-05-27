.device ATtiny24A

.org 0x0000   ; reset vector
    RJMP progStart

.include "../lib/registers.asm"
.include "../lib/digital.asm"
.include "../lib/delay.asm"
.include "../lib/rotation-stand-in.asm"

progStart:
    setupStackAndReg
    setupPortA
    setupRotation
    defaultDelay
    LDI inputHreg, 0xFF

loop:
    rotate
    delayLoop
    DEC inputHreg
    RJMP loop
