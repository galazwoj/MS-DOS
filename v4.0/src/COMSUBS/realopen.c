/*
 *  open drive in real mode
 */

// Actually the function has not been implemented, the original cvoe is a joke.
// So an invalid handle is returned if anyone wanted to use this function anyway.

#include "local.h"

unsigned far pascal REALOPEN(
	char far *name ,	   /* pointer to drive name */
	unsigned far *handle,    /* pointer to drive handle */
	unsigned mode)	   /* open mode */
{
	*handle = -1;
	return 1;
}

