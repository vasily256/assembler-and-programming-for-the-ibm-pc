TITLE	MEM (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
MEMBIN	DW		2 DUP(?)
MESSG1	DB		'Memory size: '
MEMASC	DB		8 DUP(20H)
MESSG2	DB		' bytes'
;				Главная процедура:
;				--------------------------------------------
MAIN	PROC	NEAR
		CALL	B10MEM
		CALL	C10ASC
		CALL	D10DISP
		RET
MAIN	ENDP
;				Расчет объема памяти в байтах (двоичный):
;				--------------------------------------------
B10MEM	PROC	NEAR
		INT		12H			; Размер памяти (кБ) в AX
		MOV		DX,AX
		MOV		CL,10
		SHL		AX,CL
		SUB		CL,16
		NEG		CL
		SHR		DX,CL		; Размер памяти (Б) в DX:AX
		MOV		MEMBIN,AX	; Сохранение результата
		MOV		MEMBIN+2,DX
		RET
B10MEM	ENDP
;				Перевод в ASCII-формат [1]:
;				--------------------------------------------
C10ASC	PROC	NEAR
		LEA		DI,MEMASC
		MOV		CX,1
		MOV		BX,10
		CMP		DX,BX		; Достаточно ли мало делимое?
		JB		C50			; Если мало, то переход.

				;Увеличение делителя:
		INC		CX
		MOV		AX,BX
C40:	MUL		BX
		CMP		MEMBIN+2,AX
		JAE		C40
		MOV		BX,AX		; сохранение делителя

				;Предварительное деление
		MOV		AX,MEMBIN
		MOV		DX,MEMBIN+2
		DIV		BX
		MOV		SI,AX		; сохранение частного
		MOV		AX,DX		; остаток - в делимое
		SUB		DX,DX
		MOV		BX,10

				;Запись цифр в ASCII-формат:
C50:	DIV		BX
		OR		DL,30H
		MOV		[DI+7],DL
		SUB		DL,DL
		DEC		DI
		CMP		AX,0
		JNE		C50
		MOV		AX,SI
		LOOP	C50
		
		RET
C10ASC	ENDP
;				Вывод информации:
;				--------------------------------------------
D10DISP	PROC	NEAR
				
				;Запись текущего положения курсора в DX:		
		MOV		AH,03
		MOV		BH,00
		INT		10H

		MOV		CX,01		; Число повторений (экран)
		LEA		SI,MESSG1
		MOV		BL,27		; Счетчик
		
D20:	MOV		AH,02		; запрос на установку курсора
		INT		10H			; передача управления в BIOS
		MOV		AH,0AH		; Запрос вывода символа
		MOV		AL,[SI]		; Выводимый символ
		INT		10H			; передача управления в BIOS
		INC		SI
		INC		DL			; Следующий столбец

D30:	DEC		BL
		JNZ		D20

		SUB		DL,DL
		INC		DH
		MOV		AH,02		; запрос на установку курсора
		INT		10H			; передача управления в BIOS
		RET
D10DISP	ENDP
CODESG	ENDS
		END		BEGIN
;[1]	12 345/10 = 1 234 ост. 5
;		12 345/100 = 123 ост. 45