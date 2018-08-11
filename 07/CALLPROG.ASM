		page	60,132
		TITLE	CALLPROG (EXE)
;-------------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
        DW		32 DUP(?)
STACKSG ENDS
;-------------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
        ASSUME  CS:CODESG,SS:STACKSG
        PUSH    DS
        SUB     AX,AX
        PUSH    AX
		CALL	B10
;		...
        RET
BEGIN   ENDP
;-------------------------------------------------
B10		PROC
		CALL	C10
;		...
        RET
B10		ENDP
;-------------------------------------------------
C10		PROC
;		...
        RET
C10		ENDP
;-------------------------------------------------
CODESG  ENDS
        END BEGIN