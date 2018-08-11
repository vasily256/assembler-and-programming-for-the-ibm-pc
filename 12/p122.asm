		page	60,132
		TITLE	P122 (EXE) ‘ложение двойных слов
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
WORD1A	DW		0123H
WORD1B	DW		0BC62H
WORD2A	DW		0012H
WORD2B	DW		553AH
WORD3A	DW		?
WORD3B	DW		?
WORD5A	DW		?
WORD5B	DW		?
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
		CALL	D10DWD		; способ 1
		CALL	E10DWD		; способ 2
		RET
BEGIN	ENDP
;				‘пособ 1:
;				-------------------------------
D10DWD	PROC	NEAR
		MOV		AX,WORD1B	; ‘ложить правые слова
		ADD		AX,WORD2B
		MOV		WORD3B,AX
		MOV		AX,WORD1A	; ‘ложить левые слова
		ADC		AX,WORD2A	;  с переносом
		MOV		WORD3A,AX
		RET
D10DWD	ENDP
;				‘пособ 2:
;				-------------------------------
E10DWD	PROC	NEAR
		CLC					; Ћчистить флаг переноса
		MOV		CX,2
		LEA		SI,WORD1B	; Џравые
		LEA		DI,WORD2B	;  слова
		LEA		BX,WORD5B	; ‘умма правых слов
E20:	
		MOV		AX,[SI]
		ADC		AX,[DI]
		MOV		[BX],AX
		DEC		SI
		DEC		SI
		DEC		DI
		DEC		DI
		DEC		BX
		DEC		BX
		LOOP	E20
		RET
E10DWD	ENDP
CODESG  ENDS
		END BEGIN