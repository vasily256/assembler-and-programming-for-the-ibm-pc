		page	60,132
		TITLE	EX711 (EXE)
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
'----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
		X		DW		07FFH
		Y		DD		?
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
		CALL	CALC
		RET
BEGIN   ENDP
;----------------------------------------------
CALC	PROC
		

        RET
CALC	ENDP
;----------------------------------------------
CODESG  ENDS
		END BEGIN