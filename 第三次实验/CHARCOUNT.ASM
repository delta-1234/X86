STACK       SEGMENT PARA STACK
STACK_AREA  DW 100h DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
LEN         EQU 120
BUFF        DB LEN-1
            DB ?
STRING     DB LEN DUP(?)
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

            MOV SI, OFFSET BUFF
            CALL READ_STRING

            LEA SI, STRING
            PUSH SI
            PUSH CX
            MOV AL, 'A'
            CALL FIND

            CALL DISPLAY_MEMORY_DEC
            
            MOV AX, 4C00H
            INT 21H
MAIN        ENDP

FIND        PROC
            MOV DL, AL
            XOR AX, AX
            POP BX
            POP CX
            POP SI
            PUSH BX

LP1:        CMP DL, BYTE PTR DS:[SI]
            JZ PULS
            JMP EL
PULS:       INC AX
EL:         INC SI
            LOOP LP1

            RET
FIND        ENDP

DISPLAY_MEMORY_DEC PROC
            MOV CX, 5
            MOV BX, 10
            
LP3:        XOR DX, DX
            DIV BX
            OR DL, 30H
            PUSH DX
            LOOP LP3

            MOV CX, 5
LP4:        POP DX
            MOV AH, 2
            INT 21H
            LOOP LP4
            RET
DISPLAY_MEMORY_DEC ENDP

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