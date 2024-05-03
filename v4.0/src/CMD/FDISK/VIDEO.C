
#include "dos.h"                                                        /* AN000 */
#include "fdisk.h"                                                      /* AN000 */
#include "extern.h"                                                     /* AN000 */
#include "doscall.h"                                                    /* AN000 */
#include "fdiskmsg.h"                                                   /* AN000 */
#include "subtype.h"

/*  */

void clear_screen(TopRow,LeftCol,BotRow,RightCol)

unsigned     TopRow;
unsigned     LeftCol;
unsigned     BotRow;
unsigned     RightCol;

{

char    attribute;
char    *attribute_ptr = &attribute;

   if (mono_flag == TRUE)                                               /* AN006 */
       attribute = GRAY_ON_BLACK;                                       /* AN006 */
   else                                                                 /* AN006 */
       attribute = WHITE_ON_BLUE;                                       /* AC000 */
   VIOSCROLLUP(TopRow,LeftCol,BotRow,RightCol,u(0),attribute_ptr,u(0)); /* AC000 */
   return;
}





/*  */
/*                                                                          */
/****************************************************************************/
/* Initializes the screen and stores the lower right hand corner            */
/* of the screen in the global variable LowerRightHandCorner.  This         */
/* is which is used for screen clears.  If the screen is in grahpics mode,  */
/* it is changed to BW 40x25.  This procedure is only called once at program*/
/* start. Also saves the current screen                                     */
/****************************************************************************/
/*                                                                          */


void init_video_information()

{
        mono_flag = FALSE;                                              /* AN006 */

        /* Get the current video state */
        regs.h.ah = uc(CURRENT_VIDEO_STATE);                            /* AC000 */
        int86((int)VIDEO,&regs,&regs);                                  /* AC000 */

        /* Save the mode and display page */
        video_mode = regs.h.al;
        display_page = regs.h.bh;

        get_video_attribute();                                          /* AN006 */

        {
        /* assume color mode */
        regs.h.al = uc(Color80_25);                                     /* AC000 */

        /* See if we are in MONOCHROME mode */
        if ((video_mode == uc(MONO80_25)) || (video_mode == uc(MONO80_25A))) /* AC000 AC006 */
           {

            /* Nope,set to BW80x25*/
            regs.h.al = uc(BW80_25);                                    /* AC000 */
            mono_flag = TRUE;                                           /* AN006 */
           }

        /* go set the new mode */
        regs.h.ah = uc(SET_MODE);                                       /* AC000 */
        int86((int)VIDEO,&regs,&regs);                                  /* AC000 */
       }

        /* Set the display page */
        regs.h.ah = uc(SET_ACTIVE_DISPLAY_PAGE);                        /* AC000 */
        regs.h.al = uc(0);                                              /* AC000 */
        int86((int)VIDEO,&regs,&regs);                                  /* AC000 */

        return;
}

/*  */
/*                                             */
/* Resets the video mode to the original value */
/*                                             */

void reset_video_information()

{

char    *attribute_ptr = &video_attribute;                              /* AN006 */

        /* Clear display with colors that were present when FDISK was invoked */
        VIOSCROLLUP(u(0),u(0),u(24),u(79),u(0),attribute_ptr,u(0));     /* AN006 */

        /* Reset the video mode */
        regs.h.ah = SET_MODE;
        regs.h.al = video_mode;
        int86((int)VIDEO,&regs,&regs);                                  /* AC000 */

        /* Set the page */
        regs.h.ah = SET_PAGE;
        regs.h.al = display_page;
        int86((int)VIDEO,&regs,&regs);                                  /* AC000 */
        return;

}

/******************************************************************************/
/*Routine name:  GET_VIDEO_ATTRIBUTE                                          */
/******************************************************************************/
/*                                                                            */
/*Description:   This routine will invoke interrupt 10 function 08h to        */
/*               get the current attributes at the cursor postition in order  */
/*               to restore the correct colors when returning out of FDISK.   */
/*                                                                            */
/*Called Procedures:    none                                                  */
/*                                                                            */
/*                                                                            */
/*Change History: Created        3/11/88         DRM                          */
/*                                                                            */
/*Input: None                                                                 */
/*                                                                            */
/*Output: None                                                                */
/*                                                                            */
/******************************************************************************/

void get_video_attribute()                                              /* AN006 */

{                                                                   /* AN006 */

        /* Get current attributes */
        regs.h.ah = CURRENT_VIDEO_ATTRIBUTE;                            /* AN006 */
        regs.h.bh = display_page;                                       /* AN006 */
        int86((int)VIDEO,&regs,&regs);                                  /* AN006 */
        video_attribute = regs.h.ah;                                    /* AN006 */
        return;                                                         /* AN006 */

}                                                                     /* AN006 */

