		page	60,132
		TITLE	NMSCROLL (EXE) Инверсия, мигание, прокрутка
;-------------------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;-------------------------------------------------------
DATASG	SEGMENT	PARA 'Data'
;		Список параметров:
NAMEPAR	LABEL	BYTE
MAXLEN	DB		20					; Максимальная длина имени
ACTLEN	DB		?               	; Число введенных символов
NAMEFLD	DB		20 DUP (' ')		; Введенное имя
COL		DB		00
COUNT	DB		?
PROMPT	DB		'Name? '
ROW		DB		00
DATASG	ENDS						;
;-------------------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:DATASG
        PUSH    DS
		SUB     AX,AX
        PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		MOV		ES,AX
		MOV		AX,0600H
		CALL	Q10CLR		; Очистить экран
A20LOOP:
		MOV		COL,00		; Установить столбец 0
		CALL	Q20CURS
		CALL	B10PRMP		; Выдать текст зарпоса
		CALL	D10INPT		; Ввести с клавиатуры
		CMP		ACTLEN,00	; Нет имени?
		JNE		A30			;  если да,
		MOV		AX,0600H	;  то очистить экран
		CALL	Q10CLR		;  и завершить программу
		RET
A30:	
		CALL	E10NAME
		JMP		A20LOOP
		RET
BEGIN   ENDP
;-------------------------------------------------------
;		Вывод текста запроса:
B10PRMP	PROC	NEAR
		LEA		SI,PROMPT	; Адрес текста
		MOV		COUNT,05
B20:
		MOV		BL,70H		; Видеоинверсия
		CALL	F10DISP		; Подпрограмма вывода
		INC		SI			; Следующий символов
		INC		COL			; Следующий столбец
		CALL	Q20CURS
		DEC		COUNT		; Уменьшение счетчика
		JNZ		B20			; Повторить n раз
		RET
B10PRMP	ENDP
;-------------------------------------------------------
;		Очистка экрана:
D10INPT	PROC	NEAR
		MOV		AH,0AH		; запрос функции ввода
		LEA		DX,NAMEPAR	; загрузка адреса списка параметра
		INT		21H			; вызов DOS
		RET
D10INPT	ENDP
;-------------------------------------------------------
;		Вывод с миганием и инверсией:
E10NAME	PROC	NEAR
		LEA		SI,NAMEFLD	; Адрес имени
		MOV		COL,40		; Установить столбец
E20:
		CALL	Q20CURS		; Установить курсор
		MOV		BL,0F0H		; Мигание и инверсия
		CALL	F10DISP     ; Подпрограмма вывода
		INC		SI          ; Следующий символ
		INC		COL         ; Следующий столбец
		DEC		ACTLEN      ; Уменьшить счетчик
		JNZ		E20         ; Циклить n раз
		CMP		ROW,20      ; Последняя строка?
		JAE		E30         ;  нет
		INC		ROW         ; 
		RET                 ; 
E30:	MOV		AX,0601H    ;  да --
		CALL	Q10CLR      ;  очистить экран
		RET
E10NAME	ENDP
;-------------------------------------------------------
;		Очистка экрана:
F10DISP	PROC	NEAR
		MOV		AH,09		; Функция вывода
		MOV		AL,[SI]		; Выводимый символ
		MOV		BH,00		; Номер страницы
		MOV		CX,01		; Повторения
		INT		10H			; Передача управлени¤ в BIOS
F10DISP	ENDP
;-------------------------------------------------------
;		Очистка экрана:
Q10CLR	PROC	NEAR
		MOV		BH,07		; нормальный атрибут (черно-белый)
		MOV		CX,0000		; верхняя левая позиция (строка, столбец)
		MOV		DX,184FH	; нижняя правая позиция (строка, столбец)
		INT		10H			; передача управления в BIOS
		RET
Q10CLR	ENDP
;-------------------------------------------------------
;		Установить курсор:
Q20CURS	PROC	NEAR
		MOV		AH,02		; запрос на установку курсора
		MOV		BH,00		; экран 0 (страница)
		MOV		DH,ROW		; строка
		MOV		DL,COL		; столбец
		INT		10H			; передача управления в BIOS
		RET
Q20CURS	ENDP
;-------------------------------------------------------
CODESG  ENDS
		END BEGIN