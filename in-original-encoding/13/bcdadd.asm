		page	60,132
		TITLE	BSCADD (EXE) Преобр. ASCII в BCD, сложение
;----------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;----------------------------------------------
DATASG	SEGMENT	PARA 'Data'
ASC1	DB		'057836'
ASC2	DB		'069427'
BCD1	DB		'000'
BCD2	DB		'000'
BCD3	DB		4 DUP(0)
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
		
		LEA		SI,ASC1+4
		LEA		DI,BCD1+2
		CALL	B10CONV
		LEA		SI,ASC2+4
		LEA		DI,BCD2+2		
		CALL	B10CONV
		CALL	C10ADD
		RET
BEGIN	ENDP
;				Преобразование ASCII в BCD
;				-------------------------------
B10CONV	PROC	NEAR
		MOV		CL,04		; Фактор сдвига
		MOV		DX,03		; Число слов
B20:
		MOV		AX,[SI]		; Получить ASCII-пару
		XCHG	AH,AL
		SHL		AL,CL
		SHL		AX,CL
		MOV		[DI],AH
		DEC		SI
		DEC		SI
		DEC		DI
		DEC		DX
		JNZ		B20
		RET
B10CONV	ENDP
;				Сложение BCD-чисел
;				-------------------------------
C10ADD	PROC	NEAR
		XOR		AH,AH		; Очистить AH
		LEA		SI,BCD1+2
		LEA		DI,BCD2+2
		LEA		BX,BCD3+3
		MOV		CX,03
		CLC
C20:
		MOV		AL,[SI]
		ADC		AL,[DI]
		DAA					; Десятичная коррекция
		MOV		[BX],AL
		DEC		SI
		DEC		DI
		DEC		BX
		LOOP	C20
		RET
C10ADD	ENDP
CODESG  ENDS
		END BEGIN