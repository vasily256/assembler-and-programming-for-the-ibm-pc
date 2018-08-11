		page	60,132
		TITLE	ASCADD (EXE) Сложение в ASCII-формати
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
ASC1	DB		'578'
ASC2	DB		'694'
ASC3	DB		'0000'
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
		CLC
		LEA		SI,ASC1+2
		LEA		DI,ASC2+2
		LEA		BX,ASC3+3
		MOV		CX,03
A20:
		MOV		AH,00
		MOV		AL,[SI]
		ADC		AL,[DI]
		AAA
		MOV		[BX],AL
		DEC		SI
		DEC		DI
		DEC		BX
		LOOP	A20
		MOV		[BX],AH
		RET
BEGIN	ENDP
CODESG  ENDS
		END BEGIN