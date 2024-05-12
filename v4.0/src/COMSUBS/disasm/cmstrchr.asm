.387
		PUBLIC	_com_strchr
		EXTRN	__chkstk:BYTE
		EXTRN	_com_settbl:BYTE
		EXTRN	_check_dbcs:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_com_strchr:
	push		bp
	mov		bp,sp
	mov		ax,4
	call		near ptr __chkstk
	push		si
	mov		word ptr i,0
	call		near ptr _com_settbl
	jmp		L$3
L$1:            	
	mov		al,byte ptr c1
	sub		ah,ah
	push		ax
	call		near ptr _check_dbcs
	add		sp,2
	cmp		ax,1
	jne		L$4
	inc		word ptr i
L$2:
	inc		word ptr i
L$3:
	mov		bx,word ptr i
	mov		si,word ptr s1
	mov		al,byte ptr [bx+si]
	mov		byte ptr c1,al
	or		al,al
	jne		L$1
	cmp		byte ptr c,0
	jne		L$5
	mov		ax,bx
	add		ax,si
	jmp		L$6
L$4:
	mov		si,word ptr i
	add		si,word ptr s1
	mov		al,byte ptr [si]
	cmp		byte ptr c,al
	jne		L$2
	mov		ax,si
	jmp		L$6
L$5:
	sub		ax,ax
L$6:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$7:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 73H, 74H
    DB	72H, 63H, 68H, 72H, 2eH, 63H, 9, 31H
    DB	2eH, 31H, 20H, 38H, 36H, 2fH, 30H, 36H
    DB	2fH, 31H, 37H, 0
    DW	offset DGROUP:L$7

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
