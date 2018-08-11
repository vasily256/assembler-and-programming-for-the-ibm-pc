		page 60,132
TITLE	CASE (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
;--------------------------------------------
TITLEX	DB		'{CHANGE to UPPERcase LETTERs}'
;--------------------------------------------
MAIN	PROC	NEAR
		LEA		BX,TITLEX
		MOV		CX,31
B20:	
		MOV		AH,[BX]
		CMP		AH,61H
		JAE		B30
		CMP		AH,41H
		JBE		B30
		XOR		AH,00100000B
		MOV		[BX],AH
B30:
		INC		BX
		LOOP	B20
		RET
MAIN	ENDP
CODESG	ENDS
		END		BEGIN