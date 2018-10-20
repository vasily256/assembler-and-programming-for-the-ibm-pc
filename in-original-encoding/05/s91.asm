      page      60,132
TITLE S91 (EXE) Operacii peresylki i slozhenija 
;-------------------------------------------------
STACKSG SEGMENT PARA STACK 'Stack'
        DW      32 DUP(?)
STACKSG ENDS
;-------------------------------------------------
DATASG  SEGMENT PARA 'Data'
FLDA    DW      1111H
FLDB	DW		1111H
DATASG  ENDS
;-------------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
        ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:NOTHING
        PUSH    DS
        SUB     AX,AX
        PUSH    AX
        MOV     AX,DATASG
        MOV     DS,AX
;------------------------------
		ADD		FLDA,1111H
        RET
BEGIN   ENDP
CODESG  ENDS
        END BEGIN