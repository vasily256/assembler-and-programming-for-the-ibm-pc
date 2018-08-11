		page	60,132
		TITLE	EX113 (EXE) Строковые операции
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
CONAME	DB		'SPACE EXPLORERS INC.'
PRLINE	DB		20 DUP(' ')
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
		CALL	A10MVSR			; а) Пересылка слева направо
		CALL	G10CLN
		CALL	B10MVSL			; б) Пересылка справа налево
		CALL	C10LODS			; в) Загрузка 3 и 4 байтов в AX
		CALL	D10STOS			; г) Сохранение содержимого AX в памяти
		CALL	E10CMPS			; д) Сравнение CONAME и PRLINE
		CALL	F10SCAS			; e) Поиск символа
		RET
BEGIN   ENDP
;				а) Пересылка данных слева направо:
;				-------------------------------
A10MVSR	PROC	NEAR
		CLD						; Направление пересылки
		LEA		SI,CONAME		; Источник
		LEA		DI,PRLINE		; Назначение
		MOV		CX,10			; Переслать 10 байтов
		REP MOVSW
        RET
A10MVSR	ENDP
;				б) Пересылка данных справа налево:
;				-------------------------------
B10MVSL	PROC	NEAR
		STD						; Направление пересылки
		LEA		SI,CONAME+18	; Источник
		LEA		DI,PRLINE+18	; Назначение
		MOV		CX,10			; Переслать 10 байтов
		REP MOVSW
        RET
B10MVSL	ENDP
;				в) Загрузка в AX:
;				-------------------------------
C10LODS	PROC	NEAR
		CLD						; Направление пересылки
		LEA		SI,CONAME+2		; Источник (3 и 4 байты)
		LODSW					; Загрузить слово в AX
        RET
C10LODS	ENDP
;				г) Сохранение содержимого AX в памяти:
;				-------------------------------
D10STOS	PROC	NEAR
		CLD					; Направление пересылки
		LEA		DI,PRLINE+5	; Назначение
		STOSW				; AX уже загружен необходимыми
		RET					;  данными
D10STOS	ENDP
;				д) Сравнение CONAME и PRLINE на несовпадение:
;				-------------------------------
E10CMPS	PROC	NEAR
		CLD					; Направление
		MOV		CX,20
		LEA		SI,CONAME	; Источник
		LEA		DI,PRLINE	; Назначение
		REPE CMPSB			; Сравнение [SI] и [DI]
		RET
E10CMPS	ENDP
;				e) Поиск символа:
;				-------------------------------
F10SCAS	PROC	NEAR
		CLD					; Направление
		MOV		CX,20
		LEA		DI,CONAME	; Назначение
		MOV		AL,20H		; Поиск символа по [DI]
		REPNE SCASB			; Сравнение AX и [DI]
		JNE		H20			; Не равны?
		MOV		BH,AL
H20:	RET
F10SCAS	ENDP
;				Очистка:
;				-------------------------------
G10CLN	PROC	NEAR
		CLD						; Направление пересылки
		LEA		DI,PRLINE		; Назначение
		MOV		CX,10
		MOV		AX,2020H		; Переслать пробелы
		REP STOSW
        RET
G10CLN	ENDP
CODESG  ENDS
		END BEGIN