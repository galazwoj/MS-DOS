# run this file to obtain initial font files
# then use any font editor to modify the font files accordingly
# then save the modified font files as CP$(NEWCPI).f16, CP$(NEWCPI).f14, CP$(NEWCPI).f08 respectively
# the run original makefile
#

CPI = 437
NEWCPI = 667

all:	org$(CPI).f08 \
	org$(CPI).f14 \
	org$(CPI).f16 

org$(CPI).f08: $(CPI)-8x8.asm org8x8.asm
	masm org8x8.asm;
	link org8x8.obj;
	exe2bin	org8x8.exe org$(CPI).f08
	del org8x8.obj
	del org8x8.exe

org$(CPI).f14: $(CPI)-8x14.asm org8x14.asm
	masm org8x14.asm;
	link org8x14.obj;
	exe2bin	org8x14.exe org$(CPI).f14
	del org8x14.obj
	del org8x14.exe

org$(CPI).f16 : $(CPI)-8x16.asm org8x16.asm
	masm org8x16.asm;
	link org8x16.obj;
	exe2bin	org8x16.exe org$(CPI).f16
	del org8x16.obj
	del org8x16.exe

clean:
	-del org$(CPI).f16
	-del org$(CPI).f14
	-del org$(CPI).f08
