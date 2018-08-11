		page 60,132
TITLE	CLEAN (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
		MOV		AX,0600H	;06 - прокрутка вверх (07 - вниз, 09 - вывод символа с атрибутом), 00 - весь экран (установка режима)
		MOV		BH,07		;нормальный атрибут (черно-белый)
		MOV		CX,0000		;верхняя левая позиция (строка, столбец)
		MOV		DX,184FH	;нижняя правая позиция (строка, столбец)
		INT		10H			;передача управления в BIOS
		RET
MAIN	ENDP
CODESG	ENDS
		END MAIN