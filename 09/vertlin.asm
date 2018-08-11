		page 60,132
TITLE	DISP CHAR (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
BEGIN:	JMP		MAIN

ROW		DB		08H		; ‚ысота (строка)

MAIN	PROC	NEAR
		MOV		DI,8	; ‘четчик высоты столбца
		CALL	CLN10	; Ћчистить экран
M10:	CALL	CURS20
		CALL	DISP30
		INC		ROW		; ‘ледующаЯ строка
		DEC		DI
		JNE		M10
		RET
MAIN	ENDP	

CLN10	PROC	NEAR
		MOV		AX,0600H	;06 - прокрутка вверх (07 - вниз, 09 - вывод символа с атрибутом), 00 - весь экран (установка режима)
		MOV		BH,07		;нормальный атрибут (черно-белый)
		MOV		CX,0000		;верхнЯЯ леваЯ позициЯ (строка, столбец)
		MOV		DX,184FH	;нижнЯЯ праваЯ позициЯ (строка, столбец)
		INT		10H			;передача управлениЯ в BIOS
		RET
CLN10	ENDP

CURS20	PROC	NEAR
		MOV		AH,02	;запрос на установку курсора
		MOV		BH,00	;экран 0 (страница)
		MOV		DH,ROW	;строка
		MOV		DL,39	;столбец
		INT		10H		;передача управлениЯ в BIOS
		RET
CURS20	ENDP
		
DISP30	PROC	NEAR
		MOV		AH,09		; ”ункциЯ вывода
		MOV		AL,0B3H		; ‚ыводимый символ
		MOV		BH,00		; Ќомер страницы
		MOV		BL,07H		; Ђтрибут
		MOV		CX,1		; ЏовторениЯ
		INT		10H			; Џередача управления в BIOS
		RET
DISP30	ENDP

CODESG	ENDS
		END		BEGIN