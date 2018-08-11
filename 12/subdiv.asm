TITLE	MEM (COM)
CODESG	SEGMENT PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG,ES:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
WORD1	DW		
WORD2	DW		
WORD3	DW
;				Главная процедура -  деление вычитанием:
;				-------------------------------
MAIN	PROC	NEAR

		RET
MAIN	ENDP
CODESG	ENDS
		END		BEGIN