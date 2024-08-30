STACK       SEGMENT PARA STACK
STACK_AREA  DW 100h DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
MY_NAME     DB 'My name is 21373221 Deng Tao','$'
OP1         DW ? ; 第一个操作数
OP2         DW ? ; 第二个操作数
RESULT      DW ? ; 存储乘法结果
DATA        ENDS

CODE        SEGMENT
            ASSUME CS:CODE, DS:DATA
            ASSUME SS:STACK
MAIN        PROC FAR

START:      MOV AX, DATA
            MOV DS, AX

            CALL DISPLAY_STRING

            LEA SI, OP1
            CALL READ_INT

            LEA SI, OP2
            CALL READ_INT

            ; 计算乘法结果
            MOV AX, [OP1]  ; 将第一个数字存入AX寄存器
            MOV BX, [OP2]
            MUL BX      ; 乘以第二个数字，结果存放在AX中
            MOV WORD PTR [RESULT], AX ; 将结果存入RESULT变量

            LEA SI, RESULT
            CALL DISPLAY_MEMORY_DEC
            MOV AH, 4CH
            INT 21H


READ_INT PROC
            PUSH SI
            MOV SI, 0
            MOV BX, 10

LP1:        MOV AH, 1
            INT 21H
            CMP AL, 0DH
            JE RETURN
            CMP AL, 30H
            JB LP1
            CMP AL, 39H
            JA LP1
            SUB AL,30H
            XOR AH,AH
            PUSH AX
            MOV AX, SI
            MUL BX
            MOV SI, AX
            POP AX
            ADD SI, AX
            LOOP LP1

RETURN:     MOV AX, SI
            POP SI
            MOV [SI], AX
            RET

READ_INT ENDP

DISPLAY_MEMORY_DEC PROC
            MOV CX, 5
            MOV AX, [SI]   ; 读取内存中的字
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