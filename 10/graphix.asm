		page	60,132
		TITLE	GRAPHIX (EXE) ; Пример цвета и графики
;-------------------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;-------------------------------------------------------
CODESG  SEGMENT PARA 'Code'
MAIN	   PROC    FAR
		ASSUME  CS:CODESG,DS:NOTHING,SS:STACKSG,ES:NOTHING
        PUSH    DS
		SUB     AX,AX
        PUSH    AX

		MOV		AH,00		; Установка режима графики
		MOV		AL,0EH		; Режим
		INT		10H
		MOV		AH,0BH		; Установка палитры
		MOV		BH,00		; Фон
		MOV		BL,00		; Цвет
		INT		10H
		MOV		BX,00		; Начальный цвет,
		MOV		CX,00		;  столбец
		MOV		DX,00		;  и строка
A50:	
		MOV		AH,0CH		; Функция вывода точек
		MOV		AL,BL		; Установить цвет
		INT		10H			; BX, CX, DX сохраняются
		INC		CX
		CMP		CX,320
		JNE		A50
		MOV		CX,00
		INC		BL
		INC		DX
		CMP		DX,40
		JNE		A50
		RET
MAIN	ENDP
CODESG  ENDS
		END MAIN