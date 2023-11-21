;********* Ustawienie TIMERów i bindy *********
LED EQU P1.7

;TIMER 0
T0_G EQU 0 ;GATE
T0_C EQU 0 ;COUNTER/-TIMER
T0_M EQU 1 ;MODE (0..3)
TIM0 EQU T0_M+T0_C*4+T0_G*8

;TIMER 1
T1_G EQU 0 ;GATE
T1_C EQU 0 ;COUNTER/-TIMER
T1_M EQU 1 ;MODE (0..3)
TIM1 EQU T1_M+T1_C*4+T1_G*8

TMOD_SET EQU TIM0+TIM1*16

;50[ms] = 50 000[ŠS]*(11.0592[MHz]/12) =
; = 46 080 cykli = 180 * 256
TH0_SET EQU 256-180
TL0_SET EQU 0

TH1_SET EQU 0
TL1_SET EQU 0
;***********************************************

    LJMP START
    ORG 100H
START:
    LCALL WPROWADZ_CZAS
    LCALL WPROWADZ_CZAS2
    MOV TMOD,#TMOD_SET ;Timer 0 liczy czas
    MOV TH0,#TH0_SET ;Timer 0 na 50ms
    MOV TL0,#TL0_SET
    SETB TR0 ;start Timera
LOOP:                ;Pętla mrugania diody TEST
    LCALL USTAW_LCD
    LCALL SPRWADZ_SEC
    LCALL SPRWADZ_MIN
    LCALL SPRWADZ_GODZ
    CPL LED
    MOV R7,#20       ;odczekaj czas 20*50ms=1s
TIME_N50:
    JNB TF0,$        ;czekaj, aż Timer 0
                     ;odliczy 50ms
    MOV TH0,#TH0_SET ;TH0 na 50ms
    CLR TF0          ;zerowanie flagi timera 0
    DJNZ R7,TIME_N50 ;odczekanie N*50ms
    INC R2

    MOV A, R0
    CLR C
    SUBB A, R3
    CJNE A,#0, LOOP
    MOV A, R1
    CLR C
    SUBB A, R4
    CJNE A,#0, LOOP
    MOV A, R5
    CLR C
    SUBB A, R5
    CJNE A,#0, LOOP
    CPL LED
LOOP2:
    SJMP LOOP2
    NOP
SPRWADZ_SEC:
    MOV A, R2
    CLR C
    SUBB A, #59
    JC WYJDZ
    MOV R2, #0
    INC R1
WYJDZ:
    RET

SPRWADZ_MIN:
    MOV A, R1
    CLR C
    SUBB A, #60
    JC WYJDZ2
    MOV R1, #0
    INC R0
WYJDZ2:
    RET

SPRWADZ_GODZ:
    MOV A, R0
    CLR C
    SUBB A, #24
    JC WYJDZ3
    MOV R0, #0
WYJDZ3:
    RET

USTAW_LCD:
    LCALL LCD_CLR
    MOV A,R0
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
    MOV A,R1
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
    MOV A,R2
    LCALL BCD
    LCALL WRITE_HEX
    RET
WPROWADZ_CZAS:
    LCALL LCD_CLR 
    LCALL WPROWADZ
    MOV R0, A
    CLR C
    SUBB A, #25
    JNC WPROWADZ_CZAS
    MOV A, R0
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
WPROWADZ_MINUTY:
    LCALL WPROWADZ
    MOV R1, A
    CLR C
    SUBB A, #61
    JNC WPROWADZ_MINUTY
    MOV A, R1
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
WPROWADZ_SEC:
    LCALL WPROWADZ
    MOV R2, A
    CLR C
    SUBB A, #61
    JNC WPROWADZ_SEC
    MOV A, R2
    LCALL BCD
    LCALL WRITE_HEX
    RET

WPROWADZ_CZAS2:
    LCALL LCD_CLR 
    LCALL WPROWADZ
    MOV R3, A
    CLR C
    SUBB A, #25
    JNC WPROWADZ_CZAS2
    MOV A, R3
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
WPROWADZ_MINUTY2:
    LCALL WPROWADZ
    MOV R4, A
    CLR C
    SUBB A, #61
    JNC WPROWADZ_MINUTY2
    MOV A, R4
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
WPROWADZ_SEC2:
    LCALL WPROWADZ
    MOV R5, A
    CLR C
    SUBB A, #61
    JNC WPROWADZ_SEC2
    MOV A, R5
    LCALL BCD
    LCALL WRITE_HEX
    RET

WPROWADZ:
    LCALL WAIT_KEY ; Wczytaj liczbę dziesiątek
    MOV B,#10 ; pomnóż
    MUL AB ; przez 10
    MOV R5,A ; zapisz liczbę w R1
    LCALL WAIT_KEY ;wczytaj liczbę jedności
    ADD A,R5 ; dodaj liczbę jedności do R1
    RET ; wyjdź z podprogramu. Wynik w A.
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

    