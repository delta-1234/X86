STACK       SEGMENT PARA STACK
STACK_AREA  DW 100h DUP(?)
STACK_TOP   EQU $-STACK_AREA
STACK       ENDS

DATA        SEGMENT PARA
TABLE_LEN   DW 16
TABLE       DW 2106,3221,400,10,20,0,1,8
            DW 41H,40,42H,2321h,60,0FFFFH,2,3

MY_NAME     DB 'My name is 21373221 Deng Tao','$'

DATA        ENDS

CODE        SEGMENT
            ASSUME CS:CODE, DS:DATA
            ASSUME SS:STACK
MAIN        PROC FAR

START:      MOV AX, STACK
            MOV SS, AX
            MOV SP, STACK_TOP
            MOV AX, DATA
            MOV DS, AX       ; 设置 SS,SP,DS

            CALL DISPLAY_SORT
            CALL DISPLAY_STRING      ; 调用显示字符串子程序
            CALL SORT_TABLE          ; 调用排序子程序
            CALL DISPLAY_SORT

            MOV AX, 4C00H
            INT 21H
MAIN        ENDP

; 子程序：排序表格
SORT_TABLE  PROC
LP1:        MOV BX, 1
            MOV CX, TABLE_LEN
            DEC CX
            LEA SI, TABLE
LP2:        MOV AX, [SI]
            CMP AX, [SI+2]
            JBE CONTINUE
            XCHG AX, [SI+2]
            MOV [SI], AX
            MOV BX, 0
CONTINUE:   ADD SI, 2
            LOOP LP2
            CMP BX, 1
            JZ EXIT
            JMP SHORT LP1
EXIT:       RET
SORT_TABLE  ENDP

; 子程序：显示排序前的字表
DISPLAY_SORT PROC
            MOV DX, OFFSET TABLE
            MOV CX, TABLE_LEN
            LEA SI, TABLE
LOOP1:      
            PUSH CX
            CALL DISPLAY_MEMORY_DEC
            ADD SI, 2                 ; 移动到下一个字
            POP CX
            MOV DL, 20H               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H
            LOOP LOOP1
            
            MOV DL, 0AH               ; 0AH 是换行符的 ASCII 值，line feed
            MOV AH, 02H               ; 功能号 02H 表示显示字符
            INT 21H
            RET
DISPLAY_SORT ENDP

; 子程序：显示内存中的字（十进制）
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
