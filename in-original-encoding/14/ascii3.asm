TITLE	ASCII (COM) Перевод ASCII в шест.
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
;-----------------------------------------------------------
DISPROW	DB	3 DUP(' ')		; Выводимый шест. номер.
HEXSTR	DB	00, 0B3H		; Выводимый ASCII-симв.
XLATAB	DB	30H,31H,32H,33H,34H
		DB	35H,36H,37H,38H,39H
		DB	41H,42H,43H,44H,45H,46H
BORDER	DB	0CDH
SPACE	DB	20H
HNODE	DB	0D1H
MNODE	DB	0B5H
LNODE	DB	0CFH
HCORNER	DB	0B8H
LCORNER	DB	0BEH
TNAME	DB	'ASCII Table (created by V.A. Markov)'
;-----------------------------------------------------------
MAIN	PROC	NEAR
		CALL	Q10CLR
		CALL	B10TAB
		CALL	D10BORD
		RET
MAIN	ENDP
;				Вывод таблицы:
;				--------------------------------------------
B10TAB	PROC	NEAR
		MOV		DX,0300H	; Установка строки и столбца
B20:
		MOV		SI,OFFSET DISPROW	; Выводимый текст
		CALL	C10HEX		; Перекодировать
		MOV		CX,1		; Число повторений (экран)
		MOV		DI,5		; Счетчик длины текста
B30:	CALL	P10DISP		; Вывести на экран
		INC		SI
		INC		DL			; Следующий столбец
		DEC		DI
		JNZ		B30
		CMP		HEXSTR,0FFH	; Последний символ?
		JZ		B90			;	да - выйти
		INC		HEXSTR
		INC		DH
		CMP		DH,19
		JNZ		B50
		MOV		DH,3
		JMP		B20
B50:
		SUB		DL,5
		JMP		B20	
B90:	RET
B10TAB	ENDP
;				Перекодировка:
;				--------------------------------------------
C10HEX	PROC	NEAR
		MOV		AL,HEXSTR	; Перевести в распакованный
		MOV		AH,AL		;	шестнадцатеричный формат.
		MOV		CL,4
		SHR		AL,CL
		AND		AH,0FH
		MOV		BX,OFFSET XLATAB	; Перекодировать и сохранить.
		XLAT
		MOV		[SI],AL
		MOV		AL,AH
		XLAT
		MOV		[SI+1],AL
		RET
C10HEX	ENDP
;				Прорисовка границ таблицы:
;				--------------------------------------------
D10BORD	PROC
		MOV		CX,80		; Число повторений (экран)
		SUB		DX,DX

		MOV		SI,OFFSET SPACE	; Область заголовка
		MOV		DH,1
		CALL	P10DISP

		MOV		SI,OFFSET BORDER	; Граница

		MOV		DH,19		;	- нижняя
		CALL	P10DISP

		MOV		DH,0		;	- верхняя
		CALL	P10DISP
		
		MOV		DH,2		;	- средня
		CALL	P10DISP
		
		MOV		CX,1		; Узлы средней границы
		DEC		DL
D20:	ADD		DL,5
		MOV		SI,OFFSET HNODE
		CALL	P10DISP
		CMP		DL,79
		JNZ		D20

		MOV		SI,OFFSET MNODE	; Средний правый узел
		CALL	P10DISP

		MOV		SI,OFFSET HEXSTR+1	; Правая граница заголовка
		DEC		DH
		CALL	P10DISP

		MOV		SI,OFFSET HCORNER	; Верхний правый угол
		DEC		DH
		CALL	P10DISP

		MOV		SI,OFFSET TNAME	; Заголовок
		MOV		CX,1
		MOV		DX,0116H
D30:	INC		DL
		CALL	P10DISP
		INC		SI
		CMP		DL,58
		JNZ		D30
		
		MOV		DX,13FFH	; Узлы нижней границы
D40:	ADD		DL,5
		MOV		SI,OFFSET LNODE
		CALL	P10DISP
		CMP		DL,79
		JNZ		D40
		
		MOV		SI,OFFSET LCORNER	; Нижний правый угол
		CALL	P10DISP
		
		RET
D10BORD	ENDP
;				Вывод на экран:
;				--------------------------------------------
P10DISP	PROC	NEAR
		MOV		BX,001FH	; Экран 0, атрибут 1F
		MOV		AH,02		; запрос на установку курсора
		INT		10H			; передача управления в BIOS
		MOV		AH,09H		; Запрос вывода атриб./симв.
		MOV		AL,[SI]		; Выводимый символ
		INT		10H			; передача управления в BIOS
		RET
P10DISP	ENDP
;				Очистка экрана:
;				--------------------------------------------
Q10CLR	PROC	NEAR
		MOV		AX,0600H
		MOV		BH,07
		SUB		CX,CX
		MOV		DX,184FH
		INT		10H
		RET
Q10CLR	ENDP
CODESG	ENDS
		END		BEGIN