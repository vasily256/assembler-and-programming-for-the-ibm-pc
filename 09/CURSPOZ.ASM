		page 60,132
TITLE	CURSOR (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
		MOV		AH,02	;запрос на установку курсора
		MOV		BH,00	;экран 0 (страница)
		MOV		DH,15	;15-я строка
		MOV		DL,42	;42-й столбец
		INT		10H		;передача управления в BIOS
		RET
MAIN	ENDP
CODESG	ENDS
		END MAIN