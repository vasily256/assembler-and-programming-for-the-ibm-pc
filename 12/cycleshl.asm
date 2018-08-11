		page	60,132
		TITLE	CYCLESHL (EXE) сдвиг
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
CYCLE	DW		5
WORD1	DW		5678H
WORD2	DW		1234H
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
		CALL	B10SHL
		CALL	C10SHL
		RET
BEGIN	ENDP
;				1 способ (с циклом)
;				-------------------------------
B10SHL	PROC	NEAR
		MOV		CX,CYCLE
		MOV		AX,WORD1
		MOV		DX,WORD2
B10:	SHL		AX,1
		RCL		DX,1
		LOOP	B10
		RET
B10SHL	ENDP
;				2 способ (без цикла)
;				-------------------------------
;	DX		 AX		  BX
;	ABCDEFGH IJKLMNOP
;	ABCDEFGH IJKLMNOP IJKLMNOP
;	FGH00000 NOP00000 000IJKLM
;	FGHIJKLM NOP00000 000IJKLM
C10SHL	PROC	NEAR
		MOV		CL,BYTE PTR CYCLE
		MOV		AX,WORD1
		MOV		DX,WORD2
		SHL		DX,CL
		MOV		BX,AX
		SHL		AX,CL
		SUB		CL,16
		NEG		CL
		SHR		BX,CL
		OR		DX,BX
		RET
C10SHL	ENDP
CODESG  ENDS
		END BEGIN