.EQU useARef = 0
.EQU useAVcc = (1<<REFS0) ; Capacitor on AREF
.EQU useIRef = (1<<REFS0) | (1<<REFS1) ; Internal 2.56V reference

.EQU prescale2   =                           (1<<ADPS0)
.EQU prescale4   =              (1<<ADPS1)
.EQU prescale8   =              (1<<ADPS1) | (1<<ADPS0)
.EQU prescale16  = (1<<ADPS2)
.EQU prescale32  = (1<<ADPS2)              | (1<<ADPS0)
.EQU prescale64  = (1<<ADPS2) | (1<<ADPS1)
.EQU prescale128 = (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)

.EQU muxFlags = useAVcc
.EQU controlFlags = (1<<ADEN) | prescale128
.EQU startConv = (1<<ADSC) | controlFlags

.MACRO setupAnalog
    LDI portReg, muxFlags    ; Set individual MUX bits later
    STS ADMUX, portReg       ; Can't use OUT for ports > 63
    LDI portReg, controlFlags
    STS ADCSRA, portReg
.ENDMACRO

.MACRO analogStart
    LDI portReg, pinAnalog
    ORI portReg, muxFlags    ; portReg has full ADMUX value

    STS ADMUX, portReg       ; can't use OUT for ports > 63

    LDI portReg, startConv
    STS ADCSRA, portReg
.ENDMACRO

.MACRO analogRead
analogReadWait:
    LDS portReg, ADCSRA      ; Can't use SBIS for port > 31
    ANDI portReg, (1 << ADSC)
    BREQ analogReadWait

    LDS inputLreg, ADCL      ; Someone on Stack Overflow said
    LDS inputHreg, ADCH      ; you must read ADCL first then ADCH
.ENDMACRO
