		page	60,132
		TITLE	ASCADD (EXE) Деление ASCII-чисел
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
DIVDND	DB		'3698'
DIVSOR	DB		'4'
QUOTNT	DB		4 DUP(0)
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

		MOV		CX,04
		SUB		AH,AH
		AND		DIVSOR,0FH
		LEA		SI,DIVDND
		LEA		DI,QUOTNT
A20:
		MOV		AL,[SI]
		AND		AL,0FH
		AAD
		DIV		DIVSOR
		MOV		[DI],AL
		INC		SI
		INC		DI
		LOOP	A20
		RET
BEGIN	ENDP
CODESG  ENDS
		END BEGIN