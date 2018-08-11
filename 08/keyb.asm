		page 60,132
TITLE	KEYB (COM)
CODESG	SEGMENT	PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:NOTHING
		ORG		100H
BEGIN:	JMP		SHORT INP
;------------------------------------------------------
;		Список параметров:
NAMEPAR	LABEL	BYTE
MAXLEN	DB		20				; максимальная длина
ACTLEN	DB		?               ; реальная длина
NAMEFLD	DB		20 DUP (' ')    ; введенные символы
;------------------------------------------------------
;		Процедура ввода:
INP		PROC	NEAR
		MOV		AH,0AH		;запрос функции ввода
		LEA		DX,NAMEPAR	;загрузка адреса списка параметра
		INT		21H			;вызов DOS
		RET
INP		ENDP
CODESG	ENDS
		END		BEGIN