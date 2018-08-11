		page	60,132
		TITLE	STRING (EXE) Строковые операции
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
NAME1	DB		'Assemblers'
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
		CALL	A10SCAS		; а) способ 1
		CALL	B10SCAS		; б) способ 2
		RET
BEGIN	ENDP
;				а) способ 1:
;				-------------------------------
A10SCAS	PROC	NEAR
		CLD					; Направление
		MOV		CX,5
		LEA		DI,NAME1	; Назначение
		MOV		AX,'re'		; Поиск слова по [DI]
		REPNE SCASW			; Сравнение AX и [DI]
		MOV		CX,4
		LEA		DI,NAME1+1	; Назначение
		REPNE SCASW			; Сравнение AX и [DI]
		RET
A10SCAS	ENDP
;				б) способ 2:
;				-------------------------------
B10SCAS	PROC	NEAR
		CLD					; Направление
		MOV		CX,10
		LEA		DI,NAME1	; Назначение
B20:	MOV		AL,'e'		; Поиск слова по [DI]
		REPNE SCASB			; Сравнение AL и [DI]
		MOV		AL,'r'
		SCASB				; Сравнение AL и [DI]
		JNZ		B20
		RET
B10SCAS	ENDP
CODESG  ENDS
		END BEGIN