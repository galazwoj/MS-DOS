#include "_comsubs.h"

// https://www.osfree.org/doku/doku.php?id=en:docs:fapi:dosgetdbcsev

extern unsigned char *casemap_lo;
extern unsigned char *casemap_lo;

unsigned char com_settbl(void)
{
	static int done = FALSE;
	struct countrycode cc;
	int error;
	unsigned char *p;
	int i;

	cc.country = 0;  
	cc.codepage = 0; 
	if (done)
		return 0;
	casemap_lo = malloc(TABLE_SIZE);
	casemap_up = malloc(TABLE_SIZE);
	error = DOSGETDBCSEV(NUM_DBCS_TABLES, &cc, (char far *)dbcsvec);
	if (error)
		return error;
	for(i=0; i < TABLE_SIZE; i++) {
		casemap_lo[i] = i;
		casemap_up[i] = i;
	}
	error = DOSCASEMAP(TABLE_SIZE, &cc, casemap_up);
	if (error)	
		return error;
	for(p = casemap_up, i=0; i < TABLE_SIZE; i++, p++) {
		if ((int)*p != i) 
			casemap_lo[(int)*p] = i;
	}
	done = TRUE;
	return 0;
}

int check_dbcs(unsigned char c)
{
	unsigned int i;
	for (i=0; i < NUM_DBCS_TABLES; i++) {
		if ( dbcsvec[i].stop == 0 && dbcsvec[i].start == 0)
			return 0;
		if ( dbcsvec[i].stop <= c && dbcsvec[i].start >= c)
			return 1;
	}
	return -1;
}
