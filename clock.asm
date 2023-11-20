LED EQU P1.7
;********* Ustawienie TIMERów *********
;TIMER 0
T0_G EQU 0 ;GATE
T0_C EQU 0 ;COUNTER/-TIMER
T0_M EQU 1 ;MODE (0..3)
TIM0 EQU T0_M+T0_C*4+T0_G*8
;TIMER 1
T1_G EQU 0 ;GATE
T1_C EQU 0 ;COUNTER/-TIMER
T1_M EQU 0 ;MODE (0..3)
TIM1 EQU T1_M+T1_C*4+T1_G*8
TMOD_SET EQU TIM0+TIM1*16
;50[ms] = 50 000[ŠS]*(11.0592[MHz]/12) =
; = 46 080 cykli = 180 * 256
TH0_SET EQU 256-180
TL0_SET EQU 0
;*************************************   
    LJMP START
    ORG 100H
START:
    MOV TMOD,#TMOD_SET ;Timer 0 liczy czas
    MOV TH0,#TH0_SET ;Timer 0 na 50ms
    MOV TL0,#TL0_SET
    SETB TR0 ;start Timera
LOOP: ;Pętla mrugania diody TEST
    CPL LED
    MOV R7,#20 ;odczekaj czas 20*50ms=1s
TIME_N50:
    JNB TF0,$ ;czekaj, aż Timer 0
    ;odliczy 50ms
    MOV TH0,#TH0_SET ;TH0 na 50ms
    CLR TF0 ;zerowanie flagi timera 0
    DJNZ R7,TIME_N50 ;odczekanie N*50ms
    SJMP LOOP
WPROWADZ:
    LCALL WAIT_KEY
    MOV B,#10
    MUL AB
    MOV R1,A
    LCALL WAIT_KEY
    ADD A,R1
    RET ; wyjdź z podprogramu. Wynik w A
BCD:
    MOV B,#10
    DIV AB
    SWAP A
    ADD A,B
    RET
CHUJ_DO_EMULACJI:
    MOV B,#10
    DIV AB
    SWAP A
    ADD A,B
    RET