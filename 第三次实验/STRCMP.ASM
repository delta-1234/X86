STACK       SEGMENT PARA STACK
STACK_AREA  DW 100h DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
EMPTY       DB 20H DUP(?)
STRING1     DB '123456', '$'
LEN         EQU 120
BUFF        DB LEN-1
            DB ?
STRING2     DB LEN DUP(?)
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

            MOV DX, OFFSET BUFF
            MOV AH, 0AH
            INT 21H
            
            MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H

            XOR CX, CX
            MOV CL, BUFF+1

            LEA SI, STRING2
            ADD SI, CX
            MOV BYTE PTR [SI], '$'

            MOV SI, OFFSET STRING1
            CALL DISPLAY_STRING

            PUSH DS
            POP ES
            MOV SI, OFFSET STRING1
            MOV DI, OFFSET STRING2
            CALL STRING_CMP

            MOV DX, AX               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H

            MOV SI, OFFSET STRING2
            CALL DISPLAY_STRING

            MOV AX, 4C00H
            INT 21H
MAIN        ENDP

STRING_CMP  PROC
            CLD
LP1:        LODSB
            CMP AL, ES:[DI]
            JA L1
            JB L2
            CMP AL, '$'
            JZ L3
            INC DI
            JMP SHORT LP1

L1:         MOV AX, '>'
            JMP SHORT RETURN

L2:         MOV AX, '<'
            JMP SHORT RETURN

L3:         MOV AX, '='

RETURN:     RET

STRING_CMP  ENDP

DISPLAY_STRING PROC
            MOV DX, SI
            MOV AH, 09H     ; Function to display string
            INT 21H
            ; MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            ; MOV AH, 02H               ; 功能号 02H 表示显示字符
            ; INT 21H
            RET
DISPLAY_STRING ENDP

CODE        ENDS

            END START