		page	60,132
		TITLE	EXRING (EXE) Выравнивание справа
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
NAMEPAR	LABEL	BYTE
MAXNLEN	DB		31
ACTNLEN	DB		?
NAMEFLD	DB		31 DUP(' ')
PROMPT	DB		'Name? ','$'
NAMEDSP	DB		31 DUP(' '),13,10,'$'
ROW		DB		00
DATASG	ENDS
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
		MOV		AX,0600H
		CALL	Q10SCR		; Очистить экран
		SUB		DX,DX		; Установить курсор в 0
		CALL	Q20CURS
A10LOOP:
		CALL	B10PRMT		; Ввести имя
		CALL	C10INPT		; Ввод
		TEST	ACTNLEN,0FFH; Нет имени?
		JZ		A90			;  Да - выйти
		CALL	D10SCAS		; Найти звездочку
		CMP		AL,'*'		; Найдена?
		JE		A10LOOP		;  Да - обойти
		CALL	E10RGHT		; Выровнить имя справа
		CALL	F10CLNM
		JMP		A10LOOP
A90:	RET
BEGIN   ENDP
;				Вывод сообщения на экран:
;				-------------------------------
B10PRMT	PROC	NEAR
		MOV		AH,09		;запрос вывода на экран
		LEA		DX,PROMPT	;адрес выводимого на экран сообщения
		INT		21H			;вызов DOS
		RET
B10PRMT	ENDP
;				Ввод с клавиатуры:
;				-------------------------------
C10INPT	PROC	NEAR
		MOV		AH,0AH		;запрос функции ввода
		LEA		DX,NAMEPAR	;загрузка адреса списка параметра
		INT		21H			;вызов DOS
		RET
C10INPT	ENDP
;				Поиск '*':
;				-------------------------------
D10SCAS	PROC	NEAR
		CLD					; Направление
		MOV		CX,30
		LEA		DI,NAMEFLD	; Назначение
		MOV		AL,'*'		; Поиск символа по [DI]
		REPNE SCASB			; Найден?
		JE		D20			;  Да - выйти,
		MOV		AL,20H		;  нет - стереть * в AL
D20:	RET
D10SCAS	ENDP
;				MOVSB:
;				-------------------------------
E10RGHT	PROC	NEAR
		STD					; Направление пересылки
		SUB		CH,CH
		MOV		CL,ACTNLEN	; Длина CX для REP
		LEA		SI,NAMEFLD	; Правая позиция
		ADD		SI,CX
		DEC		SI
		LEA		DI,NAMEDSP+30
		REP MOVSB			; Переслать справа налево
		MOV		DH,ROW
		MOV		DL,48
		CALL	Q20CURS
		MOV		AH,09
		LEA		DX,NAMEDSP	; Выдать пересланный текст
		INT		21H
		CMP		ROW,20		; Последняя строка
		JAE		E20			;  Нет -
		INC		ROW			;  увеличить номер строки
		JMP		E90
E20:
		MOV		AX,0601H
		CALL	Q10SCR
		MOV		DH,ROW
		MOV		DL,00
		CALL	Q20CURS
E90:	RET
E10RGHT	ENDP
;				Очситка области имени:
;				-------------------------------
F10CLNM	PROC	NEAR
		CLD					; Направление пересылки
		LEA		DI,NAMEDSP	; Назначение
		MOV		CX,15
		MOV		AX,2020H	; Переслать пробелы
		REP STOSW
        RET
F10CLNM	ENDP
;				Очситка экрана:
;				-------------------------------
Q10SCR	PROC	NEAR
		MOV		BH,07		;нормальный атрибут (черно-белый)
		MOV		CX,0000		;верхняя левая позиция (строка, столбец)
		MOV		DX,184FH	;нижняя правая позиция (строка, столбец)
		INT		10H			;передача управления в BIOS
        RET
Q10SCR	ENDP
;				Установка курсора:
;				-------------------------------
Q20CURS	PROC	NEAR
		MOV		AH,02	; запрос на установку курсора
		MOV		BH,00	; экран 0 (страница)
		INT		10H		; передача управления в BIOS
		RET
Q20CURS	ENDP
CODESG  ENDS
		END BEGIN