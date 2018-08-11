		page	60,132
		TITLE	EX73 (EXE) ;Чшёыр Фшсюэрўўш
;-------------------------------------------------
STACKSG SEGMENT	PARA STACK 'Stack'
        DW		32 DUP(?)
STACKSG ENDS
;-------------------------------------------------
DATASG	SEGMENT	PARA 'Data'
X0		DW		0000H		;шёїюфэ√х фрээ√х	X0=0
X1		DW		0001H		;					X1=1
XN		DW		11 DUP(?)	;Ёхчєы№ЄрЄ√
DATASG	ENDS
;-------------------------------------------------
CODESG  SEGMENT PARA 'Code'
BEGIN   PROC    FAR
        ASSUME  CS:CODESG,DS:DATASG,SS:STACKSG,ES:DATASG
        PUSH    DS
        SUB     AX,AX
        PUSH    AX
		MOV		AX,DATASG
		MOV		DS,AX
		MOV		ES,AX
		CALL	B10
		RET
BEGIN   ENDP
;-------------------------------------------------
B10		PROC
		MOV		AX,X0	;чруЁєчър шёїюфэ√ї фрээ√ї
		MOV		DX,X1
		LEA		BX,XN	;єърчрЄ№ ▀ўхщъш фы  т√уЁєчъш Ёхчєы№ЄрЄют ЁрёўхЄр
		MOV		CX,6	;чрфрэшх 6 Ўшъыют (яю фтр Ёхчєы№ЄрЄр чр Ўшъы)
						;			AX		DX
B20:					;			X0=0	X1=1
		ADD AX,DX		;X2=X0+X1	X2=1	X1=1
		MOV	[BX],AX		;яюьхёЄшЄ№ т ярь Є№ Ёхчєы№ЄрЄ
		INC BX			;ёыхфє■∙р▀ ▀ўхщър
		INC BX			;ёыхфє■∙р▀ ▀ўхщър
		ADD DX,AX		;X3=X1+X2	X2=1	X3=2
		MOV [BX],DX		;яюьхёЄшЄ№ т ярь Є№ Ёхчєы№ЄрЄ
		INC BX			;ёыхфє■∙р▀ ▀ўхщър
		INC BX			;ёыхфє■∙р▀ ▀ўхщър
		LOOP B20		;яютЄюЁшЄ▀ B20
        RET
B10		ENDP
;-------------------------------------------------
CODESG  ENDS
        END BEGIN