STACK       SEGMENT PARA STACK
STACK_AREA  DW 100h DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
LIST_LEN    DW 4
ARRAY_LIST  DB 'BFG', '$'
            DB 'ABCDe', '$'
            DB 'DE3R', '$'
            DB 'abdf', '$'

EMPTY       DB 20H DUP(?)
TEMP        DB 20H DUP(?)
LEN         EQU 120
BUFF        DB LEN-1
            DB ?
STRING      DB LEN DUP(?)
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

            CALL DISPLAY_LIST

            PUSH SI
            MOV SI, OFFSET BUFF
            CALL READ_STRING

            MOV SI, OFFSET STRING
            POP DI
            PUSH DS
            POP ES
            CALL MEMMOVE

            MOV AX, LIST_LEN
            INC AX
            MOV SI, OFFSET LIST_LEN
            MOV [SI], AX

            CALL SORT_TABLE

            CALL DISPLAY_LIST

            MOV AX, 4C00H
            INT 21H

MAIN        ENDP

DISPLAY_LIST PROC
            MOV CX, LIST_LEN
            MOV SI, OFFSET ARRAY_LIST
LP2:        CALL DISPLAY_STRING
LP3:        MOV DL, BYTE PTR [SI]
            CMP DL, '$'
            JZ OUTLOOP
            INC SI
            JMP SHORT LP3

OUTLOOP:    INC SI
            MOV DL, ' '
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H
            LOOP LP2

            MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H
            RET
DISPLAY_LIST ENDP

READ_STRING PROC
            MOV DX, SI
            MOV AH, 0AH
            INT 21H

            XOR CX, CX
            MOV CL, BYTE PTR [SI+1]

            ADD SI, 2
            ADD SI, CX
            MOV BYTE PTR [SI], '$'

            MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H

READ_STRING ENDP

DISPLAY_STRING PROC
            PUSH DX
            PUSH AX
            MOV DX, SI
            MOV AH, 09H     ; Function to display string
            INT 21H
            ; MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            ; MOV AH, 02H               ; 功能号 02H 表示显示字符
            ; INT 21H
            POP AX
            POP DX
            RET
DISPLAY_STRING ENDP

STRING_CMP  PROC
            PUSH SI
            PUSH DI
            CLD
LP1:        LODSB
            CMP AL, ES:[DI]
            JA L1
            JB L2
            CMP AL, '$'
            JZ L3
            INC DI
            JMP SHORT LP1

L1:         MOV AX, 1
            JMP SHORT RETURN

L2:         MOV AX, -1
            JMP SHORT RETURN

L3:         MOV AX, 0

RETURN:     POP DI
            POP SI
            RET

STRING_CMP  ENDP

MEMMOVE     PROC
            PUSH DI
            PUSH SI
            PUSH CX
            XOR CX, CX
            PUSH SI
            CLD
LP4:        LODSB
            INC CX
            CMP AL, '$'
            JNZ LP4

            POP SI
            DEC CX
            CLD
LP5:        MOVSB
            LOOP LP5
            MOV BYTE PTR [DI], '$'
            POP CX
            POP SI
            POP DI
            RET

MEMMOVE     ENDP

SORT_TABLE  PROC
LP6:        MOV BX, 1
            MOV CX, LIST_LEN
            DEC CX
            LEA SI, ARRAY_LIST
LP7:        MOV DI, SI
LP8:        MOV AL, [DI]
            INC DI
            CMP AL, '$'
            JNZ LP8
            CALL STRING_CMP
            CMP AX, 1
            JNZ CONTINUE
            CALL STRING_XCHG
            MOV BX, 0
CONTINUE:   MOV SI, DI
            LOOP LP7
            CMP BX, 1
            JZ EXIT
            JMP SHORT LP6
EXIT:       RET
SORT_TABLE  ENDP
            
STRING_XCHG PROC
            PUSH DI
            MOV DI, OFFSET TEMP
            CALL MEMMOVE
            POP DI
            XCHG DI, SI
            CALL MEMMOVE
            XCHG DI, SI
            MOV DI, SI
LP9:        MOV DL, [DI]
            INC DI
            CMP DL, '$'
            JNZ LP9

            PUSH DI
            PUSH SI
            MOV SI, OFFSET TEMP
            CALL MEMMOVE
            POP SI
            POP DI
            RET
STRING_XCHG ENDP

CODE        ENDS

            END START