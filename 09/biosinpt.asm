		page	60,132
		TITLE	NMSCROLL (EXE) Инверсия, мигание, прокрутка
;-------------------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
	    DW		32 DUP(?)
STACKSG ENDS
;-------------------------------------------------------
DATASG	SEGMENT	PARA 'Data'
INPTNM	DB		20 DUP (' ')
LNM		DB		?

DATASG	ENDS
;-------------------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
		ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:DATASG
        PUSH    DS
		SUB     AX,AX
        PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		MOV		ES,AX
		CALL	INPT10
		RET
BEGIN	ENDP
;-------------------------------------------------------
;		Установить курсор:
INPT10	PROC	NEAR
		MOV		AH,08		; запрос на чтение атрибута/символа
		MOV		BH,00		; экран 0 (страница)
		INT		10H			; передача управления в BIOS
		RET
INPT10	ENDP
;-------------------------------------------------------
CODESG  ENDS
		END BEGIN