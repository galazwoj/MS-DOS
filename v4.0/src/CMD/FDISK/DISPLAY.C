

#include "dos.h"                                                        /* AN000 */
#include "fdisk.h"                                                      /* AN000 */
#include "subtype.h"                                                    /* AN000 */
#include "stdio.h"                                                      /* AN000 */
#include "extern.h"                                                     /* AN000 */
#include "doscall.h"                                                    /* AN000 */
#include "fdiskmsg.h"                                                   /* AN000 */
#include "ctype.h"                                                      /* AN000 */

/*  */
/******************* START OF SPECIFICATIONS *******************/
/*                                                             */
/* SUBROUTINE NAME: DISPLAY                                    */
/*                                                             */
/* DESCRIPTIVE NAME: Display full screen interface messages    */
/*                                                             */
/* FUNCTION: Displays messages and handles control characters  */
/*                                                             */
/* NOTES:                                                      */
/*  FDISK MESSAGES                                             */
/* Portions of the screen that are handled in the msg are      */
/* indicated on the listing of the screen with the message     */
/* name given.  If the text message is defined in another      */
/* screen, then the name is followed by a "#" character        */
/*                                                             */
/* NOTE TO TRANSLATORS The characters inside the <> and the [] */
/* are control characters and should not be translated.  The   */
/* Control characters are defined as follows:                  */
/*                                                             */
/* <H> - Highlight the following text                          */
/* <R> - Regular text                                          */
/* <B> - Blink the following text                              */
/* <O> - Turn blinking off                                     */
/* <Y> - Print YES character, as set by define                 */
/* <N> - Print NO character, as set by define                  */
/* <W> - Sound the beep                                        */
/* <S> - Save cursor position for later use                    */
/* <I> - Insert character from insert[] string. This string    */
/*       must be set up prior to displaying the message. The   */
/*       first <I> will insert Insert[0], the second           */
/*       insert[1], etc....This will move the cursor one       */
/*       postition. The insert[] string will be initialized    */
/*                                                             */
/* Multiple control characters can be between the <>.          */
/*                                                             */
/* The ^####^indicates Row and column for the text and has the */
/* format of [rrcc] where the numbers are decimal and zero     */
/* based (first row/col is 00.  The numbers are in decimal,    */
/* and must be 2 characters, which means rows/cols 0-9 should  */
/* be listed as 00-09.  For example, the 5th row, 3rd column   */
/* on the screen would be listed as ^0402^.                    */
/*                                                             */
/* The column number is always the column desired.  The row    */
/* number is an offset from the previous row.  For example, if */
/* the text just printed is on row 6, and the next text should */
/* be printed 2 rows down in column 0, then the control strin  */
/* would be ^0201^.  The first row specified in the message is */
/* assumed to be based off of row 0, it would actually specify */
/* the actual row for the start of the msg to be printed.      */
/*                                                             */
/* ENTRY POINTS: display(*message_name);                       */
/*      LINKAGE: Near call                                     */
/*                                                             */
/* INPUT: char *message_name                                   */
/*                                                             */
/* EXIT-NORMAL:                                                */
/*                                                             */
/* EXIT-ERROR:                                                 */
/*                                                             */
/* EFFECTS:                                                    */
/* input_row changed if <S> control character in message       */
/* input_col changed if <S> control character in message       */
/*                                                             */
/* INTERNAL REFERENCES:                                        */
/*   ROUTINES:                                                 */
/*                                                             */
/* EXTERNAL REFERENCES:                                        */
/*   ROUTINES:                                                 */
/*                                                             */
/* viowrtcharstratt();                                         */
/******************** END OF SPECIFICATIONS ********************/
/*  */
void display(s)

char far *s;

{
        unsigned      row;
        unsigned      col;
        char          attribute;
        char far      *attribute_ptr = &attribute;
        unsigned      insert_count;


        /* Initialize row and col, and index into array */
        row = u(0);                                                     /* AC000 */
        col = u(0);                                                     /* AC000 */
        insert_count = u(0);                                            /* AC000 */
        /* check for a request to display a null string */
        if (*s == c('\0'))                                              /* AC000 */
           {
            /* Message string error */
            insert[0] = c('1');                                         /* AC000 */
            display(debug_msg);
           }
        else
           {
            /* There is data there, lets go handle it */

            attribute = c(0x00);                                        /* AC000 */
            /* Go until end of string */
            while (*s != c('\0'))                                       /* AC000 */
               {

                /* Check for any imbedded control strings */
                switch (*s)
                   {
                    /* Check for control characters */
                    case '<':
                              {
                               s++;
                               while ( (*s != c('>')) && (*s != c('\0')) ) /* AC000 */
                                  {
                                   switch (*s++)
                                      {
                                       case 'H':  if (mono_flag == TRUE)                                 /* AN006 */
                                                      attribute = (attribute & 0x80) | HIWHITE_ON_BLACK; /* AN006 */
                                                  else                                                   /* AN006 */
                                                      attribute = (attribute & 0x80) | HIWHITE_ON_BLUE;  /* AC006 */
                                                  break;


                                       case 'R':  if (mono_flag == TRUE)                                  /* AN006 */
                                                      attribute = (attribute & 0x80) | GRAY_ON_BLACK;     /* AN006 */
                                                  else                                                    /* AN006 */
                                                      attribute = (attribute & 0x80) | WHITE_ON_BLUE;     /* AC006 */
                                                  break;

                                       case 'B': attribute |= 0x80;
                                                 break;

                                       case 'O': attribute &= 0x7F;
                                                 break;

                                       case 'W': DOSBEEP(u(900),u(400)); /* AC000 */
                                                 break;

                                       case 'I':
                                                 {
                                                   /* display next element in the array */
                                                  if ((mono_flag == TRUE) && (attribute == c(0x00)))      /* AN006 */
                                                      attribute = c(GRAY_ON_BLACK);                       /* AN006 */
                                                  if ((mono_flag == FALSE) && (attribute == c(0x00)))     /* AN006 */
                                                      attribute = c(WHITE_ON_BLUE);                       /* AC006 */
                                                  VIOWRTCHARSTRATT(pinsert+insert_count++,u(1),row,col++,attribute_ptr,u(0));
                                                  break;
                                                 }


                                       case 'Y':                                                          /* AC011 */
                                                 {
                                                  /* display YES character in next location */
                                                  *--s = c(Yes);                                          /* AC000 */
                                                  if ((mono_flag == TRUE) && (attribute == c(0x00)))      /* AN006 */
                                                      attribute = c(GRAY_ON_BLACK);                       /* AN006 */
                                                  if ((mono_flag == FALSE) && (attribute == c(0x00)))     /* AN006 */
                                                      attribute = c(WHITE_ON_BLUE);                       /* AC006 */
                                                  VIOWRTCHARSTRATT(s,u(1),row,col++,attribute_ptr,u(0));  /* AC000 */
                                                  *s++ = c(Yes);                                          /* AC000 AC011 */
                                                  break;
                                                 }

                                       case 'N':                                                          /* AC011 */
                                                 {
                                                  /* display NO character in next location */
                                                  *--s = c(No);                                           /* AC000 */
                                                  if ((mono_flag == TRUE) && (attribute == c(0x00)))      /* AN006 */
                                                      attribute = c(GRAY_ON_BLACK);                       /* AN006 */
                                                  if ((mono_flag == FALSE) && (attribute == c(0x00)))     /* AN006 */
                                                      attribute = c(WHITE_ON_BLUE);                       /* AC006 */
                                                  VIOWRTCHARSTRATT(s,u(1),row,col++,attribute_ptr,u(0));  /* AC000 */
                                                  *s++ = c(No);                                           /* AC000 AC011 */
                                                  break;
                                                 }


                                       case 'S':
                                                 {
                                                  input_row = row;
                                                  input_col = col;
                                                  break;
                                                 }


                                       case 'C':
                                                 {
                                                  /* Clear from current position to end of line */
                                                  clear_screen(row,col,row,u(79));                         /* AC000 */
                                                  break;
                                                 }

                                       case '\0':
                                                 {
                                                  /* Message string error - string ended in the middle of control string*/
                                                  insert[0] = c('7');   /* AC000 */
                                                  display(debug_msg);
                                                  break;
                                                 }

                                       default:
                                                 {
                                                  /* Message string error - no valid control char found */
                                                  insert[0] = c('6');   /* AC000 */
                                                  display(debug_msg);
                                                  break;
                                                 }
                                      } /* Switch */
                                  } /* While */
                               /* Get the pointer past the '>' */
                               s++;
                               break;
                              } /* control characters */

                    /* Check for row,col */
                    case '^':                                           /* AC000 */
                              {
                               s++;
                               /* determine the row to put the message on */
                               if ( !isdigit(*s) )
                                  {
                                   /* Message string error */
                                   insert[0] = c('2');                  /* AC000 */
                                   display(debug_msg);
                                  }
                               else
                                  {
                                   row = row+((unsigned)(((*s++ - '0')*10)));
                                   if ( !isdigit(*s) )
                                     {
                                      /* Message string error */
                                      insert[0] = c('2');               /* AC000 */
                                      display(debug_msg);
                                     }
                                   else
                                      {
                                       row = row+((unsigned)(*s++ - '0'));
                                       /* determine the col to put the message on */
                                       if ( !isdigit(*s) )
                                          {
                                           /* Message string error */
                                           insert[0] = c('3');          /* AC000 */
                                           display(debug_msg);
                                          }
                                       else
                                          {
                                           col = ((unsigned)(*s++ - '0'));
                                           if ( !isdigit(*s) )
                                              {
                                               /* Message string error */
                                               insert[0] = c('3');      /* AC000 */
                                               display(debug_msg);
                                              }
                                           else
                                              {
                                               col = ((unsigned)((col* 10) + (*s++ - '0')));
                                               if (*s++ != c('^'))      /* AC000 */
                                                  {
                                                   /* Message string error */
                                                   insert[0] = c('4');  /* AC000 */
                                                   display(debug_msg);
                                                  } /* 2nd sq bracket */
                                              } /* 2nd digit col */
                                          } /* 1st digit col */
                                      } /* 2nd digit row */
                                  } /* 1st digit row */
                               break;
                              }
                    /* Handle anything else */


                    default:
                            {
                             /* See if attribute set to anything */
                             if ((mono_flag == FALSE) && (attribute == c(0x00)))                                  /* AN006 */
                                 attribute = c(WHITE_ON_BLUE);                        /* AC006 */
                             if ((mono_flag == TRUE) && (attribute == c(0x00)))                                  /* AN006 */
                                 attribute = c(GRAY_ON_BLACK);                        /* AN006 */
                             VIOWRTCHARSTRATT(s++,u(1),row,col++,attribute_ptr,u(0)); /* AC000 */
                             break;
                            }
                   }
               } /* End of string check */
           } /* No characters in string check */
        return;

}

/*  */

void number_in_msg(number,start)

XFLOAT      number;
unsigned    start;

{

char    mbytes[32];

        /* Divide the space down and get it into decimal */
        sprintf(mbytes,"%4.0d",number);
        insert[start+0] = mbytes[0];
        insert[start+1] = mbytes[1];
        insert[start+2] = mbytes[2];
        insert[start+3] = mbytes[3];

        return;

}


/*  */
void percent_in_msg(number,start)                                       /* AN000 */

unsigned    number;                                                     /* AN000 */
unsigned    start;                                                      /* AN000 */

{                                                                   /* AN000 */


char    percent[32];

        /* Divide the space down and get it into decimal */
        sprintf(percent,"%3.0d%%",number);                              /* AC000 */
        insert[start+0] = percent[0];                                   /* AC000 */
        insert[start+1] = percent[1];                                   /* AC000 */
        insert[start+2] = percent[2];                                   /* AC000 */
        insert[start+3] = percent[3];                                   /* AC000 */

        return;

}                                                                     /* AN000 */

/*  */
void string_in_msg(string_ptr,start)                                    /* AN000 */

char far    *string_ptr;                                                /* AN000 */
unsigned    start;                                                      /* AN000 */

{                                                                   /* AN000 */

unsigned     i;                                                         /* AN000 */

        /* init the 8 spots to blanks */
        for (i = u(0); i < u(8);i++)                                    /* AN000 */
            {                                                       /* AN000 */
             insert[start+i] = c(' ');                                  /* AN000 */
            }                                                         /* AN000 */
        /* Put characters into the array */
           {                                                        /* AN000 */
            insert[start+0] = *(string_ptr+0);                          /* AN000 */
            insert[start+1] = *(string_ptr+1);                          /* AN000 */
            insert[start+2] = *(string_ptr+2);                          /* AN000 */
            insert[start+3] = *(string_ptr+3);                          /* AN000 */
            insert[start+4] = *(string_ptr+4);                          /* AN000 */
            insert[start+5] = *(string_ptr+5);                          /* AN000 */
            insert[start+6] = *(string_ptr+6);                          /* AN000 */
            insert[start+7] = *(string_ptr+7);                          /* AN000 */
           }                                                          /* AN000 */
        return;                                                         /* AN000 */
}                                                                     /* AN000 */


/*  */
void volume_in_msg(string_ptr,start)                                    /* AN000 */

char far    *string_ptr;                                                /* AN000 */
unsigned    start;                                                      /* AN000 */

{                                                                   /* AN000 */

unsigned     i;                                                         /* AN000 */

        /* init the 11 spots to blanks */
        for (i = u(0); i < u(11);i++)                                   /* AN000 */
            {                                                       /* AN000 */
             insert[start+i] = c(' ');                                  /* AN000 */
            }                                                         /* AN000 */
        /* Put characters into the array */
           {                                                        /* AN000 */
            insert[start+0]  = *(string_ptr+0);                         /* AN000 */
            insert[start+1]  = *(string_ptr+1);                         /* AN000 */
            insert[start+2]  = *(string_ptr+2);                         /* AN000 */
            insert[start+3]  = *(string_ptr+3);                         /* AN000 */
            insert[start+4]  = *(string_ptr+4);                         /* AN000 */
            insert[start+5]  = *(string_ptr+5);                         /* AN000 */
            insert[start+6]  = *(string_ptr+6);                         /* AN000 */
            insert[start+7]  = *(string_ptr+7);                         /* AN000 */
            insert[start+8]  = *(string_ptr+8);                         /* AN000 */
            insert[start+9]  = *(string_ptr+9);                         /* AN000 */
            insert[start+10] = *(string_ptr+10);                        /* AN000 */
           }                                                          /* AN000 */
        return;                                                         /* AN000 */
}                                                                     /* AN000 */

