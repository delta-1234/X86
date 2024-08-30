STACK           SEGMENT PARA STACK
STACK_AREA      DW 100H DUP(?)
STACK_TOP       EQU $-STACK_AREA
STACK           ENDS

DATA            SEGMENT PARA
STRING1         DB 'MY NAME IS '
EMPTY           DB 20H DUP(?)
LEN             EQU 20H
IN_BUF          DB LEN-1
                DB ?
STRING2         DB LEN DUP(?)
DATA            ENDS

CODE            SEGMENT
                ASSUME CS:CODE, DS:DATA
                ASSUME SS:STACK

MAIN            PROC
                MOV AX, STACK
                MOV SS, AX
                MOV SP, STACK_TOP
                MOV AX, DATA
                MOV DS, AX

                MOV SI, OFFSET IN_BUF
                PUSH SI
                CALL READ_STRING

                MOV SI, OFFSET STRING1
                PUSH SI
                MOV SI, OFFSET STRING2
                PUSH SI
                CALL STRCAT

                MOV SI, OFFSET STRING1
                PUSH SI
                CALL DISPLAY_STR
                
                MOV AH, 4CH
                INT 21H
MAIN            ENDP

READ_STRING     PROC
                PUSH BP
                MOV BP, SP
                MOV DX, [BP+4]

                MOV AH, 0AH
                INT 21H

                MOV DL, 0AH
                MOV AH, 02H
                INT 21H
                POP BP
                RET 2
READ_STRING     ENDP

STRCAT          PROC
                PUSH BP
                MOV BP, SP
                
                MOV DI, [BP+4]
                MOV SI, [BP+6]
                
LP1:            MOV DL, BYTE PTR[SI]
                INC SI
                CMP DL, 00H
                JNZ LP1

                DEC SI
LP2:            MOV DL, BYTE PTR[DI]
                MOV BYTE PTR[SI], DL
                INC SI
                INC DI
                CMP DL, 00H
                JNZ LP2

                POP BP
                RET 4
STRCAT          ENDP

DISPLAY_STR     PROC
                PUSH BP
                MOV BP, SP

                MOV SI, [BP+4]
LP3:            MOV DL, BYTE PTR[SI]
                CMP DL, 00H
                JZ OUTLP3
                INC SI
                MOV AH, 02H
                INT 21H
                JMP LP3
OUTLP3:         POP BP
                RET 2

DISPLAY_STR     ENDP

CODE            ENDS
                END MAIN