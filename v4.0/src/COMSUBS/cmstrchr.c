/*
 *   search the first occurrence of a character in a string
 */

#include "local.h"

char *com_strchr(
   unsigned char *s,	      /* a source string */
   unsigned char c)	      /* a character to be searched */
{
	int i;
	unsigned char c1;	

	i = 0;
	com_settbl();

	while ((c1=s[i]) ) {
		if(check_dbcs(c1))
			i++;
		else
			if (c == s[i])
				return s+i;		
		i++;	
	} 
	return (c) ? 0 : s+i;
}

