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
T1_M EQU 0 ;MODE (0..3)
TIM1 EQU T1_M+T1_C*4+T1_G*8

TMOD_SET EQU TIM0+TIM1*16

;50[ms] = 50 000[ŠS]*(11.0592[MHz]/12) =
; = 46 080 cykli = 180 * 256
TH0_SET EQU 256-180
TL0_SET EQU 0
;***********************************************

    LJMP START
    ORG 100H
START:
    LCALL LCD_CLR 
    LCALL WPROWADZ
    MOV R0, A
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
    LCALL WPROWADZ
    MOV R1, A
    LCALL BCD
    LCALL WRITE_HEX
    MOV A,#':'
    LCALL WRITE_DATA
    LCALL WPROWADZ
    MOV R2, A
    LCALL BCD
    LCALL WRITE_HEX
    NOP

    ;MOV TMOD,#TMOD_SET ;Timer 0 liczy czas
    ;MOV TH0,#TH0_SET ;Timer 0 na 50ms
    ;MOV TL0,#TL0_SET
    ;SETB TR0 ;start Timera


WPROWADZ:
    LCALL WAIT_KEY ; Wczytaj liczbę dziesiątek
    MOV B,#10 ; pomnóż
    MUL AB ; przez 10
    MOV R1,A ; zapisz liczbę w R1
    LCALL WAIT_KEY ;wczytaj liczbę jedności
    ADD A,R1 ; dodaj liczbę jedności do R1
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

    