      page      60,132
TITLE EXIMM (EXE)
;-------------------------------------------------
STACKSG SEGMENT PARA STACK 'Stack'
        DW      32 DUP(?)
STACKSG ENDS
;-------------------------------------------------
DATASG  SEGMENT PARA 'Data'
FLD0    DB      ?
FLD2    DW      ?
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
;--------------------------	
        MOV     BX,275
        CMP     AL,19
;--------------------------	
		ADC		AL,5
        ADD     BH,12
        SBB		AL,5
		SUB		FLD0,5
;--------------------------
		RCL		BL,1
		RCR		AH,1
		ROL		FLD2,1
		ROR		AL,1
		SAL		CX,1
		SAR		BX,1
		SHR		FLD0,1
;--------------------------
		AND		AL,00101100B
		OR		BH,2AH
		TEST	BL,7AH
		OR		FLD0,23H
BEGIN   ENDP
CODESG  ENDS
        END BEGIN
