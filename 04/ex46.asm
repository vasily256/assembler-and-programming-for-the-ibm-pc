		PAGE	60,132
		TITLE EX46(EXE) Homework 4.6
;---------------------------------------------------
SSTACK	SEGMENT PARA STACK 'Stack'
		DW		32 DUP(?)
SSTACK	ENDS
;---------------------------------------------------
SDATA	SEGMENT	PARA 'Data'
FLDA	DB		28H
FLDB	DB		14H
FLDC	DW		?
SDATA	ENDS
;---------------------------------------------------
SCODE	SEGMENT	PARA 'Code'
BEGIN	PROC	FAR
		ASSUME	SS:SSTACK,CS:SCODE,DS:SDATA
		
		PUSH	DS
		SUB		AX,AX
		PUSH	AX
		MOV		AX,SDATA
		MOV		DS,AX
		
		MOV		AL,FLDA
		SHL		AL,1
		MOV		BL,FLDB
		MUL		BL
		MOV		FLDC,AX
		RET
BEGIN	ENDP
SCODE	ENDS
		END		BEGIN