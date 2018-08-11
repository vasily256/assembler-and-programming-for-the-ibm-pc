		PAGE	60,132
		TITLE EX45(EXE) Homework 4.5
;---------------------------------------------------
SSTACK	SEGMENT PARA STACK 'Stack'
		DW		32 DUP(?)
SSTACK	ENDS
;---------------------------------------------------
SCODE	SEGMENT	PARA 'Code'
BEGIN	PROC	FAR
		ASSUME	SS:SSTACK,CS:SCODE
		
		PUSH	DS
		SUB		AX,AX
		PUSH	AX
		
		MOV		AL,30H
		SHL		AL,1
		MOV		BL,18H
		MUL		BL
		RET
BEGIN	ENDP
SCODE	ENDS
		END		BEGIN