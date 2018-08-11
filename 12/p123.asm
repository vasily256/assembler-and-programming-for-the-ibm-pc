		page	60,132
		TITLE	P123 (EXE) “множение
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
BYTE1	DB		80H
BYTE2	DB		40H
WORD1	DW		8000H
WORD2	DW		4000H
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
		CALL	C10MUL		; “множение MUL
		CALL	D10IMUL		; “множение IMUL
		RET
BEGIN	ENDP
;				“множение MUL (беззнаковое):
;				-------------------------------
C10MUL	PROC	NEAR
		MOV		AL,BYTE1	; Ѓайт * байт
		MUL		BYTE2		;  Џроизведение в AX
		MOV		AX,WORD1	; ‘лово * слово
		MUL		WORD2		;  Џроизведение в DX:AX
		MOV		AL,BYTE1	; Ѓайт * слово
		SUB		AH,AH		;  ђасширение множителЯ
		MUL		WORD1		;  Џроизведение в DX:AX
		RET
C10MUL	ENDP
;				“множение IMUL (знаковое):
;				-------------------------------
D10IMUL	PROC	NEAR
		MOV		AL,BYTE1	; Ѓайт * байт
		IMUL	BYTE2		;  Џроизведение в AX
		MOV		AX,WORD1	; ‘лово * слово
		IMUL	WORD2		;  Џроизведение в DX:AX
		MOV		AL,BYTE1	; Ѓайт * слово
		CBW					;  ђасширение множителЯ
		IMUL	WORD1		;  Џроизведение в DX:AX
		RET
D10IMUL	ENDP
CODESG  ENDS
		END BEGIN