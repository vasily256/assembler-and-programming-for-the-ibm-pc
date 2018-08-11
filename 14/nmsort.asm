;		page	60,132
title	NmSort	(exe) ‚ў®¤ Ё б®авЁа®ўЄ  Ё¬Ґ­
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
		call	b10read			; ‚ўҐбвЁ Ё¬п б Є« ўЁ вгал
		cmp		namelen,00		; €¬п ўўҐ¤Ґ­®?
		jz		a30				;	ЌҐв - Ё¤вЁ ­  б®авЁа®ўЄг
		cmp		namectr,30		; ‚ўҐ¤Ґ­® 30 Ё¬Ґ­?
		je		a30				; €¤вЁ ­  б®авЁа®ўЄг
		call	d10stor			; ‡ ЇЁб вм Ё¬п ў в Ў«Ёжг
		jmp		a20loop
a30:
		call	q10clr
		call	q20curs
		cmp		namectr,01		; ЊҐ­ҐҐ 2 Ё¬Ґ­?
		jbe		a40				;	„  - ўл©вЁ
		call	g10sort			; ‘®авЁа®ў вм Ё¬Ґ­ 
		call	k10disp			; ‚лўҐбвЁ аҐ§г«мв в
a40:
		ret
begin	endp
;				‚ў®¤ Ё¬Ґ­ б Є« ўЁ вгал:
;				--------------------------------------------
b10read	proc	near
		mov		ah,09			; ‚лўҐбвЁ вҐЄбв § Їа®б 
		mov		dx,offset messg1
		int		21h
		mov		ah,0ah			; ‚ўҐбвЁ Ё¬п
		mov		dx,offset namepar
		int		21h
		mov		ah,09
		mov		dx,offset crlf	; ‚лўҐбвЁ ЇҐаҐ­®б бва®ЄЁ
		int		21h
		mov		bh,00
		mov 	bl,namelen
		mov		cx,21
		sub		cx,bx			; ‚лзЁб«Ёвм ®бв ўигобп з бвм
b20:
		mov		namefld[bx],20h	;	Ё § Ї®«­Ёвм Ґс Їа®ЎҐ« ¬Ё
		inc		bx
		loop	b20
		ret
b10read	endp
;				‡ ЇЁбм Ё¬Ґ­Ё ў в Ў«Ёжг:
;				--------------------------------------------
d10stor	proc	near
		inc		namectr
		cld
		mov		si,offset namefld
		mov		cx,10
		rep		movsw
		ret
d10stor	endp
;				‘®авЁа®ўЄ  Ё¬Ґ­ ў в Ў«ЁжҐ:
;				--------------------------------------------
g10sort	proc	near
		sub		di,40			; “бв ­®ўЁвм  ¤аҐб ®бв ­®ў 
		mov		endaddr,di
g20:
		mov		swapped,00		; “бв ­®ўЁвм ­ з «®
		mov		si,offset nametab	;в Ў«Ёжл
g30:
		mov		cx,20			; „«Ё­  ба ў­Ґ­Ёп
		mov		di,si
		add		di,20			; ‘«Ґ¤гойҐҐ Ё¬п
		mov		ax,di			; ‘®еа ­Ёвм  ¤аҐб 
		mov		bx,si
		repe cmpsb				; ќ«. [si] ¬Ґ­миҐ н«. [di]?
		jbe		g40				;	„  - ­Ґв ЇҐаҐбв ­®ўЄЁ
		call	h10xchg			;	ЌҐв - ЇҐаҐбв ­®ўЄ 
g40:
		mov		si,ax			; Ђ¤аҐб б«Ґ¤гойҐЈ® Ё¬Ґ­Ё
		cmp		si,endaddr		; Љ®­Ґж в Ў«Ёжл?
		jbe		g30				;	ЌҐв - Їа®¤®«¦Ёвм
		cmp		swapped,00		; …бвм ЇҐаҐбв ­®ўЄ ?
		jnz		g20				; „  - Їа®¤®«¦Ёвм
		ret						; ЌҐв - Є®­Ґж
g10sort	endp
;				ЏҐаҐбв ­®ўЄ  н«Ґ¬Ґ­в®ў в Ў«Ёжл:
;				--------------------------------------------
h10xchg	proc	near
		mov		cx,10
		mov		di,offset namesav
		mov		si,bx
		rep movsw				; ‘®еа ­Ёвм ўҐае­Ё© н«Ґ¬Ґ­в.
		mov		cx,10
		mov		di,bx			; ЏҐаҐб« вм ­Ё¦­Ё© н«Ґ¬Ґ­в
		rep movsw				;	­  ¬Ґбв® ўҐае­ҐЈ®
		mov		cx,10
		mov		si,offset namesav
		rep movsw
		mov		swapped,01		; ЏаЁ§­ Є ЇҐаҐбв ­®ўЄЁ
		ret
h10xchg	endp
;				‚лў®¤ ­  нЄа ­ ®вб®авЁа®ў ­­ле Ё¬Ґ­:
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
;				ЋзЁбвЄ  нЄа ­ :
;				--------------------------------------------
q10clr	proc	near
		mov		ax,0600h
		mov		bh,07h
		sub		cx,cx
		mov		dx,184fh
		int		10h
		ret
q10clr	endp
;				“бв ­®ўЄ  Єгаб®а :
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