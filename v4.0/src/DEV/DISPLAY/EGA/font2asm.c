#include <stdio.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>

unsigned char values[4096];

#define SIZE_FONT_8x8   2048
#define SIZE_FONT_8x14  3584
#define SIZE_FONT_8x16  4096

#define NAME_FONT_8x8   	"8 x 8"
#define NAME_FONT_8x14 		"8 x 14" 	
#define NAME_FONT_8x16  	"8 x 16"	
#define NAME_FONT_UNKNOWN      	"unknown or invalid"

int main(int argc, char *argv[])
{
	FILE *f;	
	int num;
	int nk, i, k;
	struct tm *cdate;
	time_t aclock;
	struct stat sbuf;

	if (argc !=3) {
		puts("Usage: font2asm fontfile codepage");
		puts("\tExample: font2asm CP852.8X8 852");
		return 1;
	}

#ifdef DEBUG
	printf("%s ", argv[1]);	
#endif

	if (stat(argv[1], &sbuf) == -1) {
		printf("cannot find file: %s\n", argv[1]);
		return 1;
	}	

	if (sbuf.st_size > sizeof(values)) {
		printf(" file '%s' too large to convert\n", argv[1]);
		return 1;
	}
		
	if (!(f = fopen(argv[1], "r+b"))) {
		printf("cannot open file: %s\n", argv[1]);
		return 1;
	}
	num = fread(values, 1, sizeof(values), f);	
	fclose(f);

#ifdef DEBUG
	printf("font %s\n",     (num == SIZE_FONT_8x8 ) ? NAME_FONT_8x8  :
				(num == SIZE_FONT_8x14) ? NAME_FONT_8x14 :				
				(num == SIZE_FONT_8x16) ? NAME_FONT_8x16 : NAME_FONT_UNKNOWN);
#endif

	switch (num) {
		case  SIZE_FONT_8x8:
			nk = 8;
			break;
		case  SIZE_FONT_8x14:
			nk = 14;
			break;
		case  SIZE_FONT_8x16:
			nk = 16;
			break;
		default:
			nk = 0;
			break;
	}

	if (!nk)
		return 1;

	time(&aclock);
	cdate = localtime(&aclock);

	puts  (";***************************************************");
	puts  (";  CHARACTER FONT FILE");
	puts  (";  Source Assembler File");
	puts  (";");
	printf(";	 CODE PAGE: %s\n", argv[2]);
	printf(";  FONT RESOLUTION: %s\n", 	(num == SIZE_FONT_8x8 ) ? NAME_FONT_8x8  :
						(num == SIZE_FONT_8x14) ? NAME_FONT_8x14 :				
						(num == SIZE_FONT_8x16) ? NAME_FONT_8x16 : NAME_FONT_UNKNOWN);
	puts  (";");
	printf(";     DATE CREATED:%02d-%02d-%04d\n", ++cdate->tm_mon, cdate->tm_mday, cdate->tm_year + 1900);        
	puts  (";");
	printf(";  input file: %s\n",argv[1]);
	puts  (";  Output file from: font2asm");
	puts  (";");
	puts  (";***************************************************");

	for(i=0, k=1; i < num; i++) {
		if (k == 1)
			printf("    Db  ");
		printf("%03Xh", values[i]);
		if (k == nk) {
			printf(" ;   Hex #%X\n", i/nk);  		
			k = 1;
		} else { 
			printf(",");
			k++;
		}
	}
	puts  ("");
	return 0;
}

