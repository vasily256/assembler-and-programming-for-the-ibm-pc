		page 60,132
TITLE	ALLASC (COM)
CODESG	SEGMENT	PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:NOTHING
		ORG		100H
BEGIN:	JMP		SHORT MAIN
CTR		DB		00,'$'
;-------------------------------------------------------
;		Основная процедура:
MAIN	PROC	NEAR
		CALL	B10CDR		;очистить экран
		CALL	C10SET		;установить курсов
		CALL	D10DISP		;вывести символы на экран
		RET
MAIN	ENDP
;-------------------------------------------------------
;		Очистка экрана:
B10CDR	PROC
		MOV		AX,0600H	;06 - прокрутка, 00 - весь экран
		MOV		BH,07		;нормальный атрибут (черно-белый)
		MOV		CX,0000		;верхняя левая позиция
		MOV		DX,184FH	;нижняя правая позиция
		INT		10H			;передача управлени¤ в BIOS
		RET
B10CDR	ENDP
;-------------------------------------------------------
;		Установка курсора:
C10SET	PROC
		MOV		AH,02		;запрос на установку курсора
		MOV		BH,00		;экран 0
		MOV		DX,0000		;0-я строка, 0-й столбец
		INT		10H			;передача управления в BIOS
		RET
C10SET	ENDP
;-------------------------------------------------------
;		Вывод на экран ASCII-символов:
D10DISP	PROC
		MOV		CX,256		;256 итерациЙ для 256 символов
		MOV		AH,09		;запрос вывода на экран
		LEA		DX,CTR		;адрес выводимого на экран сообщения

D20:	INT		21H			;вызов DOS
		INC		CTR
		LOOP	D20
		RET
D10DISP	ENDP

CODESG	ENDS
		END BEGIN