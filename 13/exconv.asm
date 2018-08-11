		page	60,132
		TITLE	EXCONV (EXE) Преобр. ASCII и дв. форматов
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
ASCVAL	DB		'1234'
BINVAL	DW		0
ASCLEN	DW		4
MULT10	DW		1
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
		
		CALL	B10ASBI
		CALL	C10BIAS
		RET
BEGIN	ENDP
;				Преобразование ASCII в двоичное:
;				-------------------------------
B10ASBI	PROC	NEAR
		MOV		CX,10		; Фактор умножения
		LEA		SI,ASCVAL-1	; Адрес ASCVAL
		MOV		BX,ASCLEN	; Длина ASCVAL
B20:	
		MOV		AL,[SI+BX]	; Выбрать ASCII-символ
		AND		AX,000FH	; Очистить зону тройки
		MUL		MULT10		; Умножить на 10^X
		ADD		BINVAL,AX
		MOV		AX,MULT10
		MUL		CX
		MOV		MULT10,AX
		DEC		BX
		JNZ		B20
		RET
B10ASBI	ENDP
;				Преобразование двоичного в ASCII:
;				-------------------------------
C10BIAS	PROC	NEAR
		MOV		CX,10
		LEA		SI,ASCVAL+3
		MOV		AX,BINVAL
C20:
		CMP		AX,0010
		JB		C30
		XOR		DX,DX
		DIV		CX
		OR		DL,30H
		MOV		[SI],DL
		DEC		SI
		JMP		C20
C30:
		OR		AL,30H
		MOV		[SI],AL
		RET
C10BIAS	ENDP
CODESG  ENDS
		END BEGIN