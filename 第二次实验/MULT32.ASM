STACK       SEGMENT PARA STACK
STACK_AREA  DW 100h DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
MY_NAME     DB 'My name is 21373221 Deng Tao','$'
TEN         DW 10
COUNTER     DW 0
OP1         DD 12345678H ; 第一个操作数
OP2         DD 9ABCDEF0H ; 第二个操作数
RESULT      DD ? ; 存储乘法结果
            DD ?

RESULT_DEC  DB '00000000000000000000', '$'
DATA        ENDS

CODE        SEGMENT
            ASSUME CS:CODE, DS:DATA
            ASSUME SS:STACK
MAIN        PROC FAR

START:      MOV AX, DATA
            MOV DS, AX

            CALL DISPLAY_STRING

            LEA SI, RESULT
            MOV AX, WORD PTR [OP1]
            MOV BX, WORD PTR [OP2]
            MUL BX
            MOV [SI], AX
            MOV [SI+2], DX

            MOV AX, WORD PTR [OP1+2]
            MOV BX, WORD PTR [OP2]
            MUL BX
            MOV BX, [SI+2]
            ADD AX, BX
            ADC DX, 0
            XOR CX,CX
            ADC CX, 0
            MOV [SI+2], AX
            MOV [SI+4], DX
            MOV [SI+6], CX

            MOV AX, WORD PTR [OP1]
            MOV BX, WORD PTR [OP2+2]
            MUL BX
            MOV BX, [SI+2]
            ADD AX, BX
            MOV [SI+2], AX
            ADC DX, 0
            XOR CX, CX
            ADC CX, 0
            MOV BX, [SI+4]
            ADD DX, BX
            MOV [SI+4], DX
            ADC CX, 0
            MOV BX, [SI+6]
            ADD CX, BX
            MOV [SI+6], CX

            MOV AX, WORD PTR [OP1+2]
            MOV BX, WORD PTR [OP2+2]
            MUL BX
            MOV BX, [SI+4]
            ADD AX, BX
            MOV [SI+4], AX
            ADC DX, 0
            MOV [SI+6], DX


            MOV CX, 4
            LEA SI, RESULT+6
LOOP1:
            PUSH CX
            CALL DISPLAY_MEMORY
            POP CX
            SUB SI, 2
            LOOP LOOP1


            MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H

            CALL DISPLAY_MEMORY_DEC

            MOV DX, OFFSET RESULT_DEC
            MOV AH, 09H     ; Function to display string
            INT 21H

            MOV AX, 4C00H
            INT 21H

DISPLAY_MEMORY PROC
            MOV BX, [SI]
            MOV CX, 4

LP1:        PUSH CX
            MOV CL, 4
            ROL BX, CL
            MOV AL, BL
            AND AL, 0FH
            ADD AL, 30H
            CMP AL, 39H
            JBE DISP
            ADD AL, 'A'-'9'-1

DISP:       MOV DL, AL
            MOV AH, 2
            INT 21H
            POP CX
            LOOP LP1

            RET

DISPLAY_MEMORY ENDP

DISPLAY_MEMORY_DEC PROC
            MOV BX, WORD PTR [RESULT]
            MOV CX, WORD PTR [RESULT+2]
            MOV DI, WORD PTR [RESULT+4]
            MOV SI, WORD PTR [RESULT+6]
                                
LOOP0:      xor DX, DX
            MOV AX, SI               
            DIV [TEN]
            MOV SI, AX
            MOV AX, DI
            DIV [TEN]
            MOV DI, AX
            MOV AX, CX
            DIV [TEN]
            MOV CX, AX
            MOV AX, BX
            DIV [TEN]
            MOV BX, AX

            PUSH SI
            LEA SI, RESULT_DEC
            ADD SI, 19
            SUB SI, WORD PTR [COUNTER]
            ADD DX, '0'
            MOV BYTE PTR [SI], DL
            PUSH AX
            MOV AX, WORD PTR [COUNTER]
            ADD AX, 1
            MOV WORD PTR [COUNTER], AX
            POP AX
            POP SI

            CMP SI, 0
            JNE LOOP0
            CMP DI, 0
            JNE LOOP0
            CMP CX, 0
            JNE LOOP0
            CMP BX, 0
            JNE LOOP0

            PUSH AX
            XOR AX, AX
            MOV WORD PTR [COUNTER], AX
            POP AX
            RET

DISPLAY_MEMORY_DEC ENDP


; 子程序：显示字符串
DISPLAY_STRING PROC
            MOV DX, OFFSET MY_NAME
            MOV AH, 09H     ; Function to display string
            INT 21H
            MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H
            RET
DISPLAY_STRING ENDP

CODE        ENDS

            END START