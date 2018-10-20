;		page	60,132
title	NmSort	(exe) Ввод и сортировка имен
;-------------------------------------------------------------
stack	segment	para stack 'stack'
		dw		32 dup(?)
stack	ends
;-------------------------------------------------------------
datasg	segment	para 'data'
namepar	label	byte
maxnlen	db		21
namelen	db		?
namefld	db		21 dup(' ')
crlf	db		13, 10, '$'
endaddr	dw		?
messg1	db		'Name: ', '$'
namectr	db		00
nametab	db		30 dup(20 dup(' '))
namesav	db		20 dup(?), 13, 10, '$'
swapped	db		00
datasg	ends
;-----------------------------------------------------------
codesg	segment	para 'code'
begin	proc	far
		assume	cs:codesg, ds:datasg, ss:stack, es:datasg
		push	ds
		xor		ax,ax
		push	ax
		mov		ax,datasg
		mov		ds,ax
		mov		es,ax

		cld
		mov		di,offset nametab
		call	q10clr
		call	q20curs
a20loop:	
		call	b10read			; Ввести имя с клавиатуры
		cmp		namelen,00		; Имя введено?
		jz		a30				;	Нет - идти на сортировку
		cmp		namectr,30		; Введено 30 имен?
		je		a30				; Идти на сортировку
		call	d10stor			; Записать имя в таблицу
		jmp		a20loop
a30:
		call	q10clr
		call	q20curs
		cmp		namectr,01		; Менее 2 имен?
		jbe		a40				;	Да - выйти
		call	g10sort			; Сортировать имена
		call	k10disp			; Вывести результат
a40:
		ret
begin	endp
;				Ввод имен с клавиатуры:
;				--------------------------------------------
b10read	proc	near
		mov		ah,09			; Вывести текст запроса
		mov		dx,offset messg1
		int		21h
		mov		ah,0ah			; Ввести имя
		mov		dx,offset namepar
		int		21h
		mov		ah,09
		mov		dx,offset crlf	; Вывести перенос строки
		int		21h
		mov		bh,00
		mov 	bl,namelen
		mov		cx,21
		sub		cx,bx			; Вычислить оставшуюся часть
b20:
		mov		namefld[bx],20h	;	и заполнить её пробелами
		inc		bx
		loop	b20
		ret
b10read	endp
;				Запись имени в таблицу:
;				--------------------------------------------
d10stor	proc	near
		inc		namectr
		cld
		mov		si,offset namefld
		mov		cx,10
		rep		movsw
		ret
d10stor	endp
;				Сортировка имен в таблице:
;				--------------------------------------------
g10sort	proc	near
		sub		di,40			; Установить адрес останова
		mov		endaddr,di
g20:
		mov		swapped,00		; Установить начало
		mov		si,offset nametab	;таблицы
g30:
		mov		cx,20			; Длина сравнения
		mov		di,si
		add		di,20			; Следующее имя
		mov		ax,di			; Сохранить адреса
		mov		bx,si
		repe cmpsb				; Эл. [si] меньше эл. [di]?
		jbe		g40				;	Да - нет перестановки
		call	h10xchg			;	Нет - перестановка
g40:
		mov		si,ax			; Адрес следующего имени
		cmp		si,endaddr		; Конец таблицы?
		jbe		g30				;	Нет - продолжить
		cmp		swapped,00		; Есть перестановка?
		jnz		g20				; Да - продолжить
		ret						; Нет - конец
g10sort	endp
;				Перестановка элементов таблицы:
;				--------------------------------------------
h10xchg	proc	near
		mov		cx,10
		mov		di,offset namesav
		mov		si,bx
		rep movsw				; Сохранить верхний элемент.
		mov		cx,10
		mov		di,bx			; Переслать нижний элемент
		rep movsw				;	на место верхнего
		mov		cx,10
		mov		si,offset namesav
		rep movsw
		mov		swapped,01		; Признак перестановки
		ret
h10xchg	endp
;				Вывод на экран отсортированных имен:
;				--------------------------------------------
k10disp	proc	near
		mov		si,offset nametab
k20:
		mov		di,offset namesav
		mov		cx,10
		rep movsw
		mov		ah,09
		mov		dx,offset namesav
		int		21h
		dec		namectr
		jnz		k20
		ret
k10disp	endp
;				Очистка экрана:
;				--------------------------------------------
q10clr	proc	near
		mov		ax,0600h
		mov		bh,07h
		sub		cx,cx
		mov		dx,184fh
		int		10h
		ret
q10clr	endp
;				Установка курсора:
;				--------------------------------------------
q20curs	proc	near
		mov		ah,02
		sub		bh,bh
		sub		dx,dx
		int		10h
		ret
q20curs	endp
codesg	ends
		end		begin