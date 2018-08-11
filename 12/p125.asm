		page	60,132
		TITLE	P123 (EXE) „Ґ«Ґ­ЁҐ
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
BYTE1	DB		80H
BYTE2	DB		16H
WORD1	DW		2000H
WORD2	DW		0010H
WORD3	DW		1000H
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
		CALL	D10DIV
		CALL	E10IDIV
		RET
BEGIN	ENDP
;				ЎҐ§§­ Є®ў®Ґ ¤Ґ«Ґ­ЁҐ:
;				-------------------------------
D10DIV	PROC	NEAR
		MOV		AX,WORD1	;б«®ў®/Ў ©в
		DIV		BYTE1		; ®бв:з бв­ ў AH:AL
		MOV		AL,BYTE1	;Ў ©в/Ў ©в
		SUB		AH,AH		;а биЁа. ¤Ґ«Ё¬®Ј® ў AH
		DIV		BYTE2		; ®бв:з бв­ ў AH:AL
		MOV		DX,WORD2	;„ў. б«®ў®/б«®ў®
		MOV		AX,WORD3	; ¤Ґ«Ё¬®Ґ ў DX:AX
		DIV		WORD1		; ®бв:з бв­ ў DX:AX
		MOV		AX,WORD1	;б«®ў®/б«®ў®
		SUB		DX,DX		; а биЁа. ¤Ґ«Ё¬®Ј® ў DX
		DIV		WORD3		; ®бв:з бв­ ў DX:AX
		RET
D10DIV	ENDP
;				§­ Є®ў®Ґ ¤Ґ«Ґ­ЁҐ:
;				-------------------------------
E10IDIV	PROC	NEAR
		MOV		AX,WORD1	;б«®ў®/Ў ©в
		IDIV	BYTE1		; ®бв:з бв­ ў AH:AL
		MOV		AL,BYTE1	;Ў ©в/Ў ©в
		CBW					;а биЁа. ¤Ґ«Ё¬®Ј® ў AH
		IDIV	BYTE2		; ®бв:з бв­ ў AH:AL
		MOV		DX,WORD2	;„ў®©­®Ґ б«®ў®/б«®ў®
		MOV		AX,WORD3	; ¤Ґ«Ё¬®Ґ ў DX:AX
		IDIV	WORD1		; ®бв:з бв­ ў DX:AX
		MOV		AX,WORD1	;б«®ў®/б«®ў®
		CWD					; а биЁа. ¤Ґ«Ё¬®Ј® ў DX
		IDIV	WORD3		; ®бв:з бв­ ў DX:AX
		RET
E10IDIV	ENDP
CODESG  ENDS
		END BEGIN