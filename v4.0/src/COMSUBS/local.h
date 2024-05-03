
#include "comsub.h"
#include "doscalls.h"

#define TABLE_SIZE	0x100

struct dbcs_range {
	unsigned char stop;
	unsigned char start;
};
#define NUM_DBCS_TABLES 5

extern struct dbcs_range dbcsvec[NUM_DBCS_TABLES];
extern unsigned char *casemap_up;
extern unsigned char *casemap_lo;

extern unsigned char com_settbl(void);
extern int check_dbcs(unsigned char c);





