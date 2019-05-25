.macro setupRotation
    LDI shiftReg, 0b0000.1000
.endm

.macro rotate
    OUT PORTA, shiftReg
    LSR shiftReg
    ;ANDI shiftReg, 0b0000.1111
    CPI shiftReg, 0
    BRNE rotate_end
    LDI shiftReg, 0b0000.1000
rotate_end:
.endm
