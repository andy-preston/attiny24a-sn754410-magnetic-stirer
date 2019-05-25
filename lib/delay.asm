; TODO: use blink test to adjust this so that we've got a reasonable
; delay... and then we'll know how much of the analog read's bits we'll
; need to control it.

.macro defaultDelay
    LDI inputLreg, 0xFF
.endm

.macro delayLoop
    MOV r1, inputHreg
delay:
    MOV r2, inputLreg
outerDelay:
;    LDI quickReg, 0x80
;    MOV r3, quickReg
;innerDelay:
;    DEC r3
;    BRNE innerDelay
    DEC r2
    BRNE outerDelay
    DEC r1
    BRNE delay
.endm
