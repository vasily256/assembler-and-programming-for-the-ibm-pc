		page	60,132
		TITLE	EX115A (EXE) Строковые операции (Способ Б)
;											более эффективный
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
NAME1	DB		03H,04H,05H,0B4H
NAME2	DB		80 DUP(' ')
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
		CALL	B10MOVE		; Пересылка
		CALL	C10SCR		; Очистка экрана
		CALL	D10DISP
		RET
BEGIN	ENDP
;				Пересылка с дублированием (способ Б):
;				-------------------------------
B10MOVE	PROC	NEAR
		CLD
		LEA		SI,NAME1
		LEA		DI,NAME2
		MOV		CX,40
		REP MOVSW
		RET
B10MOVE	ENDP
;				Очистка экрана:
;				-------------------------------
C10SCR	PROC	NEAR
		MOV		AX,0600H	;06 - прокрутка вверх 00 - весь экран
		MOV		BH,07		;нормальный атрибут (черно-белый)
		SUB		CX,CX		;верхняя левая позиция (строка, столбец)
		MOV		DX,184FH	;нижняя правая позиция (строка, столбец)
		INT		10H			;передача управления в BIOS
		RET
C10SCR	ENDP
;				Вывод информации:
;				-------------------------------
D10DISP	PROC	NEAR
		SUB		DX,DX		; Строка и столбец (курсор)
		MOV		BH,00		; Экран 0 (курсор, экран)
		MOV		CX,01		; Число повторений (экран)
		LEA		SI,NAME2
		MOV		BL,80		; Счетчик
		
D20:	MOV		AH,02		; запрос на установку курсора
		INT		10H			; передача управления в BIOS
		MOV		AH,0AH		; Запрос вывода символа
		MOV		AL,[SI]		; Выводимый символ
		INT		10H			; передача управления в BIOS
		INC		SI
		INC		DL			; Следующий столбец
		CMP		DL,20
		JNZ		D30
		SUB		DL,DL
		INC		DH

D30:	DEC		BL
		JNZ		D20
		RET
D10DISP	ENDP
CODESG  ENDS
		END BEGIN