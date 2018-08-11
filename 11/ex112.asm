		page	60,132
		TITLE	STRING (EXE) Строковые операции
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
NAME1	DB		'Assemblers'
NAME2	DB		10 DUP(' ')
NAME3	DB		10 DUP(' ')
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
		CALL	C10MVSB
		CALL	D10MVSW
		CALL	E10LODS
		CALL	F10STOS
		CALL	G10CMPS
		CALL	H10SCAS
		RET
BEGIN   ENDP
;				MOVSB:
;				-------------------------------
C10MVSB	PROC	NEAR
		STD					; Направление пересылки
		LEA		SI,NAME1+9	; Источник
		LEA		DI,NAME2+9	; Назначение
		MOV		CX,10		; Переслать 10 байтов
		REP MOVSB
        RET
C10MVSB	ENDP
;				MOVSW:
;				-------------------------------
D10MVSW	PROC	NEAR
		STD					; Направление пересылки
		LEA		SI,NAME2+8	; Источник
		LEA		DI,NAME3+8	; Назначение
		MOV		CX,05		; Переслать 10 байтов
		REP MOVSW
        RET
D10MVSW	ENDP
;				LODSW:
;				-------------------------------
E10LODS	PROC	NEAR
		CLD					; Направление пересылки
		LEA		SI,NAME1	; Источник
		LODSW				; Загрузить 1-е слово в AX
        RET
E10LODS	ENDP
;				STOSW:
;				-------------------------------
F10STOS	PROC	NEAR
		CLD					; Направление пересылки
		LEA		DI,NAME3	; Назначение
		MOV		CX,05
		MOV		AX,2020H	; Переслать пробелы
		REP STOSW
        RET
F10STOS	ENDP
;				CMPSB:
;				-------------------------------
G10CMPS	PROC	NEAR
		CLD					; Направление
		MOV		CX,10
		LEA		SI,NAME1	; Источник
		LEA		DI,NAME2	; Назначение
		REPE CMPSB			; Сравнение [SI] и [DI]
		JNE		G20			; Не равны?
		MOV		BH,01
G20:	MOV		CX,10
		LEA		SI,NAME2	; Источник
		LEA		DI,NAME3	; Назначение
		REPE CMPSB			; Сравнение [SI] и [DI]
		JE		G30			; Не равны?
        MOV		BL,02
G30:	RET
G10CMPS	ENDP
;				SCASB:
;				-------------------------------
H10SCAS	PROC	NEAR
		CLD					; Направление
		MOV		CX,5
		LEA		DI,NAME1	; Назначение
		MOV		AX,'bm'		; Поиск символа по [DI]
		REPNE SCASW			; Сравнение [SI] и [DI]
		JNE		H20			; Не равны?
		MOV		BH,03
H20:	RET
H10SCAS	ENDP
CODESG  ENDS
		END BEGIN