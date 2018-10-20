		page	60,132
		TITLE	EX711 (EXE)
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
'----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
		NAME1	DB		'ABCDEFGHI'
		NAME2	DB		'JKLMNOPQR'
		NAME3	DB		'STUVWXYZ*'
DATASG	ENDS
'----------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:DATASG
        PUSH    DS
		SUB     AX,AX
        PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		MOV		ES,AX
		CALL	B10MOVE
		CALL	C10MOVE
		RET
BEGIN   ENDP
;----------------------------------------------
B10MOVE	PROC
		LEA		SI,NAME1
		LEA		DI,NAME2
		MOV		CX,09
B20:
		MOV		AL,[SI]
		MOV		[DI],AL
		INC		SI
		INC		DI
		DEC		CX
		JNZ		B20
        RET
B10MOVE	ENDP
;----------------------------------------------
C10MOVE	PROC
		LEA		SI,NAME2
		LEA		DI,NAME3
		MOV		CX,09
C20:
		MOV		AL,[SI]
		MOV		[DI],AL
		INC		DI
		INC		SI
		LOOP	C20
        RET
C10MOVE	ENDP
;----------------------------------------------
CODESG  ENDS
		END BEGIN