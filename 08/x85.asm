		page 60,132
TITLE	X85 (COM) ; Упр. 8.5. Ввод с клавиатуры расширенной DOS
CODESG	SEGMENT	PARA 'Code'
		ASSUME	CS:CODESG,DS:CODESG,SS:CODESG
		ORG		100H
BEGIN:	JMP		MAIN
;--------------------------------------------------------------
;		Область вводимых данных:
INAREA	DB		11 DUP (' '); Область записи введенного сообщения
;--------------------------------------------------------------
;		Ввод данных с клавиатуры:
MAIN	PROC	NEAR
		MOV		AH,3FH		; Запрос ввода
		MOV		BX,00		; Устройство (0 - клавиатура)
		MOV		CX,11		; Макс. длина данных (в байтах)*
		LEA		DX,INAREA	; Адрес области для записи ввода
		INT		21H			; Вызов DOS
		RET
MAIN	ENDP
CODESG	ENDS
		END		BEGIN

; После завершения процедуры в регистре AX автоматически
; заносится число, равное количеству введенных символов + 2
; для символов возврата каретки (0D) и конца строки (0A).