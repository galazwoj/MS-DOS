.387
		PUBLIC	_computmsg
		PUBLIC	_getmessage
		PUBLIC	_msg_buf_size
		PUBLIC	_init_req
		PUBLIC	_cm_flhandle_enable_sw
		EXTRN	__chkstk:BYTE
		EXTRN	__iob:BYTE
		EXTRN	_setbuf:BYTE
		EXTRN	_malloc:BYTE
		EXTRN	_msg_buf:BYTE
		EXTRN	_kbdstatus:BYTE
		EXTRN	_ignore_req:BYTE
		EXTRN	_com_strupr:BYTE
		EXTRN	_respchar:BYTE
		EXTRN	_msglength:BYTE
		EXTRN	DOSPUTMESSAGE:BYTE
		EXTRN	KBDFLUSHBUFFER:BYTE
		EXTRN	_fgets:BYTE
		EXTRN	_strlen:BYTE
		EXTRN	_strncpy:BYTE
		EXTRN	_kbhit:BYTE
		EXTRN	__flsbuf:BYTE
		EXTRN	_ivtable_far:BYTE
		EXTRN	DOSGETMESSAGE:BYTE
		EXTRN	_realloc:BYTE
		EXTRN	_keybuf:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_computmsg:
	push		bp
	mov		bp,sp
	mov		ax,0faH
	call		near ptr __chkstk
	push		si
	sub		ax,ax
	push		ax
	mov		ax,offset __iob+8
	push		ax
	call		near ptr _setbuf
	add		sp,4
	cmp		byte ptr DGROUP:_cm_flhandle_enable_sw,0
	jne		L$2
	cmp		word ptr 0cH[bp],0
	jne		L$1
	mov		word ptr 0cH[bp],1
	jmp		L$2
L$1:
	mov		word ptr 0cH[bp],2
L$2:
	cmp		word ptr DGROUP:_init_req,1
	je		L$3
	jmp		near ptr L$11
L$3:
	push		word ptr DGROUP:_msg_buf_size
	call		near ptr _malloc
	add		sp,2
	mov		word ptr _msg_buf,ax
	or		ax,ax
	je		L$4
	mov		ax,0aH
	push		ax
	call		near ptr _malloc
	add		sp,2
	mov		word ptr _kbdstatus,ax
	or		ax,ax
	jne		L$5
L$4:
	mov		ax,8
	jmp		near ptr L$34
L$5:
	push		word ptr _msg_buf
	mov		ax,offset DGROUP:L$43
	push		ax
	sub		ax,ax
	push		ax
	push		ax
	push		word ptr 4[bp]
	call		near ptr _getmessage
	add		sp,0aH
	mov		word ptr -4[bp],ax
	or		ax,ax
	je		L$8
L$6:
	cmp		byte ptr _ignore_req,1
	je		L$7
	jmp		near ptr L$25
L$7:
	sub		ax,ax
	jmp		near ptr L$34
L$8:
	push		word ptr _msg_buf
	call		near ptr _com_strupr
	add		sp,2
	sub		ax,ax
	mov		word ptr -8[bp],ax
	mov		word ptr -6[bp],ax
	jmp		L$10
L$9:
	mov		bx,word ptr -8[bp]
	mov		si,word ptr _msg_buf
	mov		al,byte ptr [bx+si]
	mov		bx,word ptr -6[bp]
	mov		byte ptr _respchar[bx],al
	inc		word ptr -6[bp]
	add		word ptr -8[bp],2
L$10:
	cmp		word ptr -6[bp],5
	jl		L$9
	mov		word ptr DGROUP:_init_req,0
L$11:
	push		word ptr _msg_buf
	push		word ptr 0aH[bp]
	push		word ptr 8[bp]
	push		word ptr 6[bp]
	push		word ptr 4[bp]
	call		near ptr _getmessage
	add		sp,0aH
	mov		word ptr -4[bp],ax
	or		ax,ax
	jne		L$6
	push		word ptr 0cH[bp]
	push		word ptr _msglength
	mov		ax,word ptr _msg_buf
	push		ds
	push		ax
	call		far ptr DOSPUTMESSAGE
	mov		word ptr -4[bp],ax
	or		ax,ax
	je		L$12
	jmp		near ptr L$25
L$12:
	cmp		word ptr 0eH[bp],0
	je		L$13
	sub		ax,ax
	push		ax
	call		far ptr KBDFLUSHBUFFER
	mov		word ptr -4[bp],ax
	or		ax,ax
	je		L$13
	jmp		near ptr L$25
L$13:
	mov		ax,word ptr 0eH[bp]
	or		ax,ax
	jne		L$14
	jmp		near ptr L$7
L$14:
	cmp		ax,1
	je		L$17
	cmp		ax,2
	je		L$18
	cmp		ax,3
	jne		L$15
	jmp		near ptr L$26
L$15:
	cmp		ax,4
	jne		L$16
	jmp		near ptr L$27
L$16:
	cmp		ax,5
	je		L$18
	jmp		near ptr L$33
L$17:
	mov		ax,offset __iob
	push		ax
	mov		ax,0f1H
	push		ax
	lea		ax,-0faH[bp]
	push		ax
	call		near ptr _fgets
	add		sp,6
	jmp		near ptr L$7
L$18:
	sub		ax,ax
	push		ax
	call		far ptr KBDFLUSHBUFFER
	mov		word ptr -4[bp],ax
	or		ax,ax
	je		L$19
	jmp		near ptr L$25
L$19:
	mov		ax,offset __iob
	push		ax
	mov		ax,0f1H
	push		ax
	lea		ax,-0faH[bp]
	push		ax
	call		near ptr _fgets
	add		sp,6
	lea		ax,-0faH[bp]
	push		ax
	call		near ptr _com_strupr
	add		sp,2
	cmp		word ptr 0eH[bp],2
	jne		L$21
	mov		al,byte ptr _respchar
	cmp		byte ptr -0faH[bp],al
	jne		L$20
	mov		bx,word ptr 10H[bp]
	mov		byte ptr [bx],0
	jmp		near ptr L$7
L$20:
	mov		al,byte ptr _respchar+1
	cmp		byte ptr -0faH[bp],al
	jne		L$24
	mov		bx,word ptr 10H[bp]
	mov		byte ptr [bx],1
	jmp		near ptr L$7
L$21:
	mov		al,byte ptr _respchar+2
	cmp		byte ptr -0faH[bp],al
	jne		L$22
	mov		bx,word ptr 10H[bp]
	mov		byte ptr [bx],2
	jmp		near ptr L$7
L$22:
	mov		al,byte ptr _respchar+3
	cmp		byte ptr -0faH[bp],al
	jne		L$23
	mov		bx,word ptr 10H[bp]
	mov		byte ptr [bx],3
	jmp		near ptr L$7
L$23:
	mov		al,byte ptr _respchar+4
	cmp		byte ptr -0faH[bp],al
	jne		L$24
	mov		bx,word ptr 10H[bp]
	mov		byte ptr [bx],4
	jmp		near ptr L$7
L$24:
	push		word ptr 0cH[bp]
	push		word ptr _msglength
	mov		ax,word ptr _msg_buf
	push		ds
	push		ax
	call		far ptr DOSPUTMESSAGE
	mov		word ptr -4[bp],ax
	or		ax,ax
	jne		L$25
	jmp		near ptr L$18
L$25:
	mov		ax,word ptr -4[bp]
	jmp		near ptr L$34
L$26:
	mov		ax,offset __iob
	push		ax
	mov		ax,0f1H
	push		ax
	lea		ax,-0faH[bp]
	push		ax
	call		near ptr _fgets
	add		sp,6
	lea		ax,-0faH[bp]
	push		ax
	call		near ptr _strlen
	add		sp,2
	mov		si,ax
	mov		byte ptr -0fbH[bp+si],0
	push		word ptr 12H[bp]
	lea		ax,-0faH[bp]
	push		ax
	push		word ptr 10H[bp]
	call		near ptr _strncpy
	add		sp,6
	mov		si,word ptr 12H[bp]
	mov		bx,word ptr 10H[bp]
	mov		byte ptr -1[bx+si],0
	jmp		near ptr L$7
L$27:
	call		near ptr _kbhit
	or		ax,ax
	je		L$27
	sub		ax,ax
	push		ax
	call		far ptr KBDFLUSHBUFFER
	mov		word ptr -4[bp],ax
	or		ax,ax
	jne		L$25
	cmp		word ptr 0cH[bp],0
	je		L$30
	dec		word ptr __iob+12H
	cmp		word ptr __iob+12H,0
	jl		L$28
	mov		al,0aH
	mov		bx,word ptr __iob+10H
	inc		word ptr __iob+10H
	jmp		L$31
L$28:
	mov		ax,offset __iob+10H
L$29:
	push		ax
	mov		ax,0aH
	push		ax
	call		near ptr __flsbuf
	add		sp,4
	jmp		near ptr L$7
L$30:
	dec		word ptr __iob+0aH
	cmp		word ptr __iob+0aH,0
	jl		L$32
	mov		al,0aH
	mov		bx,word ptr __iob+8
	inc		word ptr __iob+8
L$31:
	mov		byte ptr [bx],al
	sub		ah,ah
	jmp		near ptr L$7
L$32:
	mov		ax,offset __iob+8
	jmp		L$29
L$33:
	mov		ax,57H
L$34:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_getmessage:
	push		bp
	mov		bp,sp
	mov		ax,4
	call		near ptr __chkstk
	push		si
	mov		word ptr -4[bp],0
	jmp		L$36
L$35:
	cmp		word ptr -4[bp],9
	jae		L$37
	mov		bx,word ptr -4[bp]
	shl		bx,1
	mov		si,word ptr 4[bp]
	mov		ax,word ptr [bx+si]
	mov		bx,word ptr -4[bp]
	shl		bx,1
	shl		bx,1
	mov		word ptr _ivtable_far[bx],ax
	mov		word ptr _ivtable_far+2[bx],ds
	inc		word ptr -4[bp]
L$36:
	mov		ax,word ptr 6[bp]
	cmp		word ptr -4[bp],ax
	jb		L$35
L$37:
	mov		ax,offset _ivtable_far
	push		ds
	push		ax
	push		word ptr 6[bp]
	mov		ax,word ptr _msg_buf
	push		ds
	push		ax
	push		word ptr DGROUP:_msg_buf_size
	push		word ptr 8[bp]
	mov		ax,word ptr 0aH[bp]
	push		ds
	push		ax
	mov		ax,offset _msglength
	push		ds
	push		ax
	call		far ptr DOSGETMESSAGE
	mov		word ptr -2[bp],ax
	or		ax,ax
	je		L$39
	mov		byte ptr _ignore_req,0
	cmp		ax,13cH
	je		L$38
	mov		ax,2
	push		ax
	push		word ptr _msglength
	mov		ax,word ptr _msg_buf
	push		ds
	push		ax
	call		far ptr DOSPUTMESSAGE
	mov		word ptr -4[bp],ax
	or		ax,ax
	je		L$40
	jmp		L$41
L$38:
	add		word ptr DGROUP:_msg_buf_size,0c8H
	push		word ptr DGROUP:_msg_buf_size
	push		word ptr _msg_buf
	call		near ptr _realloc
	add		sp,4
	mov		word ptr _msg_buf,ax
	or		ax,ax
	jne		L$37
	mov		ax,8
	jmp		L$41
L$39:
	mov		bx,word ptr _msglength
	mov		si,word ptr _msg_buf
	mov		byte ptr [bx+si],0
L$40:
	mov		ax,word ptr -2[bp]
L$41:
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$42:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 70H, 75H
    DB	74H, 6dH, 73H, 67H, 2eH, 63H, 9, 38H
    DB	2eH, 31H, 20H, 38H, 36H, 2fH, 30H, 39H
    DB	2fH, 31H, 39H, 0
L$43:
    DB	4fH, 53H, 4fH, 30H, 30H, 31H, 2eH, 4dH
    DB	53H, 47H, 0, 0
    DW	offset DGROUP:L$42
_msg_buf_size:
    DB	0c8H, 0
_init_req:
    DB	1, 0
_cm_flhandle_enable_sw:
    DB	0

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
