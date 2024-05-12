.387
		PUBLIC	_com_settbl
		PUBLIC	_check_dbcs
		EXTRN	__chkstk:BYTE
		EXTRN	_malloc:BYTE
		EXTRN	_casemap_lo:BYTE
		EXTRN	_casemap_up:BYTE
		EXTRN	_dbcsvec:BYTE
		EXTRN	DOSGETDBCSEV:BYTE
		EXTRN	DOSCASEMAP:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_com_settbl:
	push		bp
	mov		bp,sp
	mov		ax,0aH
	call		near ptr __chkstk
	push		si
	sub		ax,ax
	mov		word ptr -2[bp],ax
	mov		word ptr countrycode,ax
	cmp		word ptr DGROUP:L$13,1
	jne		L$2
L$1:
	sub		ax,ax
	jmp		near ptr L$8
L$2:
	mov		ax,100H
	push		ax
	call		near ptr _malloc
	add		sp,2
	mov		word ptr _casemap_lo,ax
	mov		ax,100H
	push		ax
	call		near ptr _malloc
	add		sp,2
	mov		word ptr _casemap_up,ax
	mov		ax,5
	push		ax
	lea		ax,countrycode
	push		ss
	push		ax
	mov		ax,offset _dbcsvec
	push		ds
	push		ax
	call		far ptr DOSGETDBCSEV
	mov		word ptr error,ax
	or		ax,ax
	je		L$4
L$3:
	mov		ax,word ptr error
	jmp		L$8
L$4:
	mov		word ptr i,0
L$5:
	mov		bx,word ptr i
	mov		si,word ptr _casemap_lo
	mov		al,byte ptr i
	mov		byte ptr [bx+si],al
	mov		bx,word ptr i
	mov		si,word ptr _casemap_up
	mov		al,byte ptr i
	mov		byte ptr [bx+si],al
	inc		word ptr i
	cmp		word ptr i,100H
	jl		L$5
	mov		ax,100H
	push		ax
	lea		ax,countrycode
	push		ss
	push		ax
	mov		ax,word ptr _casemap_up
	push		ds
	push		ax
	call		far ptr DOSCASEMAP
	mov		word ptr error,ax
	or		ax,ax
	jne		L$3
	mov		ax,word ptr _casemap_up
	mov		word ptr -8[bp],ax
	mov		word ptr i,0
L$6:
	mov		bx,word ptr -8[bp]
	mov		al,byte ptr [bx]
	sub		ah,ah
	mov		si,ax
	cmp		word ptr i,si
	je		L$7
	mov		bx,word ptr _casemap_lo
	mov		al,byte ptr i
	mov		byte ptr [bx+si],al
L$7:
	inc		word ptr i
	inc		word ptr -8[bp]
	cmp		word ptr i,100H
	jl		L$6
	mov		word ptr DGROUP:L$13,1
	jmp		near ptr L$1
L$8:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_check_dbcs:
	push		bp
	mov		bp,sp
	mov		ax,2
	call		near ptr __chkstk
	push		si
	mov		word ptr i,0
L$9:
	mov		si,word ptr i
	shl		si,1
	cmp		byte ptr _dbcsvec[si].stop,0
	jne		L$10
	cmp		byte ptr _dbcsvec+1[si].start,0
	jne		L$10
	sub		ax,ax
	jmp		L$12
L$10:
	mov		si,word ptr i
	shl		si,1
	mov		al,byte ptr 4[bp]
	cmp		byte ptr _dbcsvec[si].stop,al                
	ja		L$11
	cmp		byte ptr _dbcsvec+1[si].start,al
	jb		L$11
	mov		ax,1
	jmp		L$12
L$11:
	inc		word ptr i
	cmp		word ptr i,5
	jb		L$9
	mov		ax,0ffffH
L$12:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$13:
    DB	0, 0

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
