.macro delayLoop
    MOV r1, @0
delay:
    LDI quickReg, 0xFF
    MOV r2, quickReg
outerDelay:
    LDI quickReg, 0xFF
    MOV r3, quickReg
innerDelay:
    DEC r3
    BRNE innerDelay
    DEC r2
    BRNE outerDelay
    DEC r1
    BRNE delay
.endm
