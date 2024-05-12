.387
		PUBLIC	_com_strupr
		EXTRN	__chkstk:BYTE
		EXTRN	_com_settbl:BYTE
		EXTRN	_check_dbcs:BYTE
		EXTRN	_casemap_up:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_com_strupr:
	push		bp
	mov		bp,sp
	mov		ax,6
	call		near ptr __chkstk
	push		si
	call		near ptr _com_settbl
	mov		ax,word ptr s
	mov		word ptr str,ax
L$1:
	mov		bx,word ptr str
	mov		al,byte ptr [bx]
	mov		byte ptr c,al
	or		al,al
	je		L$2
	sub		ah,ah
	push		ax
	call		near ptr _check_dbcs
	add		sp,2
	cmp		ax,1
	jne		L$3
	inc		word ptr str
	mov		bx,word ptr str
	cmp		byte ptr [bx],0
	jne		L$4
L$2:
	mov		ax,word ptr s
	jmp		L$5
L$3:
	mov		bx,word ptr str
	mov		bl,byte ptr [bx]
	sub		bh,bh
	mov		si,word ptr _casemap_up
	mov		al,byte ptr [bx+si]
	mov		bx,word ptr str
	mov		byte ptr [bx],al
L$4:
	inc		word ptr str
	jmp		L$1
L$5:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$6:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 73H, 74H
    DB	72H, 75H, 70H, 72H, 2eH, 63H, 9, 31H
    DB	2eH, 31H, 20H, 38H, 36H, 2fH, 30H, 36H
    DB	2fH, 31H, 37H, 0
    DW	offset DGROUP:L$6

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
