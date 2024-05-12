/*
 *   search the first substring occurrence in a string
 */

#include "_comsubs.h"

unsigned char
*com_substr(
   unsigned char *s,	      /* source string */
   unsigned char *t)	      /* target string */
{
/*2 */ 	int saved_i;
/*4 */	int saved_xxx;
/*6 */	int ns;
/*8 */ 	int saved_nt;
/*0a*/ 	int nt;
/*0c*/  int i;
/*0e*/ 	int j;

	com_settbl();
	ns = strlen(s);
	nt = strlen(t);
	if (nt > ns)	
		return 0;
	i = 0;
	j = 0;
	
/*l3*/	while ((ns -nt +1 >i)) {
		if (*t == s[i]) {
/*z1*/			if (i == 0 || (i != 0 && !check_dbcs(s[i-1]))) {
                		saved_i = i;
				saved_xxx = 0;
				saved_nt = nt;	
/*l6*/				while (saved_nt) 
/*l5*/					if (s[saved_i] == t[saved_xxx]) {
						saved_nt--;
						saved_i++;
						saved_xxx++;
					}
/*l7*/				if (!saved_nt)
					return s+i;
			}
		}
/*l8*/		j = 0;
		i--;
	}
	return 0;
}
