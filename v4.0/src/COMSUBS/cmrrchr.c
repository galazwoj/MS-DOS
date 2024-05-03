/*
 *   search the last charater occurrence in a string
 */

#include "local.h"
#include <string.h>

static unsigned char cc[2];
static unsigned char *pcc = cc;

unsigned char 
*com_strrchr(
   unsigned char *s,	      /* source string */
   unsigned char c)	     /* target string */
{

/*-2*/	int saved_nnn;
/*-4*/ 	int saved_i;
/*-6*/	int n;
/*-8*/	int saved_nn;
/*-0a*/	int nn;
/*-0c*/	int nnn;
/*-0e*/	int i;

	*pcc = c;
	com_settbl();
	n = strlen(s);
	nn = strlen(pcc);
	if (nn > n)
		return 0;
/*l2*/	nnn = n - nn;
	i = 0;
/*l3*/	while (nnn >= 0) {	
		if (*pcc == s[nnn])  {
/*z1*/			if (nnn == 0 || (nnn != 0 && !check_dbcs(s[nnn-1]))) {
/*l4*/				saved_nnn = nnn;
			        saved_i = i;
				saved_nn = nn;
/*l6*/				while (saved_nn) 
/*l5*/					if (s[saved_nnn] == pcc[saved_i]) {
						saved_nn--;
						saved_nnn++;
						saved_i++;
					}
/*l7*/				if (!saved_nn)
					return s+nnn;
			}
		}
/*l8*/		i = 0;
		nnn--;
	}
	return 0;
}

