TITLE	TABSRCH2 (COM) Табличный поиск с CMPSB
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:CODESG
		ORG		100H
BEGIN:	JMP		SHORT MAIN
;-----------------------------------------------------------
STOKNIN	DB	'123'
STOKTAB	DB	'035','Excavators'	; Начало таблицы
		DB	'038','Lifters   '
		DB	'049','Presses   '
		DB	'102','Valves    '
		DB	'123','Processors'
		DB	'127','Pumps     '
		DB	'999',10 DUP(' ')	; Конец таблицы
DESCRN	DB	10 DUP(?)
;-----------------------------------------------------------
MAIN	PROC	NEAR
		CLD
		LEA		SI,STOKTAB
A20:
		MOV		CX,03
		LEA		DI,STOKNIN
		REPE CMPSB
		JE		A30
		JA		A40
		ADD		SI,CX
		ADD		SI,10
		JMP		A20
A30:	
		MOV		CX,05
		LEA		DI,DESCRN
		REP MOVSW
		RET
A40:	
		CALL	R10ERR
		RET
MAIN	ENDP
;				Вывод ошибки:
;				--------------------------------------------
R10ERR	PROC	NEAR
		MOV		AX,'EE'
		LEA		DI,DESCRN
		MOV		CX,5
		CLD
		REP STOSW
		RET
R10ERR	ENDP
CODESG	ENDS
		END		BEGIN