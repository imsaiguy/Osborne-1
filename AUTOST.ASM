

;------------------------------------------------
; AUTOCPM.ASM	version 1.0		10/12/81
;
; copyright 1981 by Thom Hogan
;		    Basically Speaking Press
;		    Palo Alto, CA
;
; This program loads and executes SC.COM
;
;------------------------------------------------
;
; EQUATES
;
clear	equ	26	;clear screen
escape	equ	1bh	;escape character
graph	equ	'g'	;graphics
nograph	equ	'G'	;nographics
pbuff	equ	9	;BDOS print buffer
bdos	equ	5	;location of BDOS
cr	equ 	0dh	;carriage return
lf	equ	0ah	;line feed
;
; START OF PROGRAM
;
	org	0100h
;
	lhld	01	;get warm start address
	mvi	l,00	;zero L register
	mov	a,h	;get page boundary in A
	sui	16h	;subtract 16 to find CCP
	mov	h,a	;put back new page boundary
	shld	ccp	;store it
	lxi	d,logo	;point to logo
	lxi 	b,2047	;number of characters in logo
over:	ldax	d	;get byte of logo
	sui	65	;convert to graphics
	stax	d	;store it
	inx	d	;new address
	dcx	b	;decrement byte counter
	mov	a,b	;ggt in A
	ora	a	;are we done?
	jnz	over	;if no, back again
start:	lxi	d,startgr	;point to startgraphics
	call	print
	lxi	d,logo		;point to logo message
	call 	print		;display it
	lxi	d,stopgr	;point to end of graphics
	call	print		;display it
	lxi	d,endmes	;point to load message
	call	print
	lxi	d,filename	;point to file name
	lxi	b,10		;set counter
move:	lhld	ccp	;get CCP back
	mvi	l,07	;bias by 7 bytes
	call	again	;move file name to CCP
	lhld	ccp	;get CCP back
	mvi	l,88h	;offset to counter
	mvi	a,08h	;lsb of ccp pointer
	mov	m,a	;put it in place
	lhld	ccp	;get CCP one more time
	mvi	l,89h	;offset to counter
	mov 	a,h	;put it in place
	mov 	m,a	;counter restored
	lhld	ccp	;get CCP last time
	pchl		;execute cold start
again:	ldax	d	;get byte to move
	mov	m,a	;move it
	inx	h	;increment location
	inx 	d	;increment location
	dcx	b	;decrement counter
	mov	a,b	;get counter in a
	ora	c	;check if done
	jnz	again	;...not done
	ret		;...done
print:	mvi	c,pbuff	;get proper call in c
	jmp	bdos	;do it
;
;STORAGE AREA
;
ccp:	ds	2	;temp storage of CCP
filename:	db	06,'SC',0,0,0,0,0,0,0,0,0
;		       /	   \
;	       length /   command   must be followed by at
;	    of command    string    least one zero to work properly
;
; note: if command string is longer than 8 characters,
;	you must change "lxe b,10" just before MOVE: to
;	"lxi b,length+2"
;
startgr:	db	clear
		db	escape,graph,'$'
stopgr:		db	escape,nograph,'$'
endmes:		db	cr,lf,lf,lf,9,'Loading SUPERCALC...',cr,lf,lf,'$'
;					/
;				  message to print under logo
;
logo:	db	'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaaKWWWWWWWWWWWWWWWWWWWWI'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
	db	'Iaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaKWWWWWWZaaaaaaaaaaVWWWWW'
	db	'WIaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
	db	'YYaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaWWWWWWWaaaaaaaaaaaaWWWWW'
	db	'WWaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
	db	'YYaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaWWWWWWWaaaaaaaaaaaaWWWWW'
	db	'WWaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
	db	'YYaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaWWWWWWWaaaaaaaaaaaaWWWWW'
	db	'WWaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
	db	'YYaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaVWWWWWWIaaaaaaaaaaKWWWWW'
	db	'WZaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
	db	'Zaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaaVWWWWWWWWWWWWWWWWWWWWZ'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	db	'aaaaaaaaaaaaaaaaaaaaaaaaaaaa$'
end




