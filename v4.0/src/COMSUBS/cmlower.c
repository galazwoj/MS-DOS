/*
 *   convert character to lowercase
 */

#include "_comsubs.h"

int com_tolower(unsigned char c)	      /* character to be converted to lowercase */
{
	com_settbl();
	return casemap_lo[c];
}
