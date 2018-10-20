		page 60,132
TITLE	XCOM1 COM
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
;------------------------------------------------------
FLDA	DW		250
FLDB	DW		125
FLDC	DW		?
;------------------------------------------------------
MAIN	PROC	NEAR
		MOV		AX,FLDA
		ADD		AX,FLDB
		MOV		FLDC,AX
		RET
MAIN	ENDP
CODESG	ENDS
		END		BEGIN