		page	60,132
		TITLE	EX711 (EXE)
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
X		DW		4DCFH	;Исходное значение
Y1		DW		?		;Результат
Y2		DW		?
DATASG	ENDS
;----------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:DATASG
        PUSH    DS
		SUB     AX,AX
        PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		MOV		ES,AX

		MOV		AX,X		;Загрузка исходного значения
		TEST	AX,8000H	;Проверка значения на знак
		JS		NEGX		;К добавлению разрядов для отриц. числа
		SUB		BX,BX		;Очистка регистра BX
		JMP		CALC		;Приступить к расчетам
NEGX:	MOV		BX,0FFFFH	;загрузка единиц во все биты

CALC:	CALL	X10
		RET
BEGIN   ENDP
;----------------------------------------------
X10		PROC
		SHL		AX,1		;Умножение на 2 (2x)
		MOV		DX,AX		;Сохранение полученного значения

		SHL		AX,1		;Умножение на 4 (8x)
		RCL		BX,1
		SHL		AX,1
		RCL		BX,1

		TEST	BX,8000H	;Проверка значения на знак
		JS		NEGX10		;К сложению отриц. чисел

		ADD		AX,DX		;Прибавить удвоенное значение (10x)
		JNC		ENDX10		;Если нет переноса - к окончанию
		INC		BX			;Увеличить BX на 1, если перенос
		JMP		ENDX10

NEGX10:	ADD		AX,DX		;Прибавить удвоенное значение (10x)
		JC		ENDX10		;Если есть перенос - к окончанию
		DEC		BX			;Уменьшить BX на 1, если нет переноса

ENDX10:	MOV		Y1,AX		;Запись результатов в память
		MOV		Y2,BX
		RET
X10		ENDP
;----------------------------------------------
CODESG  ENDS
		END BEGIN