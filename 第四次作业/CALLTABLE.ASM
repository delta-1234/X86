STACK       SEGMENT PARA STACK
STACK_AREA  DW 100H DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
STRING1     DB 'MY NAME IS DENGTAO', 00H
LEN         EQU 20H
NUM_BUF     DB 3
            DB ?
            DB 4 DUP(?)
IN_BUF      DB LEN-1
            DB ?
STRING2     DB LEN DUP(?)
CALL_TABLE  DW FUNC0, FUNC1, FUNC2, FUNC3, FUNC4, FUNC5
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
            PUSH DS
            POP ES

MAIN_LP:    MOV SI, OFFSET NUM_BUF
            PUSH SI
            CALL READ_NUM
            SHL AX, 1
            MOV BX, OFFSET CALL_TABLE
            ADD BX, AX
            JMP [BX]

FUNC0:      JMP MAIN_END

FUNC1:      MOV SI, OFFSET IN_BUF
            PUSH SI
            CALL READ_STR
            JMP MAIN_LP

FUNC2:      MOV SI, OFFSET STRING2
            PUSH SI
            XOR DX, DX
            MOV DL, 'A'
            PUSH DX
            CALL FIND
            JMP MAIN_LP

FUNC3:      MOV SI, OFFSET STRING1
            PUSH SI
            MOV SI, OFFSET STRING2
            PUSH SI
            CALL STR_CMP
            JMP MAIN_LP

FUNC4:      MOV SI, OFFSET STRING1
            PUSH SI
            MOV DI, OFFSET STRING2
            PUSH DI
            CALL MEMMOVE
            JMP MAIN_LP

FUNC5:      MOV SI, OFFSET STRING2
            PUSH SI
            CALL DISPLAY_STR
            JMP MAIN_LP

MAIN_END:   MOV AH, 4CH
            INT 21H
MAIN        ENDP
READ_NUM    PROC
            PUSH BP
            MOV BP, SP
            MOV DX, [BP+4]

            MOV AH, 0AH
            INT 21H

            MOV DL, 0AH
            MOV AH, 02H
            INT 21H

            MOV SI, [BP+4]
            MOV DL, BYTE PTR [SI+2]
            SUB DL, '0'
            XOR AX, AX
            MOV AL, DL
            POP BP
            RET 2
READ_NUM    ENDP

READ_STR    PROC
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
READ_STR    ENDP

FIND        PROC
            PUSH BP   
            MOV BP, SP 
            MOV DX, [BP+4]
            MOV SI, [BP+6]
            XOR AX, AX

FIND_LP1:   CMP DL, BYTE PTR DS:[SI]
            JZ PULS
            JMP EL
PULS:       INC AX
EL:         CMP BYTE PTR DS:[SI], 00H
            JZ FIND_OUT
            INC SI
            JMP FIND_LP1

FIND_OUT:   MOV DL, AL
            ADD DL, '0'
            MOV AH, 02H
            INT 21H

            MOV DL, 0AH
            MOV AH, 02H
            INT 21H
            POP BP
            RET 4
FIND        ENDP


STR_CMP     PROC
            PUSH BP
            MOV BP, SP
            MOV SI, [BP+4]
            MOV DI, [BP+6]
            CLD
CMP_LP1:    LODSB
            CMP AL, ES:[DI]
            JA CMP_L1
            JB CMP_L2
            CMP AL, 00H
            JZ CMP_L3
            INC DI
            JMP SHORT CMP_LP1

CMP_L1:     MOV DL, '1'
            MOV AH, 02H
            INT 21H
            JMP SHORT RETURN

CMP_L2:     MOV DL, '-'
            MOV AH, 02H
            INT 21H
            MOV DL, '1'
            INT 21H
            JMP SHORT RETURN

CMP_L3:     MOV DL, '0'
            MOV AH, 02H
            INT 21H

RETURN:
            MOV DL, 0AH
            MOV AH, 02H
            INT 21H
            POP BP
            RET 4

STR_CMP     ENDP

MEMMOVE     PROC
            PUSH BP
            MOV BP, SP
            MOV DI, [BP+4]
            MOV SI, [BP+6]
            XOR CX, CX
            PUSH SI
            CLD
MEM_LP1:    LODSB
            INC CX
            CMP AL, 00H
            JNZ MEM_LP1

            POP SI
            DEC CX
            CLD
MEM_LP2:    MOVSB
            LOOP MEM_LP2
            MOV BYTE PTR [DI], 00H

            POP BP
            RET 4

MEMMOVE     ENDP

DISPLAY_STR PROC
            PUSH BP
            MOV BP, SP
            MOV SI, [BP+4]
DIS_LP1:    MOV DL, BYTE PTR[SI]
            CMP DL, 00H
            JZ OUTLP1
            INC SI
            MOV AH, 02H
            INT 21H
            JMP DIS_LP1
OUTLP1:     MOV DL, 0AH
            MOV AH, 02H
            INT 21H
            POP BP
            RET 2

DISPLAY_STR ENDP

CODE        ENDS
            END MAIN