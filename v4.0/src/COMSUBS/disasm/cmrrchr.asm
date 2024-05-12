.387
		PUBLIC	_com_strrchr
		EXTRN	__chkstk:BYTE
		EXTRN	_com_settbl:BYTE
		EXTRN	_strlen:BYTE
		EXTRN	_check_dbcs:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_com_strrchr:
	push		bp
	mov		bp,sp
	mov		ax,0eH
	call		near ptr __chkstk
	push		si
	mov		bx,word ptr pcc
	mov		al,byte ptr c
	mov		byte ptr [bx],al
	call		near ptr _com_settbl
	push		word ptr s
	call		near ptr _strlen
	add		sp,2
	mov		word ptr n,ax
	push		word ptr pcc
	call		near ptr _strlen
	add		sp,2
	mov		word ptr nn,ax
	mov		ax,word ptr n
	cmp		word ptr nn,ax
	jle		L$2
L$1:
	sub		ax,ax
	jmp		near ptr L$9
L$2:
	mov		ax,word ptr n
	sub		ax,word ptr nn
	mov		word ptr nnn,ax
	mov		word ptr i,0
l$3:
	cmp		word ptr nnn,0
	jl		L$1
	mov		si,word ptr nnn
	add		si,word ptr s
	mov		bx,word ptr pcc
	mov		al,byte ptr [si]
	cmp		byte ptr [bx],al
	jne		L$8
z1	cmp		word ptr nnn,0
	je		L$4
	cmp		word ptr nnn,0
	je		L$8
	mov		al,byte ptr -1[si]
	sub		ah,ah
	push		ax
	call		near ptr _check_dbcs
	add		sp,2
	cmp		ax,1
	je		L$8
L$4:
	mov		ax,word ptr nnn
	mov		word ptr saved_nnn,ax
	mov		ax,word ptr i
	mov		word ptr saved_i,ax
	mov		ax,word ptr nn
	mov		word ptr saved_nn,ax
	jmp		L$6
l$5:
	mov		bx,word ptr saved_i
	mov		si,word ptr pcc
	mov		al,byte ptr [bx+si]
	mov		bx,word ptr saved_nnn
	mov		si,word ptr s
	cmp		byte ptr [bx+si],al
	jne		L$7
	dec		word ptr saved_nn
	mov		ax,bx
	inc		word ptr saved_nnn
	inc		word ptr saved_i
L$6:
	cmp		word ptr saved_nn,0
	jg		L$5
l$7:
	cmp		word ptr saved_nn,0
	jne		L$8
	mov		ax,word ptr nnn
	add		ax,word ptr s
	jmp		L$9
l$8:
	mov		word ptr i,0
	dec		word ptr nnn
	jmp		near ptr L$3
L$9:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$10:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 72H, 72H
    DB	63H, 68H, 72H, 2eH, 63H, 9, 31H, 2eH
    DB	31H, 20H, 38H, 36H, 2fH, 30H, 36H, 2fH
    DB	31H, 37H, 0
cc:
    DB	20H, 0, 0
    DW	offset DGROUP:L$10
pcc:
    DW	offset cc

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END













