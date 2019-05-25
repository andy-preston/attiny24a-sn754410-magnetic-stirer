.macro setupRotation
    LDI shiftReg, 0b0000.1000
.endm

.macro rotate
    LSR shiftReg
    ANDI shiftReg, 0b0000.1111
    BRNE rot_output
    LDI shiftReg, 0b0000.1000
rot_output:
    OUT PORTA, shiftReg
.endm
