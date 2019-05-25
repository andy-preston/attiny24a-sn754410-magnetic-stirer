; r1, r2 and r3 are used by test/test-delay.asm

.def calcReg = r8
.def saveReg = r10
.def saveLReg = r10
.def saveHReg = r11
.def dummyJunkReg = r14
.def dummyZeroReg = r15

; only registers r16-r31 can use immediate
.def quickReg = r16     ; very short intermediate values
.def countReg = r17
.def shiftReg = r18
.def inputReg = r22
.def inputLReg = r22 ; inputReg is sometimes 16 bit
.def inputHReg = r23
.def adccReg = r24
.def ioReg = r25
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
