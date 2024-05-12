#include "_comsubs.h"

extern unsigned long logicaldrivenumber;
extern unsigned char drivenumber;
extern unsigned argcharbf_ptr;
extern unsigned newargv_ptr;
extern unsigned newargc_ctr;
extern unsigned startarg_ptr;

unsigned      cm_invalid_parm_pointer = NULL;
unsigned char checking_state = FALSE;
unsigned char syntax_error_flag = FALSE;
unsigned char drive_error_flag = FALSE;
unsigned char invalid_parm_flag = FALSE;
unsigned char previous_char = ',';
unsigned char current_char = ',';

static void setnewargv (
	char    ** arg_chr_storage,	/* pointer of argument unit character storage */
	char    *  arg_buffer); 	   	/* broken down argument character buffer */

static unsigned long checkdrive(unsigned char drive);

unsigned comgetarg (
/* 4*/	unsigned * arg_num,	   	/* number of arguments		    */
/* 6*/	char    ** arg_array,	   	/* pointer array of original arguments   */
/* 8*/	char    ** arg_chr_storage,	/* pointer of argument unit character storage */
/*0a*/	unsigned   arg_array_depth,	/* depth of new argument pointer array   */
/*0c*/	char    *  arg_buffer, 	   	/* broken down argument character buffer */
/*0e*/	unsigned   arg_buf_size,	/* size of argument character buffer     */
/*10*/	char    *  drive_name, 	   	/* current defualt drive name	    */
/*12*/	char    *  switch_char)   	/* switching character		    */
{
/*-2*/	int result;
/*-4*/	int iii;
/*-6*/	int trace;
/*-8*/	int jjj;	

	trace = FALSE;
	syntax_error_flag = FALSE;
	drive_error_flag = FALSE; 
	*switch_char ='/';
	if (!com_strcmpi(arg_array[0], "trace"))
		trace = TRUE;
	if ((result = comcheckdosver()))
		return result;
	if ((result = DOSQCURDISK(&drivenumber, &logicaldrivenumber)))
		return result;
	*drive_name = drivenumber + 'A' - 1;
	iii = 1;
	jjj = 0;

/* l4*/	while (*arg_num > iii)  {
/* l5*/		if (arg_buf_size -2 <= argcharbf_ptr || arg_array_depth- 2 <= newargv_ptr) 
			return 0x800f;
/* l7*/		current_char = arg_array[iii][jjj++];
		switch (current_char)			
		{
/* l21*/		case 0:
			       	iii++;
				jjj = 0;
/* l22*/		case ' ':
				if (checking_state == 3) 
					break;				
/* l24*/		case ',':				
				if (checking_state == 0 || checking_state  < 1)
					break;
				if (checking_state <= 2) {
					setnewargv(arg_chr_storage, arg_buffer);
					break;
				}
/* l25*/			if (checking_state == 3) {					
					syntax_error_flag = 1;
					arg_buffer[argcharbf_ptr++] = current_char;
					setnewargv(arg_chr_storage, arg_buffer);
					break;
				}
				break;
			case ':':
				if (!trace) {
/* l17*/				arg_buffer[argcharbf_ptr++] = current_char;
					if (checking_state == 0) {
						syntax_error_flag  = 1;
						setnewargv(arg_chr_storage, arg_buffer);
						break;
					}
					if (checking_state == 1) {
						if (checkdrive(previous_char))
							drive_error_flag = 1;
						setnewargv(arg_chr_storage, arg_buffer);
						break;
                                        }
					if (checking_state < 2) 
						break;
					if (checking_state <= 3) {
						syntax_error_flag  = 1;
						setnewargv(arg_chr_storage, arg_buffer);
						break;
					}
					break;
				}
			default:
/* l11*/			if (*switch_char == current_char && !trace) {				
/* l13*/				if (checking_state == 0) {
/* l27*/					arg_buffer[argcharbf_ptr++] = current_char;
						checking_state = 3;	
						break;
					}
					if (checking_state < 1) 						
						break;
					if (checking_state == 2) {
						setnewargv(arg_chr_storage, arg_buffer);
						arg_buffer[argcharbf_ptr++] = current_char;
						checking_state = 3;	
						break;
					}
					if (checking_state == 3) {
						syntax_error_flag = 1;
						arg_buffer[argcharbf_ptr++] = current_char;
						setnewargv(arg_chr_storage, arg_buffer);
						break;
					}
					break;
				}
/* l28*/			arg_buffer[argcharbf_ptr++] = current_char;
				switch (checking_state) 
				{
 					case 0:
						checking_state = 1;
						break;
					case 1:
					case 3:
						checking_state = 2;
						break;
					case 2:
					default:	
						break;
				}		
				break;
		}
/* l23*/	previous_char = current_char;			
	}
/* l31*/
	if (checking_state == 3) 
		setnewargv(arg_chr_storage, arg_buffer);
	*arg_num = newargc_ctr;
	return (syntax_error_flag) ? 0x57 : (drive_error_flag) ? 0xf : 0; 
}


static unsigned long checkdrive(unsigned char drive)
{
/*-4*/	unsigned long l;
/*-6*/	unsigned char d[2];	

	d[1] = '\0';
	d[0] = drive;
	com_strupr(d);
	drive = d[0];
	if (drive >= 'A' && drive <= 'Z') {
		l = (unsigned long)drive << 1;
		return ((unsigned)(logicaldrivenumber & l)) ? 0 : 0xf;	
	} else
		return 0xf;
}

static void setnewargv (
/* 4*/	char    ** arg_chr_storage,	/* pointer of argument unit character storage */
/* 8*/	char    *  arg_buffer) 	   	/* broken down argument character buffer */
{
	if (!invalid_parm_flag && !syntax_error_flag && drive_error_flag) {
 		cm_invalid_parm_pointer = newargc_ctr;
		invalid_parm_flag = TRUE;
	}
	arg_buffer[argcharbf_ptr++] = '\0';
	newargc_ctr++;
	checking_state = 0;
	arg_chr_storage[newargv_ptr++][0] = arg_buffer[startarg_ptr];
	startarg_ptr = argcharbf_ptr;
}

