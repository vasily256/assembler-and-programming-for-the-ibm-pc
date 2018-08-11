		page 60,132
TITLE	CURSOR (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
		MOV		AH,01	;Установка размера курсора
		MOV		CH,00	;Верхняя линия сканирования
		MOV		CL,13	;Нижняя линия сканирования
		INT		10H		;передача управления в BIOS
		RET
MAIN	ENDP
CODESG	ENDS
		END MAIN