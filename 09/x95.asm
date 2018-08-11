		page 60,132
TITLE	EX95 (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
A10:	SUB		AX,AX
		INT		16H
		CMP		AL,00		; Нажата специальная клавиша?
		JNZ		A10
		CMP		AH,51H		; Нажата клавиша PgDn?
		JNZ		A10
		CALL	CURS
		RET
MAIN	ENDP
CURS	PROC NEAR
		MOV		AH,02		; запрос на установку курсора
		MOV		BH,00		; экран 0 (страница)
		MOV		DH,12		; строка уже выбрана
		MOV		DL,00		; Столбец уже выбран
		INT		10H			; передача управления в BIOS
		RET
CURS	ENDP
CODESG	ENDS
		END MAIN