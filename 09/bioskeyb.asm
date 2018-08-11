		page 60,132
TITLE	BIOSKEYB (COM) Ввод цифр и вывод их на экран средствами BIOS
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
;---------------------------------------------
;		Данные:
CHAR	DB		20 DUP(?)
CYCLE	DW		?
TEXT	DB		'Copyright (C) V.A. Markov 2018'
DUMPDI	DW		?
;---------------------------------------------
;		Главная процедура:
MAIN	PROC	NEAR
		SUB		CX,CX
		CALL	CLEAN
		CALL	INPUT
		CMP		SI,00		; Возврат каретки - первый символ?
		JZ		EXIT		;  Если да - завершить программу
		MOV		CX,0100H
		CALL	CLEAN
		CALL	OUTPUT
EXIT:	RET	
MAIN	ENDP
;---------------------------------------------
;		Процедура ввода:
INPUT	PROC	NEAR
I05:	SUB		SI,SI		; Установка 0 столбца
		LEA		DI,CHAR		; Установка 1 символа
I10:	MOV		DX,SI		; столбец (в DL)
		MOV		DH,00		; строка
		CALL	CURSOR

I20:	CALL	READCHR
		CMP		AL,08H		; Нажата клавиша возврата (Backspace)?
		JZ		I90			;  - если да, то переход
		CMP		AL,0DH		; Веден возврат каретки?
		JZ		I80
		CMP		AL,00		; Нажата специальная клавиша?
		JNZ		I30
		CMP		AH,3BH		; Нажата клавиша F1?
		JZ		I85

I30:	CALL	DISPCHR
		INC		DI			; Следующий символ
		INC		SI			; Следующий столбец
		CMP		SI,19		; Число введенных символов достигло 20?
		JNZ		I10			; 	Если нет, повторить процедуры

I80:	RET

I85:	CALL	HELP
		JMP		I10

I90:	DEC		SI			; Введены ли ранее другие символы?
		JS		I05			;  если нет, то ввести их
		DEC		DI
		MOV		DX,SI		; Столбец (в DL)
		CALL	CURSOR
		MOV		AL,20H
		CALL	DISPCHR
		JMP		I20
		INPUT	ENDP
;---------------------------------------------
;		Вывод справки:
HELP	PROC	NEAR
		MOV		DUMPDI,DI	; Сохранить содержимое DI
		LEA		DI,TEXT
		MOV		BL,30		; Установить кол-во циклов
		MOV		DL,25		; Столбец (в DL)
		MOV		DH,12		; Центральная строка
H30:	CALL	CURSOR		; Установить курсор
		MOV		AL,[DI]		; Загрузить символ
		CALL	DISPCHR
		INC		DI			; Следующий символ
		INC		DL			; Следующая позиция (строка) курсора
		DEC		BL
		JNZ		H30
		MOV		DI,DUMPDI	; Вернуть прежнее содержимое в DI
		RET
HELP	ENDP
;---------------------------------------------
;		Процедура вывода:
OUTPUT	PROC	NEAR
		MOV		CYCLE,SI		; Установить кол-во циклов
		SUB		DI,SI		; Вернуться к первому символу
		MOV		DL,39		; Столбец (в DL)
		MOV		DH,12		; Центральная строка
		MOV		CX,SI
		SHR		CL,1
		SUB		DH,CL		; Начальная строка
O30:	CALL	CURSOR		; Установить курсор
		MOV		AL,[DI]		; Загрузить символ
		CALL	DISPCHR
		INC		DI			; Следующий символ
		INC		DH			; Следующая позиция (строка) курсора
		DEC		CYCLE
		JNZ		O30
		RET
OUTPUT	ENDP
;---------------------------------------------
;		Очистка экрана:
CLEAN	PROC	NEAR
		MOV		AX,0600H	; 06 - прокрутка вверх, 00 - весь экран (установка режима)
		MOV		BH,07		; нормальный атрибут (черно-белый)
;		MOV		CX,0000		; верхняя левая позиция (строка, столбец)
		MOV		DX,184FH	; нижняя правая позиция (строка, столбец)
		INT		10H			; передача управления в BIOS
		RET
CLEAN	ENDP
;---------------------------------------------
;		Установка курсора:
CURSOR	PROC	NEAR
		MOV		AH,02		; запрос на установку курсора
		MOV		BH,00		; экран 0 (страница)
;		MOV		DH,00		; строка уже выбрана
;		MOV		DL,00		; Столбец уже выбран
		INT		10H			; передача управления в BIOS
		RET
CURSOR	ENDP
;---------------------------------------------
;		Чтение введенного символа и помещение его в AL:
READCHR	PROC	NEAR
		MOV		AH,00		; Функция чтения символа
		INT		16H
		MOV		[DI],AL		; Помещение символа в память
		RET
READCHR	ENDP
;---------------------------------------------
;		Вывод символа на экран:
DISPCHR	PROC	NEAR
		MOV		AH,0AH		; Вывод символа
;		MOV		AL,CHAR		; Выводимый символ уже в AL
		MOV		BH,00		; Страница
		MOV		CX,01		; Число повторений
		INT		10H			; передача управления в BIOS
		RET
DISPCHR	ENDP
;---------------------------------------------
CODESG	ENDS
		END BEGIN