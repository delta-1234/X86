STACK       SEGMENT PARA STACK
STACK_AREA  DW 100H DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
N           DW 6
DATA        ENDS

CODE        SEGMENT
            ASSUME CS:CODE, DS:DATA
            ASSUME SS:STACK

MAIN        PROC
            MOV AX, STACK
            MOV SS, AX
            MOV SP, STACK_TOP
            MOV AX, DATA
            MOV DS, AX

            MOV AX, N
            PUSH AX
            CALL CALCULATE
            CALL DISP_VALUE

            MOV AH, 4CH
            INT 21H
            
MAIN        ENDP

CALCULATE   PROC
            PUSH BP
            MOV BP, SP
            PUSH DX
            PUSH BX
            MOV BX, [BP+4]
            CMP BX, 0
            JNZ CAL1
            MOV AX, 1
            JMP SHORT CAL2

CAL1:       PUSH BX
            DEC BX
            PUSH BX
            CALL CALCULATE
            POP BX
            MUL BX

CAL2:       POP BX
            POP DX
            POP BP
            RET 2
CALCULATE   ENDP

DISP_VALUE  PROC
            PUSH DX
            PUSH CX
            PUSH BX
            PUSH AX

            MOV CX, 5
            MOV BX, 10

DLP1:       XOR DX, DX
            DIV BX
            PUSH DX
            LOOP DLP1
            MOV BX, 0
            MOV CX, 5

DLP2:       POP DX
            CMP DL, 0
            JNZ DLP2_1
            CMP BX, 0
            JZ DLP2_2

DLP2_1:     MOV BX, 1
            OR DL, 30H
            MOV AH, 2
            INT 21H

DLP2_2:     LOOP DLP2

            POP AX
            POP BX
            POP CX
            POP DX
            RET

DISP_VALUE  ENDP

CODE        ENDS
            END MAIN
