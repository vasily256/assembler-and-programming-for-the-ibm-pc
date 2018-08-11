		page 60,132
TITLE	CLEAN (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
		MOV		AX,0600H	;06 - прокрутка вверх (07 - вниз, 09 - вывод символа с атрибутом), 00 - весь экран (установка режима)
		MOV		BH,07		;нормальный атрибут (черно-белый)
		MOV		CX,0000		;верхнЯЯ леваЯ позициЯ (строка, столбец)
		MOV		DX,184FH	;нижнЯЯ праваЯ позициЯ (строка, столбец)
		INT		10H			;передача управлениЯ в BIOS
		RET
MAIN	ENDP
CODESG	ENDS
		END MAIN