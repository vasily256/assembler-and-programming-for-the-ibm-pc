		TITLE	SCREMP (EXE) Ввод времени и расценки,
;								вывод величины оплаты
;-----------------------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;-----------------------------------------------------------
DATASG	SEGMENT	PARA 'Data'
HRSPAR	LABEL	BYTE			; Список параметров
MAXHLEN	DB		6				;	для ввода времени
ACTHLEN	DB		?				;---------------------------
HRSFLD	DB		6 DUP(?)

RATEPAR	LABEL	BYTE			; Список параметров
MAXRLEN	DB		6				;	для ввода расценки
ACTRLEN	DB		?				;---------------------------
RATEFLD	DB		6 DUP(?)

MESSG1	DB		'Hours worked? ','$'
MESSG2	DB		'Rate of pay? ','$'
MESSG3	DB		'Wage = '
ASCWAGE	DB		10 DUP(30H), 13, 10, '$'
ADJUST	DW		?				; Слаг. округлен. 5*10^(P-3)
ASCHRS	DB		0
ASCRATE	DB		0
BINVAL	DW		00
BINHRS	DW		00
BINRATE	DW		00
COL		DB		00
DECIND	DB		00				; Порядок дробности	P
MULT10	DW		01				; Множитель порядка
NODEC	DW		00				; Количество зн. после ','
ROW		DB		00
SHIFT	DW		?				; Порядок округл. 10^(P-2)
TENWD	DW		10
DATASG	ENDS
;-----------------------------------------------------------
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
		CALL	Q10SCR			; Очистить экран
		CALL	Q20CURS			; Установить курсор
A20LOOP:
		CALL	B10INPT			; Ввести время и расценку
		CMP		ACTHLEN,00
		JE		A30
		CALL	D10HOUR			; Получить двоичное время
		CALL	E10RATE			; Получить дв. расценку
		CALL	F10MULT			; Рассчитать оплату
		CALL	G10WAGE			; Преобразовать в ASCII
		CALL	K10DISP			; Выдать результат
		JMP		A20LOOP
A30:	
		MOV		AX,0600H
		CALL	Q10SCR			; Очистить экран
		RET						; Выйти из программы
BEGIN	ENDP
;				Ввод времени и расценки:
;				--------------------------------------------
B10INPT	PROC	NEAR
		LEA		DX,MESSG1		; Запрос ввода времени
		MOV		AH,09
		INT		21H
		LEA		DX,HRSPAR		; Ввести время
		MOV		AH,0AH
		INT		21H
		CMP		ACTHLEN,00
		JNE		B20
		RET
B20:
		MOV		COL,25			; Установить столбец
		CALL	Q20CURS
		LEA		DX,MESSG2		; Запрос ввода расценки
		MOV		AH,09
		INT		21H
		LEA		DX,RATEPAR		; Ввести расценку
		MOV		AH,0AH
		INT		21H
		RET
B10INPT	ENDP
;				Обработка времени:
;				--------------------------------------------
D10HOUR	PROC	NEAR
		MOV		NODEC,00
		MOV		CL,ACTHLEN
		SUB		CH,CH
		LEA		SI,HRSFLD-1		; Установить правую позицию
		ADD		SI,CX			;	времени
		CALL	M10ASBI			; Преобразовать в двоичное
		MOV		AX,BINVAL
		MOV		BINHRS,AX
		RET
D10HOUR	ENDP
;				Обработка расценки [1]:
;				--------------------------------------------
E10RATE	PROC	NEAR
		MOV		CL,ACTRLEN
		SUB		CH,CH
		LEA		SI,RATEFLD-1	; Установить правую позицию
		ADD		SI,CX			;	расценки
		CALL	M10ASBI			; Преобразовать в двоичное
		MOV		AX,BINVAL
		MOV		BINRATE,AX
		RET
E10RATE	ENDP
;				Умножение, округление и сдвиг:
;				--------------------------------------------
F10MULT	PROC	NEAR
		MOV		CX,05
		LEA		DI,ASCWAGE	; Установить формат оплаты
		MOV		AX,3030H	;	в код ASCII (30H)
		CLD					;	направление - слева на право
		REP STOSW

		MOV		SHIFT,10
		MOV		ADJUST,00
		MOV		CX,NODEC	; Загр. кол-во зн. после запят.
		CMP		CL,06		; Если зн. более 6 дес.,
		JA		F40			;	то ошибка
		DEC		CX			; Получить кол-во отбрасываемых
		DEC		CX			;	знаков после запятой
		JLE		F30			; Обойти при <= 2 знака
		MOV		NODEC,02	; Устан. новое кол-во дроб. зн.
		MOV		AX,01		; Вычислить и сохранить
F20:	MUL		TENWD		;	порядок округления
		LOOP	F20
		MOV		SHIFT,AX
		SHR		AX,1		; Вычислить и сохранить
		MOV		ADJUST,AX	;	слагаемое округления
F30:
		MOV		AX,BINHRS
		MUL		BINRATE		; Вычислить оплату
		ADD		AX,ADJUST	; Прибавить слаг. округл.
		ADC		DX,00
		CMP		DX,SHIFT	; Результат не слишком велик
		JB		F50			;	для команды DIV?
F40:	
		SUB		AX,AX
		JMP		F70
F50:	
		CMP		ADJUST,00	; Округление не требуется?
		JZ		F80
		DIV		SHIFT		; Округлить оплату
F70:	SUB		DX,DX		; Очистить остаток, резул. в AX
F80:	RET
F10MULT	ENDP
;				Преобразование в ASCII-формат:
;				--------------------------------------------
G10WAGE	PROC	NEAR
		LEA		SI,ASCWAGE+7		; Устан. дес. запят.
		MOV		BYTE PTR[SI],','
		ADD		SI,NODEC			; Устан. прав. позиц.
G30:	
		CMP		BYTE PTR[SI],','
		JNE		G35					; Обойти, если не ','
		DEC		SI
G35:	
		CMP		DX,00				; Если DX:AX < 10,
		JNZ		G40					;	то достигнут
		CMP		AX,0010				;	самый старший
		JB		G50					;	разряд
G40:	
		DIV		TENWD				; Остаток в DX - цифра
		OR		DL,30H
		MOV		[SI],DL				; Записать ASCII-символ
		DEC		SI
		SUB		DX,DX				; Стереть остаток
		JMP		G30
G50:	
		OR		AL,30H				; Записать послед.
		MOV		[SI],AL				;	ASCII-символ
		RET
G10WAGE	ENDP
;				Вывод величины оплаты:
;				--------------------------------------------
K10DISP	PROC	NEAR
		MOV		COL,50				; Установить столбец
		CALL	Q20CURS
		MOV		CX,09
		LEA		SI,ASCWAGE
K20:
		CMP		BYTE PTR[SI],30H	; Стереть нули пробелами
		JNE		K30
		MOV		BYTE PTR[SI],20H
		INC		SI
		LOOP	K20
K30:	
		LEA		DX,MESSG3			; Вывод на экран
		MOV		AH,09
		INT		21H
		CMP		ROW,20				; Последняя строка?
		JAE		K80
		INC		ROW					; Нет - увеличить
		JMP		K90
K80:
		MOV		AX,0601H
		CALL	Q10SCR
		MOV		COL,00
		CALL	Q20CURS
K90:	RET
K10DISP	ENDP
;				Преобразование чисел из ASCII в двоичное[2]:
;				--------------------------------------------
M10ASBI	PROC	NEAR
		MOV		MULT10,0001	; Сбросить множитель порядка
		MOV		BINVAL,00	; Обнулить двоичное поле
		MOV		DECIND,00	; Обнулить показат. дробности
		SUB		BX,BX		; Обнулить счетчик зн. до ','
M20:			; Загрузка зимвола и проверка на запятую
		MOV		AL,[SI]		; Загрузить ASCII-символ
		CMP		AL,','
		JNE		M40			; Если ',' - установить
		MOV		DECIND,01	; 	показатель дробности в 1
		JMP		M90
M40:			; Перевод разряда в двоичное значение
		AND		AX,000FH	; Очистить AH и убрать 3 
		MUL		MULT10		; Умножить на порядок
		ADD		BINVAL,AX	; Сложить с дв.значением
		MOV		AX,MULT10	; Вычислить следующий
		MUL		TENWD		;	порядок *10
		MOV		MULT10,AX
		CMP		DECIND,00	; Была ли достигнута запятая?
		JNZ		M90			; Если нет, увеличить
		INC		BX			;	счетчик знаков до запятой
M90:	
		DEC		SI			; Подгот. адрес след. символа
		LOOP	M20
							; Конец цикла
		CMP		DECIND,00	; Была дес.запятая?
		JZ		M100		;	Да - сохранить значение
		ADD		NODEC,BX	;	счетчика зн. до запятой
M100:	RET
M10ASBI	ENDP
;				Прокрутка экрана:
;				--------------------------------------------
Q10SCR	PROC	NEAR
		MOV		BH,30
		SUB		CX,CX
		MOV		DX,184FH
		INT		10H
		RET
Q10SCR	ENDP
;				Установка курсора:
;				--------------------------------------------
Q20CURS	PROC	NEAR
		MOV		AH,02		; Фактор умножения
		SUB		BH,BH
		MOV		DH,ROW
		MOV		DL,COL
		INT		10H
		RET
Q20CURS	ENDP
CODESG  ENDS
		END BEGIN
; [1]	На этот раз поле NODEC не обнуляется, так как к его
;		значению будет прибавлено кол-во знаков второго
;		множителя - расценки. В конце этой процедуры
;		NODEC - кол-во знаков после зап. в произведении.
; [2]	Если очередная цифра не запятая, то в цикле
;		происходит увеличение BX на 1.