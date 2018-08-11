		page 60,132
TITLE	DISP UP (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
MAIN	PROC	NEAR
		MOV		AX,0600H	; 06H - прокрутка вверх, 04H - на 4 строки, 00H - все строки
		MOV		BH,07		; Атрибут: нормальный, ч/б
		MOV		CX,0000H	; Прокрутить от 00,00 (0000H - начало)
		MOV		DX,184FH	;  до 24,79 (184FH - весь экран)
		INT		10H			; Передача управлени€ в BIOS
		RET
MAIN	ENDP
CODESG	ENDS
		END MAIN