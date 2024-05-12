.387
		PUBLIC	_com_substr
		EXTRN	__chkstk:BYTE
		EXTRN	_com_settbl:BYTE
		EXTRN	_strlen:BYTE
		EXTRN	_check_dbcs:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_com_substr:
	push		bp
	mov		bp,sp
	mov		ax,0eH
	call		near ptr __chkstk
	push		si
	call		near ptr _com_settbl
	push		word ptr s
	call		near ptr _strlen
	add		sp,2
	mov		word ptr ns,ax
	push		word ptr t
	call		near ptr _strlen
	add		sp,2
	mov		word ptr nt,ax
	mov		ax,word ptr ns
	cmp		word ptr nt,ax
	jle		L$2
L$1:
	sub		ax,ax
	jmp		near ptr L$9
L$2:
	mov		word ptr i,0
	mov		word ptr j,0
L$3:
	mov		ax,word ptr ns
	sub		ax,word ptr nt
	inc		ax
	cmp		ax,word ptr i
	jle		L$1
	mov		si,word ptr i
	add		si,word ptr s
	mov		bx,word ptr t
	mov		al,byte ptr [si]
	cmp		byte ptr [bx],al
	jne		L$8
	cmp		word ptr i,0
	je		L$4
	cmp		word ptr i,0
	je		L$8
	mov		al,byte ptr -1[si]
	sub		ah,ah
	push		ax
	call		near ptr _check_dbcs
	add		sp,2
	cmp		ax,1
	je		L$8
L$4:
	mov		ax,word ptr i
	mov		word ptr saved_i,ax
	mov		word ptr saved_xxx,0
	mov		ax,word ptr nt
	mov		word ptr saved_nt,ax
	jmp		L$6
L$5:
	mov		bx,word ptr saved_i
	mov		si,word ptr s
	mov		al,byte ptr [bx+si]
	mov		bx,word ptr saved_xxx
	mov		si,word ptr t
	cmp		byte ptr [bx+si],al
	jne		L$7
	dec		word ptr saved_nt
	mov		ax,word ptr saved_i
	inc		word ptr saved_i
	inc		word ptr saved_xxx
L$6:
	cmp		word ptr saved_nt,0
	jg		L$5
L$7:
	cmp		word ptr saved_nt,0
	jne		L$8
	mov		ax,word ptr i
	add		ax,word ptr s
	jmp		L$9
L$8:
	mov		word ptr j,0
	inc		word ptr i
	jmp		near ptr L$3
L$9:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$10:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 73H, 75H
    DB	62H, 73H, 74H, 72H, 2eH, 63H, 9, 31H
    DB	2eH, 31H, 20H, 38H, 36H, 2fH, 30H, 36H
    DB	2fH, 31H, 37H, 0
    DW	offset DGROUP:L$10

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
