/*
 *  verify correct DOS version
 */

#include "_comsubs.h"

unsigned comcheckdosver(void)
{
	int error;
	unsigned version;
	error = DOSGETVERSION(&version);
	return (error) ? error : (version == 0x500) ? com_settbl() : 0x3e8;
}
