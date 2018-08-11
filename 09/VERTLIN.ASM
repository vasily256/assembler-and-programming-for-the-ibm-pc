		page 60,132
TITLE	DISP CHAR (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
BEGIN:	JMP		MAIN

ROW		DB		08H		; Высота (строка)

MAIN	PROC	NEAR
		MOV		DI,8	; Счетчик высоты столбца
		CALL	CLN10	; Очистить экран
M10:	CALL	CURS20
		CALL	DISP30
		INC		ROW		; Следующая строка
		DEC		DI
		JNE		M10
		RET
MAIN	ENDP	

CLN10	PROC	NEAR
		MOV		AX,0600H	;06 - прокрутка вверх (07 - вниз, 09 - вывод символа с атрибутом), 00 - весь экран (установка режима)
		MOV		BH,07		;нормальный атрибут (черно-белый)
		MOV		CX,0000		;верхняя левая позиция (строка, столбец)
		MOV		DX,184FH	;нижняя правая позиция (строка, столбец)
		INT		10H			;передача управления в BIOS
		RET
CLN10	ENDP

CURS20	PROC	NEAR
		MOV		AH,02	;запрос на установку курсора
		MOV		BH,00	;экран 0 (страница)
		MOV		DH,ROW	;строка
		MOV		DL,39	;столбец
		INT		10H		;передача управления в BIOS
		RET
CURS20	ENDP
		
DISP30	PROC	NEAR
		MOV		AH,09		; Функция вывода
		MOV		AL,0B3H		; Выводимый символ
		MOV		BH,00		; Номер страницы
		MOV		BL,07H		; Атрибут
		MOV		CX,1		; Повторения
		INT		10H			; Передача управлени€ в BIOS
		RET
DISP30	ENDP

CODESG	ENDS
		END		BEGIN