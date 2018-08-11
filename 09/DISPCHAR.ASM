		page 60,132
TITLE	DISP CHAR (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
		MOV		AH,09		; Функция вывода
		MOV		AL,0C4H		; Выводимый символ
		MOV		BH,00		; Номер страницы
		MOV		BL,0F0H		; Атрибут (мигание, инверсия)
		MOV		CX,25		; Пять повторений
		INT		10H			; Передача управлени€ в BIOS
		RET
MAIN	ENDP
CODESG	ENDS
		END MAIN