; abcd = !A !B !C !D
; ABCD =  A  B  C  D
;                 badc DCBA
;               -----------
;     Init      - 0001 0001
;  OR 0010 0010 - 0011 0011
; AND 0010 0010 - 0010 0010
;  OR 0100 0100 - 0110 0110
; AND 0100 0100 - 0100 0100
;  OR 1000 1000 - 1100 1100
; AND 1000 1000 - 1000 1000
;  OR 0001 0001 - 1001 1001
; AND 0001 0001 - 0001 0001

    LD A, 0001.0001
    LD B, A
LOOP:
    ROL B
    OR A, B
    OUT A
    AND A, B
    OUT A
    JMP LOOP
