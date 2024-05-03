/*
 *   convert a string to lowercase
 */

#include "local.h"

unsigned char
*com_strlwr(
   unsigned char *s)	      /* string to be converted */
{
	unsigned char *str;
	unsigned char c;

	com_settbl();
	str = s;
	while((c = *str)) {
		if(check_dbcs(c)) {
			str++;
			if (!*str)
				break;
		} else
			*str = casemap_lo[*str];	
		str++;
	}
	return s;
}

