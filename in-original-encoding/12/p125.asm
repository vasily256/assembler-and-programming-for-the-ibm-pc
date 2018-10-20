		page	60,132
		TITLE	P123 (EXE) Деление
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
;				беззнаковое деление:
;				-------------------------------
D10DIV	PROC	NEAR
		MOV		AX,WORD1	;слово/байт
		DIV		BYTE1		; ост:частн в AH:AL
		MOV		AL,BYTE1	;байт/байт
		SUB		AH,AH		;расшир. делимого в AH
		DIV		BYTE2		; ост:частн в AH:AL
		MOV		DX,WORD2	;Дв. слово/слово
		MOV		AX,WORD3	; делимое в DX:AX
		DIV		WORD1		; ост:частн в DX:AX
		MOV		AX,WORD1	;слово/слово
		SUB		DX,DX		; расшир. делимого в DX
		DIV		WORD3		; ост:частн в DX:AX
		RET
D10DIV	ENDP
;				знаковое деление:
;				-------------------------------
E10IDIV	PROC	NEAR
		MOV		AX,WORD1	;слово/байт
		IDIV	BYTE1		; ост:частн в AH:AL
		MOV		AL,BYTE1	;байт/байт
		CBW					;расшир. делимого в AH
		IDIV	BYTE2		; ост:частн в AH:AL
		MOV		DX,WORD2	;Двойное слово/слово
		MOV		AX,WORD3	; делимое в DX:AX
		IDIV	WORD1		; ост:частн в DX:AX
		MOV		AX,WORD1	;слово/слово
		CWD					; расшир. делимого в DX
		IDIV	WORD3		; ост:частн в DX:AX
		RET
E10IDIV	ENDP
CODESG  ENDS
		END BEGIN