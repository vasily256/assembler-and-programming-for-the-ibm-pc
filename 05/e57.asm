		PAGE    60,132
TITLE   E57  (EXE) Sample of registry operations
;--------------------------------------------------
STACKSG SEGMENT PARA STACK 'Stack'
		DW              32 DUP(?)
STACKSG ENDS
;--------------------------------------------------
DATASG	SEGMENT	PARA 'Data'
TITLE1	DB	'RGB Electronics'
FLDA	DD	73H
FLDB	DB	19H
FLDC	DW	?
FLDD	DB	00011001B
FLDE	DW	'16','19','20','27','30'
DATASG	ENDS
;--------------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  SS:STACKSG,DS:DATASG,CS:CODESG,ES:NOTHING
		PUSH    DS
		SUB     AX,AX
		PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		
		MOV	AX,320
		CMP	FLDB,0
		ADD	BX,40H
		SUB	CX,40H
		SAL	FLDB,1
		SHR	CH,1

		RET
BEGIN   ENDP
CODESG  ENDS
		END             BEGIN
