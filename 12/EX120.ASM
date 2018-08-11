		page	60,132
		TITLE	P123 (EXE) Деление
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
DATAX	DW		0148H
		DW		2316H
DATAY	DW		0237H
		DW		5052H
CYCLE	DB		5
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
		CALL	B10SUM		; 12.1 Сложение
		CALL	C10SUM		; 12.2 Сложение с переносом
		CALL	E10MUL		; 12.3 Умножение
		CALL	F10DIV		; 12.5 Деление
		CALL	E10SHR		; 12.6 Сдвиг регистровой пары
		RET
BEGIN	ENDP
;				12.1 Сложение:
;				-------------------------------
B10SUM	PROC	NEAR
		MOV		AX,DATAX	; а) 2-х слов
		ADD		AX,DATAY
		SUB		DX,DX		; б) 2-х дв.слов
		MOV		AX,DATAX+2	;	сложение мл. слов
		ADD		AX,DATAY+2
		ADC		DX,DATAX	;	сложене ст. слов
		ADD		DX,DATAY
		RET
B10SUM	ENDP
;				12.2 Сложение с переносом:
;				-------------------------------
C10SUM	PROC	NEAR
		STC					; Установить 1 в CF
		MOV		BX,DATAX
		ADC		BX,DATAY
		RET
C10SUM	ENDP
;				12.3 Умножение:
;				-------------------------------
E10MUL	PROC	NEAR
		MOV		AX,DATAX	; а) 2-х слов
		MUL		DATAY
		MOV		AX,DATAX	; б) дв.слова на слово:
		MUL		DATAY		;	умножение ст.слова
		MOV		BX,AX		;	сохранение произвед.
		MOV		CX,DX
		MOV		AX,DATAX+2
		MUL		DATAY		;	умножение мл.слова
		ADD		DX,BX
		ADC		CX,00		;	произвед. в CX:DX:AX
		RET
E10MUL	ENDP
;				12.5 Деление:
;				-------------------------------
F10DIV	PROC	NEAR
		MOV		AX,DATAX	; а) слово на байт
		MOV		BL,23
		DIV		BL
		MOV		AX,DATAX+2	; б) дв.слово на слово
		MOV		DX,DATAX
		DIV		DATAY
		RET
F10DIV	ENDP
;				12.6 Сдвиг регистровой пары:
;				-------------------------------
E10SHR	PROC	NEAR
		MOV		CL,CYCLE
		MOV		AX,DATAX+2
		MOV		DX,DATAX
		SHR		AX,CL
		MOV		BX,DX
		SHR		DX,CL		; = 0AH
		SUB		CL,16
		NEG		CL
		SHL		BX,CL		; = 4000H
		OR		AX,BX
		RET
E10SHR	ENDP
CODESG  ENDS
		END BEGIN