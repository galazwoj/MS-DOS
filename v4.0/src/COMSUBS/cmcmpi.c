/*
 *   compare two strings with regard to case
 */

#include "local.h"

int com_strcmpi(
  unsigned char *s1,	      /* source string	       */
  unsigned char *s2)	      /* string to be compared */
{
	unsigned char c1, c2;
	int i, k;

	com_settbl();
	i = 0;
	c1 = s1[0];
	c2 = s2[0];	

	while (c1 && c2) {
		k = 0;
		if (!check_dbcs(c1)) {
			c1 = casemap_up[c1];
			c2 = casemap_up[c2] ;
			k = 1;
		}
		while (k <2) {
			if (c1 <= c2) {
				if (c1 >= c2) {
					i++;
					c1 = s1[i];	
					c2 = s1[i];	
					k++;
				} else 
					return -1;
			} else
				return 1;
		}
	}
	return (c1 == c2) ? 0 : (c1 > c2) ? 1 : -1;
}

