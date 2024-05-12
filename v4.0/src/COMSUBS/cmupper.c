/*
 *   convert character to uppercase
 */

#include "_comsubs.h"

int com_toupper(unsigned char c)	      /* character to be converted to uppercase */
{
	com_settbl();
	return casemap_up[c];
}
