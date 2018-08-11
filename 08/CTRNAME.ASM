		page	60,132
		TITLE	CTRNAME (EXE)
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
;		Список параметров:
NAMEPAR	LABEL	BYTE
MAXLEN	DB		20					; Максимальная длина имени
NAMELEN	DB		?               	; Число введенных символов
NAMEFLD	DB		20 DUP (' '),'$'	; Введенное имя и ограничитель вывода на экран
PROMPT	DB		'Name? ','$'		; Выводимый текст запроса на ввод
DATASG	ENDS						;
;----------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:DATASG
        PUSH    DS
		SUB     AX,AX
        PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		MOV		ES,AX

		CALL	Q10CLR		; Очистка экрана
		MOV		DX,0000		; Установка курсора
		CALL	Q20CURS		; (0-я строка, 0-й столбец)
		CALL	B10PRMP		; Выдать текст с сообщением запроса
		CALL	D10INPT		; Ввести имя
		CALL	Q10CLR		; Очистка экрана
		CMP		NAMELEN,00	; Имя введено?
		JE		A30			; 	Нет - выйти
		CALL	E10CODE		; Установка звука и '$' для отсечения пробелов
		CALL	F10CENT		; Центрирование и вывод
A30:	RET
BEGIN   ENDP
;-------------------------------------------------------
;		Вывод текста запроса на ввод:
B10PRMP	PROC	NEAR
		MOV		AH,09		; Запрос вывода на экран
		LEA		DX,PROMPT	; Адрес выводимого на экран сообщения
		INT		21H			; Вызов DOS
		RET
B10PRMP	ENDP
;------------------------------------------------------
;		Процедура ввода:
D10INPT	PROC	NEAR
		MOV		AH,0AH		;запрос функции ввода
		LEA		DX,NAMEPAR	;загрузка адреса списка параметра
		INT		21H			;вызов DOS
		RET
D10INPT	ENDP
;------------------------------------------------------
;		Установка звука и '$' для отсечения пробелов:
E10CODE	PROC	NEAR
		MOV		BH,00
		MOV		BL,NAMELEN
		MOV		NAMEFLD[BX],07	;07H - символ звука
		MOV		NAMEFLD[BX+1],'$'
		RET
E10CODE	ENDP
;-------------------------------------------------------
;		Центрирование и вывод имени:
F10CENT	PROC	NEAR
		MOV		DL,NAMELEN	; Определение столбца
		SHR		DL,1		;  разделить на 2,
		NEG		DL			;  поменять знак,
		ADD		DL,40		;  прибавить 40
		MOV		DH,12		; Центральная строка
		CALL	Q20CURS		; Установить курсор

		MOV		AH,09		; Запрос вывода на экран
		LEA		DX,NAMEFLD	; Адрес выводимого на экран сообщения
		INT		21H			; Вызов DOS
		RET
F10CENT	ENDP
;-------------------------------------------------------
;		Очистка экрана:
Q10CLR	PROC	NEAR
		MOV		AX,0600H	; 06 - прокрутка, 00 - весь экран
		MOV		BH,30		; Цвет (07 - для ч/б)
		MOV		CX,0000		; Верхняя левая позиция (строка, столбец)
		MOV		DX,184FH	; Нижняя правая позиция (строка, столбец)
		INT		10H			; Передача управления в BIOS
		RET
Q10CLR	ENDP
;-------------------------------------------------------
;		Установка курсора:
Q20CURS	PROC	NEAR		; Координаты курсора уже установлены
		MOV		AH,02		; Запрос на установку курсора
		MOV		BH,00		; Страница #0
		INT		10H			; Предача управления в BIOS
		RET
Q20CURS	ENDP
;----------------------------------------------
CODESG  ENDS
		END BEGIN