		page	60,132
		TITLE	P123 (EXE) Умножение
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
BYTE1	DB		80H
BYTE2	DB		40H
WORD1	DW		8000H
WORD2	DW		4000H
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
		CALL	C10MUL		; Умножение MUL
		CALL	D10IMUL		; Умножение IMUL
		RET
BEGIN	ENDP
;				Умножение MUL (беззнаковое):
;				-------------------------------
C10MUL	PROC	NEAR
		MOV		AL,BYTE1	; Байт * байт
		MUL		BYTE2		;  Произведение в AX
		MOV		AX,WORD1	; Слово * слово
		MUL		WORD2		;  Произведение в DX:AX
		MOV		AL,BYTE1	; Байт * слово
		SUB		AH,AH		;  Расширение множителя
		MUL		WORD1		;  Произведение в DX:AX
		RET
C10MUL	ENDP
;				Умножение IMUL (знаковое):
;				-------------------------------
D10IMUL	PROC	NEAR
		MOV		AL,BYTE1	; Байт * байт
		IMUL	BYTE2		;  Произведение в AX
		MOV		AX,WORD1	; Слово * слово
		IMUL	WORD2		;  Произведение в DX:AX
		MOV		AL,BYTE1	; Байт * слово
		CBW					;  Расширение множителя
		IMUL	WORD1		;  Произведение в DX:AX
		RET
D10IMUL	ENDP
CODESG  ENDS
		END BEGIN