.387
		PUBLIC	_com_toupper
		EXTRN	__chkstk:BYTE
		EXTRN	_com_settbl:BYTE
		EXTRN	_casemap_up:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_com_toupper:
	push		bp
	mov		bp,sp
	xor		ax,ax
	call		near ptr __chkstk
	push		si
	call		near ptr _com_settbl
	mov		bl,byte ptr 4[bp]
	sub		bh,bh
	mov		si,word ptr _casemap_up
	mov		al,byte ptr [bx+si]
	sub		ah,ah
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$1:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 75H, 70H
    DB	70H, 65H, 72H, 2eH, 63H, 9, 31H, 2eH
    DB	31H, 20H, 38H, 36H, 2fH, 30H, 36H, 2fH
    DB	31H, 37H, 0, 0
    DW	offset DGROUP:L$1

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
