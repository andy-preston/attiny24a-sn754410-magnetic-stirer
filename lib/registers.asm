; r1, r2 and r3 are used by test/test-delay.asm

.def ioReg = r7
.def calcReg = r8
.def saveReg = r10
.def saveLReg = r10
.def saveHReg = r11
.def inputReg = r12
.def inputLReg = r12 ; inputReg is sometimes 16 bit
.def inputHReg = r13
.def dummyJunkReg = r14
.def dummyZeroReg = r15

; only registers r16-r31 can use immediate
.def quickReg = r16     ; very short intermediate values
.def countReg = r17
.def stringLReg = r18
;.def stringHReg = r19
.def dispReg = r20      ; value to write to PORTC for display
; r21
; numReg is only used by num-disp.asm - that may need rewriting yet
.def numReg = r22       ; A number value from a control on the panel

.def portReg = r23      ; value to write to AVR port - SPI chip register ID
.def lhReg = r24
.def lowReg = r24
.def highReg = r25
; XL, XH, YL, YH, ZL, ZH don't seem to get defined in my version of GAVRASM
.def X = r26
.def XL = r26
.def XH = r27
.def Y = r28
.def YL = r28
.def YH = r29
.def Z = r30
.def ZL = r30
.def ZH = r31

.macro setupStackAndReg
    CLI

    LDI quickReg, RAMEND
    OUT SPL, quickReg

    CLR dummyZeroReg
.endm
