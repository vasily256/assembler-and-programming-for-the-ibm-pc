		page 60,132
TITLE	DISP CHAR (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
		MOV		AH,09		; ”ункциЯ вывода
		MOV		AL,0C4H		; ‚ыводимый символ
		MOV		BH,00		; Ќомер страницы
		MOV		BL,0F0H		; Ђтрибут (мигание, инверсиЯ)
		MOV		CX,25		; ЏЯть повторений
		INT		10H			; Џередача управления в BIOS
		RET
MAIN	ENDP
CODESG	ENDS
		END MAIN