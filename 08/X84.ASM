		page 60,132
TITLE	X84 (COM) ; Упр. 8.4. Вывод на экран расширенной DOS
CODESG	SEGMENT	PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
;--------------------------------------------------------------
;		Данные с сообщением:
DISAREA	DB		'Enter date (dd/mm/yy)',07H,13,10; Выводимое сообщение
;--------------------------------------------------------------
;		Вывод на экран:
MAIN	PROC	NEAR
		MOV		AH,40H		; Запрос вывода на экран
		MOV		BX,01		; Выводное устройство (1 - экран)
		MOV		CX,24		; Макс. длина сообщения (в байтах)
		LEA		DX,DISAREA	; Адрес области данных с сообщением
		INT		21H			; Вызов DOS
		RET
MAIN	ENDP
CODESG	ENDS
		END		BEGIN