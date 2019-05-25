;PORTA pin
.EQU pinClock = 0
.EQU pinData = 1
.EQU pinEnable = 2
.EQU pinBlink = 3
.EQU pinAnalog = 7

.macro setupPortA
    LDI quickReg, 1 << pinClock | 1 << pinData | 1 << pinEnable | 1 << pinBlink
    OUT DDRA, quickReg
    SBI PORTA, pinBlink
.endm

.macro blink
    IN ioReg, PORTA
    LDI quickReg, (1 << pinBlink); | (1 << 2)
    EOR ioReg, quickReg
    OUT PORTA, ioReg
.endm

.macro shift_out        ; value to output in shiftReg
    ldi countReg, 8
shift_out_loop:
	cbi	PORTA, pinClock ; low
	rol	shiftReg
	brcs shift_out_one
	rjmp shift_out_zero ; equalise timing
shift_out_zero:
	cbi	PORTA, pinData
	rjmp shift_out_next
shift_out_one:
	sbi	PORTA, pinData
	rjmp shift_out_next
shift_out_next:
	sbi	PORTA, pinClock ; high
	dec	countReg
	brne shift_out_loop
.endm
