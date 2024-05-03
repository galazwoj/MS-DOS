/*
 *   convert character to uppercase
 */

#include "local.h"

int com_toupper(unsigned char c)	      /* character to be converted to uppercase */
{
	com_settbl();
	return casemap_up[c];
}
