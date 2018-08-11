		page	60,132
		TITLE	P123 (EXE) „Ґ«Ґ­ЁҐ
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
DATAX	DW		0148H
		DW		2316H
DATAY	DW		0237H
		DW		5052H
CYCLE	DB		5
DATASG	ENDS
;----------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:DATASG
        PUSH    DS
		SUB     AX,AX
        PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		MOV		ES,AX
		CALL	B10SUM		; 12.1 ‘«®¦Ґ­ЁҐ
		CALL	C10SUM		; 12.2 ‘«®¦Ґ­ЁҐ б ЇҐаҐ­®б®¬
		CALL	E10MUL		; 12.3 “¬­®¦Ґ­ЁҐ
		CALL	F10DIV		; 12.5 „Ґ«Ґ­ЁҐ
		CALL	E10SHR		; 12.6 ‘¤ўЁЈ аҐЈЁбва®ў®© Ї ал
		RET
BEGIN	ENDP
;				12.1 ‘«®¦Ґ­ЁҐ:
;				-------------------------------
B10SUM	PROC	NEAR
		MOV		AX,DATAX	;  ) 2-е б«®ў
		ADD		AX,DATAY
		SUB		DX,DX		; Ў) 2-е ¤ў.б«®ў
		MOV		AX,DATAX+2	;	б«®¦Ґ­ЁҐ ¬«. б«®ў
		ADD		AX,DATAY+2
		ADC		DX,DATAX	;	б«®¦Ґ­Ґ бв. б«®ў
		ADD		DX,DATAY
		RET
B10SUM	ENDP
;				12.2 ‘«®¦Ґ­ЁҐ б ЇҐаҐ­®б®¬:
;				-------------------------------
C10SUM	PROC	NEAR
		STC					; “бв ­®ўЁвм 1 ў CF
		MOV		BX,DATAX
		ADC		BX,DATAY
		RET
C10SUM	ENDP
;				12.3 “¬­®¦Ґ­ЁҐ:
;				-------------------------------
E10MUL	PROC	NEAR
		MOV		AX,DATAX	;  ) 2-е б«®ў
		MUL		DATAY
		MOV		AX,DATAX	; Ў) ¤ў.б«®ў  ­  б«®ў®:
		MUL		DATAY		;	г¬­®¦Ґ­ЁҐ бв.б«®ў 
		MOV		BX,AX		;	б®еа ­Ґ­ЁҐ Їа®Ё§ўҐ¤.
		MOV		CX,DX
		MOV		AX,DATAX+2
		MUL		DATAY		;	г¬­®¦Ґ­ЁҐ ¬«.б«®ў 
		ADD		DX,BX
		ADC		CX,00		;	Їа®Ё§ўҐ¤. ў CX:DX:AX
		RET
E10MUL	ENDP
;				12.5 „Ґ«Ґ­ЁҐ:
;				-------------------------------
F10DIV	PROC	NEAR
		MOV		AX,DATAX	;  ) б«®ў® ­  Ў ©в
		MOV		BL,23
		DIV		BL
		MOV		AX,DATAX+2	; Ў) ¤ў.б«®ў® ­  б«®ў®
		MOV		DX,DATAX
		DIV		DATAY
		RET
F10DIV	ENDP
;				12.6 ‘¤ўЁЈ аҐЈЁбва®ў®© Ї ал:
;				-------------------------------
E10SHR	PROC	NEAR
		MOV		CL,CYCLE
		MOV		AX,DATAX+2
		MOV		DX,DATAX
		SHR		AX,CL
		MOV		BX,DX
		SHR		DX,CL		; = 0AH
		SUB		CL,16
		NEG		CL
		SHL		BX,CL		; = 4000H
		OR		AX,BX
		RET
E10SHR	ENDP
CODESG  ENDS
		END BEGIN