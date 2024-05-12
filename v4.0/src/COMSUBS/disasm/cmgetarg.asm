.387
		PUBLIC	_comgetarg
		PUBLIC	_checkdrive
		PUBLIC	_setnewargv
		PUBLIC	_cm_invalid_parm_pointer
		PUBLIC	_checking_state
		PUBLIC	_syntax_error_flag
		PUBLIC	_drive_error_flag
		PUBLIC	_invalid_parm_flag
		PUBLIC	_previous_char
		PUBLIC	_current_char
		EXTRN	__chkstk:BYTE
		EXTRN	_com_strcmpi:BYTE
		EXTRN	_comcheckdosver:BYTE
		EXTRN	_drivenumber:BYTE
		EXTRN	_logicaldrivenumber:BYTE
		EXTRN	DOSQCURDISK:BYTE
		EXTRN	_argcharbf_ptr:BYTE
		EXTRN	_newargv_ptr:BYTE
		EXTRN	_newargc_ctr:BYTE
		EXTRN	_com_strupr:BYTE
		EXTRN	__alshl:BYTE
		EXTRN	_startarg_ptr:BYTE
		EXTRN	__acrtused:BYTE
DGROUP		GROUP	CONST,_BSS,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
_comgetarg:
	push		bp
	mov		bp,sp
	mov		ax,8
	call		near ptr __chkstk
	push		di
	push		si
	mov		word ptr trace,0
	mov		byte ptr DGROUP:_syntax_error_flag,0
	mov		byte ptr DGROUP:_drive_error_flag,0
	mov		bx,word ptr switch_char
	mov		byte ptr [bx],2fH
	mov		ax,offset DGROUP:L$42
	push		ax
	mov		bx,word ptr arg_array
	push		word ptr [bx]
	call		near ptr _com_strcmpi
	add		sp,4
	or		ax,ax
	jne		L$1
	mov		word ptr trace,1
L$1:
	call		near ptr _comcheckdosver
	mov		word ptr result,ax
	or		ax,ax
	je		L$3
L$2:
	mov		ax,word ptr result
	jmp		near ptr L$35
L$3:
	mov		ax,offset _drivenumber
	push		ds
	push		ax
	mov		ax,offset _logicaldrivenumber
	push		ds
	push		ax
	call		far ptr DOSQCURDISK
	mov		word ptr result,ax
	or		ax,ax
	jne		L$2
	mov		bx,word ptr drive_name
	mov		al,byte ptr _drivenumber
	add		al,40H
	mov		byte ptr [bx],al
	mov		word ptr iii,1
	mov		word ptr jjj,0
L$4:
	mov		bx,word ptr arg_num
	mov		ax,word ptr iii
	cmp		word ptr [bx],ax
	ja		L$5
	jmp		near ptr L$31
$5:
	mov		ax,word ptr arg_buf_size
	dec		ax
	dec		ax
	cmp		ax,word ptr _argcharbf_ptr
	jbe		L$6
	mov		ax,word ptr arg_array_depth
	dec		ax
	dec		ax
	cmp		ax,word ptr _newargv_ptr
	ja		L$7
$6:
	mov		ax,800fH
	jmp		near ptr L$35
L$7:
	mov		si,word ptr jjj
	inc		word ptr jjj
	mov		bx,word ptr iii
	shl		bx,1
	mov		di,word ptr arg_array
	mov		bx,word ptr [bx+di]
	mov		al,byte ptr [bx+si]
	mov		byte ptr DGROUP:_current_char,al
	cbw
	or		ax,ax
	jne		L$8
	jmp		near ptr L$21
L$8:
	cmp		ax,20H
	jne		L$9
	jmp		near ptr L$22
L$9:
	cmp		ax,2cH
	jne		L$10
	jmp		near ptr L$24
L$10:
	cmp		ax,3aH
	jne		L$11
	cmp		word ptr trace,1
	jne		L$17
L$11:	
	mov		bx,word ptr switch_char
	mov		al,byte ptr DGROUP:_current_char
	cmp		byte ptr [bx],al
	je		L$12
	jmp		near ptr L$28
L$12:
	cmp		word ptr trace,0
	je		L$13
	jmp		near ptr L$28
L$13:
	mov		al,byte ptr DGROUP:_checking_state
	cbw
	or		ax,ax
	jne		L$14
	jmp		near ptr L$27
L$14:
	cmp		ax,1
	jl		L$23
	cmp		ax,2
	jg		L$15
	jmp		near ptr L$26
L$15:
	cmp		ax,3
	jne		L$16
	jmp		near ptr L$25
L$16:
	jmp		L$23
L$17:
	mov		si,word ptr _argcharbf_ptr
	inc		word ptr _argcharbf_ptr
	mov		bx,word ptr arg_buffer
	mov		al,byte ptr DGROUP:_current_char
	mov		byte ptr [bx+si],al
	mov		al,byte ptr DGROUP:_checking_state
	cbw
	or		ax,ax
	je		L$20
	cmp		ax,1
	je		L$18
	cmp		ax,2
	jl		L$23
	cmp		ax,3
	jle		L$20
	jmp		L$23
L$18:
	mov		al,byte ptr DGROUP:_previous_char
	cbw
	push		ax
	call		near ptr _checkdrive
	add		sp,2
	or		ax,ax
	je		L$19
	mov		byte ptr DGROUP:_drive_error_flag,1
L$19:
	push		word ptr arg_buffer
	push		word ptr arg_array
	call		near ptr _setnewargv
	add		sp,4
	jmp		L$23
L$20:
	mov		byte ptr DGROUP:_syntax_error_flag,1
	jmp		L$19
L$21:
	inc		word ptr iii
	mov		word ptr jjj,0
L$22:
	cmp		byte ptr DGROUP:_checking_state,3
	jne		L$24
L$23:
	mov		al,byte ptr DGROUP:_current_char
	mov		byte ptr DGROUP:_previous_char,al
	jmp		near ptr L$4
$24:
	mov		al,byte ptr DGROUP:_checking_state
	cbw
	or		ax,ax
	je		L$23
	cmp		ax,1
	jl		L$23
	cmp		ax,2
	jle		L$19
	cmp		ax,3
	jne		L$23
L$25:
	mov		byte ptr DGROUP:_syntax_error_flag,1
	mov		si,word ptr _argcharbf_ptr
	inc		word ptr _argcharbf_ptr
	mov		bx,word ptr arg_buffer
	mov		al,byte ptr DGROUP:_current_char
	mov		byte ptr [bx+si],al
	jmp		L$19
L$26:
	push		word ptr arg_buffer
	push		word ptr arg_array
	call		near ptr _setnewargv
	add		sp,4
L$27:
	mov		si,word ptr _argcharbf_ptr
	inc		word ptr _argcharbf_ptr
	mov		bx,word ptr arg_buffer
	mov		al,byte ptr DGROUP:_current_char
	mov		byte ptr [bx+si],al
	mov		byte ptr DGROUP:_checking_state,3
	jmp		L$23
L$28:
	mov		si,word ptr _argcharbf_ptr
	inc		word ptr _argcharbf_ptr
	mov		bx,word ptr arg_buffer
	mov		al,byte ptr DGROUP:_current_char
	mov		byte ptr [bx+si],al
	mov		al,byte ptr DGROUP:_checking_state
	cbw
	or		ax,ax
	je		L$29
	cmp		ax,1
	je		L$30
	cmp		ax,2
	je		L$23
	cmp		ax,3
	je		L$30
	jmp		near ptr L$23
L$29:
	mov		byte ptr DGROUP:_checking_state,1
	jmp		near ptr L$23
$30:
	mov		byte ptr DGROUP:_checking_state,2
	jmp		near ptr L$23
L$31:
	cmp		byte ptr DGROUP:_checking_state,3
	jne		L$32
	push		word ptr arg_buffer
	push		word ptr arg_array
	call		near ptr _setnewargv
	add		sp,4
L$32:
	mov		bx,word ptr arg_num
	mov		ax,word ptr _newargc_ctr
	mov		word ptr [bx],ax
	cmp		byte ptr DGROUP:_syntax_error_flag,0
	je		L$33
	mov		ax,57H
	jmp		L$35
L$33:
	cmp		byte ptr DGROUP:_drive_error_flag,0
	je		L$34
	mov		ax,0fH
	jmp		L$35
L$34:
	sub		ax,ax	return 0
L$35:
	pop		si
	pop		di
	mov		sp,bp
	pop		bp
	ret
_checkdrive:
	push		bp
	mov		bp,sp
	mov		ax,6
	call		near ptr __chkstk
	mov		byte ptr -5[bp],0
	mov		al,byte ptr 4[bp]
	mov		byte ptr -6[bp],al
	lea		ax,-6[bp]
	push		ax
	call		near ptr _com_strupr
	add		sp,2
	mov		al,byte ptr -6[bp]
	mov		byte ptr 4[bp],al
	cmp		al,41H
	jl		L$36
	cmp		al,5aH
	jle		L$37
L$36:
	mov		ax,0fH
	jmp		L$38
$37:
	sub		byte ptr 4[bp],41H
	mov		word ptr -4[bp],1
	mov		word ptr -2[bp],0
	mov		al,byte ptr 4[bp]
	cbw
	push		ax
	lea		ax,-4[bp]
	push		ax
	call		near ptr __alshl
	mov		ax,word ptr _logicaldrivenumber
	mov		dx,word ptr _logicaldrivenumber+2
	and		word ptr -4[bp],ax
	and		word ptr -2[bp],dx
	mov		ax,word ptr -4[bp]
	or		ax,word ptr -2[bp]
	je		L$36
	sub		ax,ax
L$38:
	mov		sp,bp
	pop		bp
	ret
setnewargv:
	push		bp
	mov		bp,sp
	xor		ax,ax
	call		near ptr __chkstk
	push		si
	cmp		byte ptr DGROUP:_invalid_parm_flag,0
	jne		L$40
	cmp		byte ptr DGROUP:_syntax_error_flag,0
	jne		L$39
	cmp		byte ptr DGROUP:_drive_error_flag,0
	je		L$40
,$39:
	mov		ax,word ptr _newargc_ctr
	mov		word ptr DGROUP:_cm_invalid_parm_pointer,ax
	mov		byte ptr DGROUP:_invalid_parm_flag,1
$40:
	mov		si,word ptr _argcharbf_ptr
	inc		word ptr _argcharbf_ptr
	mov		bx,word ptr 6[bp]
	mov		byte ptr [bx+si],0
	inc		word ptr _newargc_ctr
	mov		byte ptr DGROUP:_checking_state,0
	mov		si,word ptr _newargv_ptr
	inc		word ptr _newargv_ptr
	shl		si,1
	mov		bx,word ptr 4[bp]
	mov		ax,word ptr 6[bp]
	add		ax,word ptr _startarg_ptr
	mov		word ptr [bx+si],ax
	mov		ax,word ptr _argcharbf_ptr
	mov		word ptr _startarg_ptr,ax
	pop		si
	mov		sp,bp
	pop		bp
	ret
_TEXT		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
L$41:
    DB	40H, 28H, 23H, 29H, 63H, 6dH, 67H, 65H
    DB	74H, 61H, 72H, 67H, 2eH, 63H, 9, 38H
    DB	2eH, 31H, 20H, 38H, 36H, 2fH, 30H, 39H
    DB	2fH, 31H, 39H, 0
L$42:
	t    r     a   c  e
    DB	74H, 72H, 61H, 63H, 65H, 0
    DW	offset DGROUP:L$41
_cm_invalid_parm_pointer:
    DB	0, 0
_checking_state:
    DB	0
_syntax_error_flag:
    DB	0
_drive_error_flag:
    DB	0
_invalid_parm_flag:
    DB	0
_previous_char:
    DB	2cH
_current_char:
    DB	2cH

_DATA		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'CONST'
CONST		ENDS
_BSS		SEGMENT	WORD PUBLIC USE16 'BSS'
_BSS		ENDS

		END
