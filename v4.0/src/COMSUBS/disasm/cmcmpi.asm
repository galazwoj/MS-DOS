.387
		PUBLIC	_com_strcmpi
		EXTRN	__chkstk:BYTE
		EXTRN	_com_settbl:BYTE
		EXTRN	_check_dbcs:BYTE
		EXTRN	_casemap_up:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_com_strcmpi:
	push		bp
	mov		bp,sp
	mov		ax,8
	call		near ptr __chkstk
	push		si
	call		near ptr _com_settbl
	mov		word ptr i,0
	mov		bx,word ptr s1
	mov		al,byte ptr [bx]
	mov		byte ptr c1,al
	mov		bx,word ptr s2
	mov		al,byte ptr [bx]
	mov		byte ptr c2,al
L$1:
	cmp		byte ptr c1,0
	je		L$7
	cmp		byte ptr c2,0
	je		L$7
	mov		word ptr k,0
	mov		al,byte ptr c1
	sub		ah,ah
	push		ax
	call		near ptr _check_dbcs
	add		sp,2
	or		ax,ax
	jne		L$2
	mov		bl,byte ptr c1
	sub		bh,bh
	mov		si,word ptr _casemap_up
	mov		al,byte ptr [bx+si]
	mov		byte ptr c1,al
	mov		bl,byte ptr c2
	mov		al,byte ptr [bx+si]
	mov		byte ptr c2,al
	mov		word ptr k,1
L$2:
	cmp		word ptr k,2
	jge		L$1
	mov		al,byte ptr c2
	cmp		byte ptr c1,al
	jbe		L$4
L$3:
	mov		ax,1
	jmp		L$9
L$4:
	mov		al,byte ptr c2
	cmp		byte ptr c1,al
	jae		L$6
L$5:
	mov		ax,0ffffH
	jmp		L$9
$6:
	inc		word ptr i
	mov		bx,word ptr i
	mov		si,word ptr s1
	mov		al,byte ptr [bx+si]
	mov		byte ptr c1,al
	mov		si,word ptr s2
	mov		al,byte ptr [bx+si]
	mov		byte ptr c2,al
	inc		word ptr k
	jmp		L$2
L$7:
	mov		al,byte ptr c2
	cmp		byte ptr c1,al
	jne		L$8
	sub		ax,ax
	jmp		L$9
$8:
	mov		al,byte ptr c2
	cmp		byte ptr c1,al
	ja		L$3
	jmp		L$5
L$9:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$10:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 63H, 6dH
    DB	70H, 69H, 2eH, 63H, 9, 31H, 2eH, 31H
    DB	20H, 38H, 36H, 2fH, 30H, 36H, 2fH, 31H
    DB	37H, 0
    DW	offset DGROUP:L$10

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
