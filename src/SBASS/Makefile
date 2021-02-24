CFLAGS=-ansi -pedantic -Wall -O3
LDLIBS=-lz

.PHONY : clean

sbass : sbass.o saucy.o saucyio.o util.o

sbass.o saucy.o saucyio.o : saucy.h
sbass.o saucyio.o : amorph.h
sbass.o util.o : util.h
sbass.o saucyio.o : platform.h

clean :
	rm -f sbass *.o
