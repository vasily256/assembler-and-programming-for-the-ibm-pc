TITLE	TABSRCH (COM) Табличный поиск
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:CODESG
		ORG		100H
BEGIN:	JMP		SHORT MAIN
;				Данные:
;				--------------------------------------------
STOKNIN	DW		'08'
STOKIND	DB		'05', '23', '09', '12', '08', '27'
STOCNAM	DB		'Excavators', 'Processors', 'Presses   ',	
				'Valves    ', 'Lifters   ', 'Pumps     '	
DESCRN	DB		10 DUP(?)
;				Главная процедура:
;				--------------------------------------------
MAIN	PROC	NEAR

		MOV		AX,STOKNIN		; Поиск совпадения:
		XCHG	AL,AH
		LEA		DI,STOKIND+10
		MOV		CX,6
		STD
		REPNE SCASW
		DEC		CX				; Если нет совпадений,
		JNS		A20
		CALL	R10ERR			;	то ошибка.
		RET
A20:
		INC		CX
		LEA		DI,DESCRN
		LEA		SI,STOCNAM
		MOV		AX,10
		MUL		CX
		ADD		SI,AX
		MOV		CX,5
		CLD
		REP MOVSW
		RET
MAIN	ENDP
;				Вывод ошибки:
;				--------------------------------------------
R10ERR	PROC	NEAR
		MOV		AX,'RE'
		LEA		DI,DESCRN
		MOV		CX,5
		CLD
		REP STOSW
		RET
R10ERR	ENDP
CODESG	ENDS
		END		BEGIN