.387
		PUBLIC	_rctomid
		EXTRN	__chkstk:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_rctomid:
	push		bp
	mov		bp,sp
	xor		ax,ax
	call		near ptr __chkstk
	mov		ax,word ptr 4[bp]
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$1:
    DB	40H, 28H, 23H, 29H, 72H, 63H, 74H, 6fH
    DB	6dH, 69H, 64H, 2eH, 63H, 9, 35H, 2eH
    DB	31H, 20H, 38H, 36H, 2fH, 30H, 35H, 2fH
    DB	31H, 33H, 0, 0
    DW	offset DGROUP:L$1

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
