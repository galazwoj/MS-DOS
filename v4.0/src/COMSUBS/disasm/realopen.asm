COMMENT %
/*
 *  open drive in real mode
 */
extern unsigned far pascal REALOPEN(
	char far *,	   /* pointer to drive name */
	unsigned far *,    /* pointer to drive handle */
	unsigned);	   /* open mode */
%

.387
		PUBLIC	REALOPEN
_TEXT		SEGMENT	PARA PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
REALOPEN:
	push		bp
	mov		bp,sp
	push		ds
	push		bx
	push		cx
	push		dx
	mov		ah,63H
	mov		cx,word ptr 6[bp]
	lds		dx,dword ptr 0cH[bp]
	int		21H
	jb		L$1
	lds		bx,dword ptr 8[bp]
	mov		word ptr [bx],ax
	xor		ax,ax
L$1:
	pop		dx
	pop		cx
	pop		bx
	pop		ds
	pop		bp
	retf		0aH
_TEXT		ENDS
		END
