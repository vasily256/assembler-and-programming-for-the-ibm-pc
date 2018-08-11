		page 60,132
TITLE	DISPLAY (COM)
CODESG	SEGMENT	PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H

BEGIN:	JMP		MAIN
NAMPRMP	DB		'Enter you name','$'

MAIN	PROC	NEAR
		MOV		AH,09		;запрос вывода на экран
		LEA		DX,NAMPRMP	;адрес выводимого на экран сообщения
		INT		21H			;вызов DOS
		RET
MAIN	ENDP
CODESG	ENDS
		END		BEGIN