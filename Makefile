CFLAGS=-Wall -Wextra -fPIE

libs: b
	./abc -c brt.s lib.b

b: b0.o b1.o
	cc b0.o b1.o -o b

b0.o: b0.c b.h

b1.o: b1.c b.h

install: b abc libs
	cp abc $(HOME)/bin

%.o: %.s
	as --32 $^ -o $@

clean:
	rm -f *.o b
