		page 60,132
TITLE	EXLOOP COM
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H

MAIN	PROC	NEAR
		MOV		AX,01
		MOV		BX,01
		MOV		DX,01
		MOV		CX,10
A20:	
		INC		AX
		ADD		BX,AX
		SHL		DX,1
		LOOP	A20
		
		RET
MAIN	ENDP
CODESG	ENDS
		END		MAIN