TITLE	XLATE (COM) Перевод ASCII в EBCDIC
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
;-----------------------------------------------------------
ASCNO	DB	'-31.5 '
EBCNO	DB	6 DUP(' ')
XLTAB	DB	45 DUP(40H)
		DB	60H, 4BH
		DB	5CH
		DB	0F0H,0F1H,0F2H,0F3H,0F4H
		DB	0F5H,0F6H,0F7H,0F8H,0F9H
		DB	199 DUP(40H)
DESCRN	DB	10 DUP(?)
;-----------------------------------------------------------
MAIN	PROC	NEAR
		LEA		SI,ASCNO	; Адрес текста ASCII-формата
		LEA		DI,EBCNO	; Адрес поля EBCDIC-формата
		MOV		CX,06		; Длина текста (с пробелом)
		LEA		BX,XLTAB	; Адрес таблицы
A20:
		MOV		AL,[SI]
		XLAT
		MOV		[DI],AL
		INC		DI
		INC		SI
		LOOP	A20
		RET
MAIN	ENDP

CODESG	ENDS
		END		BEGIN