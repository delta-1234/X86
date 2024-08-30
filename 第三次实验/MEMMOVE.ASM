STACK       SEGMENT PARA STACK
STACK_AREA  DW 100h DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
EMPTY       DB 20H DUP(?)
STRING1     DB 'MY NAME IS DENGTAO', '$'
STRING2     DB 20H DUP(?)

DATA        ENDS

CODE        SEGMENT
            ASSUME CS:CODE, DS:DATA
            ASSUME SS:STACK
MAIN        PROC 

START:      MOV AX, STACK
            MOV SS, AX
            MOV SP, STACK_TOP
            MOV AX, DATA
            MOV DS, AX       ; 设置 SS,SP,DS

            PUSH DS
            POP ES
            MOV SI, OFFSET STRING1
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING1
            MOV DI, OFFSET STRING2

            CALL MEMMOVE

            MOV SI, OFFSET STRING1
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING2
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING1
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING1
            MOV DI, OFFSET STRING1
            SUB DI, 4

            CALL MEMMOVE

            MOV SI, OFFSET STRING1
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING1  
            SUB SI, 4
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING1
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING1
            MOV DI, OFFSET STRING1
            ADD DI, 4

            CALL MEMMOVE

            MOV SI, OFFSET STRING1
            CALL DISPLAY_STRING

            MOV SI, OFFSET STRING1 
            ADD SI, 4
            CALL DISPLAY_STRING         

            MOV AX, 4C00H
            INT 21H

MAIN        ENDP

MEMMOVE     PROC
            XOR CX, CX
            PUSH SI
            CLD
LP1:        LODSB
            INC CX
            CMP AL, '$'
            JNZ LP1

            POP SI
            DEC CX
            CLD
LP2:        MOVSB
            LOOP LP2
            MOV BYTE PTR [DI], '$'
            RET

MEMMOVE     ENDP


DISPLAY_STRING PROC
            MOV DX, SI
            MOV AH, 09H     ; Function to display string
            INT 21H
            MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H
            RET
DISPLAY_STRING ENDP

CODE        ENDS

            END START