#include "_comsubs.h"
#include <conio.h>

#define NO_ERROR			  0   
#define ERROR_FILE_NOT_FOUND              2   
#define ERROR_FILENAME_EXCED_RANGE      206 
#define ERROR_MR_MSG_TOO_LONG           316 
#define ERROR_MR_MID_NOT_FOUND          317 
#define ERROR_MR_UN_ACC_MSGF            318 
#define ERROR_MR_INV_MSFG_FORMAT        319 
#define ERROR_MR_INV_IVCOUNT            320 
#define ERROR_MR_UN_PERFORM             321 

extern char far * far *ivtable_far;
extern unsigned char *msg_buf;
extern unsigned char *respchar;
extern unsigned char *kbdstatus;
extern unsigned msglength;
extern char ignore_req;
static unsigned char local_msg_filename[] = "OSO001.MSG";

extern unsigned far pascal KBDFLUSHBUFFER(unsigned n);
int init_req = 1;
int msg_buf_size = 0xc8;
char cm_flhandle_enable_sw = 0;

#define STDIN  0
#define STDOUT 1
#define STDERR 2
#define STDAUX 3
#define STDPRN 4
#define STDXXX 5 

static unsigned getmessage(
	char **  msg_table,
  	unsigned msg_num,
	unsigned msg_id,
	char *   msg_filename,
	char *   msg_buf_xxx);

/*
 * print a message and get a response
 */

unsigned computmsg (
/*4*/	char **  msg_table,	   	/* table of variables  to insert	  */
/*6*/	unsigned msg_num,	   	/* number of variables to insert	  */
/*8*/	unsigned msg_id,	   	/* message id			  */
/*0a*/	char *   msg_filename, 		/* message file name 		  */
/*0c*/	unsigned output_device,		/* output device type		  */
/*0e*/	unsigned response_type,		/* response type			  */
/*10*/	char *   response_data, 	/* response data area		  */
/*12*/	unsigned response_size)	   	/* size of response data area	  */

{    
/* 4*/	int result;
/* 6*/	int i;
/* 8*/	int j;
/*fa*/  char buffer[242];

	setbuf(stdout, _IOFBF);
	if(!cm_flhandle_enable_sw) 
		output_device = (output_device == STDIN) ? STDOUT : STDERR;

	if (init_req) {
		if (!(msg_buf = malloc(msg_buf_size)) || !(kbdstatus = malloc(10)))
			return 8;
		if ((result = getmessage(msg_table,0, 0, local_msg_filename, msg_buf)))
			return (ignore_req == 1) ? 0 : result;
		com_strupr(msg_buf);
		for (j = 0, i = 0; i < 5; i++, j++) 
			respchar[i] = msg_buf[j];		
		init_req = FALSE;
	}
	if ((result = getmessage(msg_table, msg_num, msg_id, msg_filename, msg_buf)))
		return (ignore_req == 1) ? 0 : result;
	if ((result = DOSPUTMESSAGE(output_device, msglength, msg_buf)))
		return result;
	if(response_type && (result = KBDFLUSHBUFFER(0)))
		return result;
	switch (response_type)
	{
		case STDIN :
			break;
		case STDOUT:
			fgets(buffer, sizeof buffer, stdin);
			break;
		case STDERR:
		case STDXXX:
			while (1) {
				if ((result = KBDFLUSHBUFFER(0)))
					return result;
				fgets(buffer, sizeof buffer, stdin);			
				com_strupr(buffer);
				if (response_type != 2) {
					if (buffer == respchar +2) {
						*response_data = 2;
						break;
					} else if (buffer == respchar +3) {
						*response_data = 3;
						break;
					} else if (buffer == respchar +4) {
						*response_data = 4;
						break;
					}
				} else {		
					if (buffer == respchar) {
						*response_data = 0;
						break;
					} else if (buffer == respchar +1) {
						*response_data = 1;
						break;
					}
	  			} 
				if ((result = DOSPUTMESSAGE(output_device, msglength, msg_buf)))
					return result;
			}
		case STDAUX:
			fgets(buffer, sizeof buffer, stdin);
			buffer[strlen(buffer) -1] = '\0';
			strncpy(response_data, buffer, response_size);
			response_data[response_size-1] = '\0';
			break;
		case STDPRN:
			while (!kbhit());			//XXX BAD idea
			if ((result = KBDFLUSHBUFFER(0)))
				return result;
			if (output_device == STDIN) 
				putc(0x0a, stdout);		
			else
				putc(0x0a, stderr);			
			break;
		default:
			return 0x57;
	}
	return 0;
}

unsigned getmessage(
/*4*/	char **  msg_table,
/*6*/  	unsigned msg_num,
/*8*/	unsigned msg_id,
/*0a*/	char *   msg_filename,
/*0c*/	char *   msg_buf_xxx)
{
	int error1, error2;
	int i;

	for (i = 0; i < msg_num; i++) {
		if (i >= 9)
			break;		
		ivtable_far[i] = msg_table[i];		
	}

	while (1) {
		error1 = DOSGETMESSAGE(ivtable_far, msg_num, msg_buf, msg_buf_size, msg_id, msg_filename, &msglength);
		if (!error1) {
			msg_buf[msglength] = 0;
			return error1;
		}
		ignore_req = 0;
		if (error1 == ERROR_MR_MSG_TOO_LONG) {
			msg_buf_size += 0xc8;
			msg_buf = realloc(msg_buf, msg_buf_size);
			if(!msg_buf)	
				return 8;
		} else {
			error2 = DOSPUTMESSAGE(STDERR, msglength, msg_buf);
			return (error2) ? error2 : error1;
		}
	}
}
