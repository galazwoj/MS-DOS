Additional fonts

This directory contains public domain CP852 fonts that are equivalent to the code page used by IBM and compatible PCs (with 256K EGA or better).
These fonts, and the accompanying utility programs, are from Joseph (Yossi) Gil (Yogi) at the Technion in Haifa, Israel, host ssl.cs.technion.ac.il, directory /pub/DOS/Yogi.  
Many others are also available from the same source. (Actually they come from MSKERM31.ZIP)
The filetype (.F16 or .F08) tells how many vertical dots the font contains. The .F16 files are suitable for the normal
25-row by 80-column screen, and the .F08 files are suitable for most of the larger screen dimensions, such as 53x80.
Other fonts and sizes are available from the Technion FTP site.

This directory contains also the following font utilities:
CHARSET.COM a utility that displays all the characters in the current font.

CP852 fonts
* CP852.F16, this 8x16 font comes from the archive
* CP852.F14, this 8x14 font comes from CP852.F16, then converted using fontman from x2ftp.oulu.fi
* CP852.F08, this 8x8  font comes from the archive

font2asm was used to convert binary files to asm 

CP667 fonts
These are based on CP437 from ms-dos source
8x16 edited 8x16 file
8x14 fonversion from 8x16 file, not perfect
8x8 edited 8x8 file
Details are in orgfont.mak

	modifications 
#	CP667	CP437	CP852	character
1	086h 134 <-  061h   165	a ogonek
2	08dh 141 <-  063h   134	c kreska
3	08fh 143 <-  041h   164	A ogonek
4	090h 144 <-  045h   168	E ogonek
5	091h 145 <-  065h   169	e ogonek
6	092h 146 <-  06ch   136	l kreœlone
7	095h 149 <-  043h   143	C kreska
8	098h 152 <-  053h   151	S kreska
9	09ch 156 <-  04ch   157	L kreœlone
10	09eh 158 <-  073h   152	s kreska
11	0a0h 160 <-  05ah   141	Z kreska
12	0a1h 161 <-  05ah   189	Z kropka
13	0a3h 163 <-  04fh   224	O kreska
14	0a4h 164 <-  06eh   228	n kreska
15	0a5h 165 <-  04eh   227	N kreska
16	0a6h 166 <-  07ah   171	z kreska
17	0a7h 167 <-  07ah   190	z kropka
        0a2h present    162	o kreska
