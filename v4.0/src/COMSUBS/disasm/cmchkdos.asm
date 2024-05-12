.387
		PUBLIC	_comcheckdosver
		EXTRN	__chkstk:BYTE
		EXTRN	DOSGETVERSION:BYTE
		EXTRN	_com_settbl:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_comcheckdosver:
	push		bp
	mov		bp,sp
	mov		ax,4
	call		near ptr __chkstk
	lea		ax,-4[bp]
	push		ss
	push		ax
	call		far ptr DOSGETVERSION
	mov		word ptr -2[bp],ax
	or		ax,ax
	je		L$2
L$1:
	mov		ax,word ptr -2[bp]
	jmp		L$4
L$2:
	cmp		word ptr -4[bp],500H
	je		L$3
	mov		ax,3e8H
	jmp		L$4
L$3:
	call		near ptr _com_settbl
	mov		word ptr -2[bp],ax
	or		ax,ax
	jne		L$1
	sub		ax,ax
L$4:
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$5:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 63H, 68H
    DB	6bH, 64H, 6fH, 73H, 2eH, 63H, 9, 38H
    DB	2eH, 31H, 20H, 38H, 36H, 2fH, 30H, 39H
    DB	2fH, 31H, 39H, 0
    DW	offset DGROUP:L$5

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
