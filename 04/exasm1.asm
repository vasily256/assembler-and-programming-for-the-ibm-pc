		PAGE    60,132
TITLE   EXASM1  (EXE) Sample of registry operations
;--------------------------------------------------
STACKSG SEGMENT PARA STACK 'Stack'
		DB              12 DUP('STACKSEG')
STACKSG ENDS
;--------------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  SS:STACKSG,CS:CODESG,DS:NOTHING
		PUSH    DS
		SUB             AX,AX
		PUSH    AX
		
		MOV             AX,0123H
		ADD             AX,0025H
		MOV             BX,AX
		ADD             BX,AX
		MOV             CX,BX
		SUB             CX,AX
		SUB             AX,AX
		NOP
		RET
BEGIN   ENDP

CODESG  ENDS
		END             BEGIN
