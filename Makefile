CC = clang
CFLAGS = -Wall -Wextra -fPIE
INSTALL_DIR = $(HOME)/abc

libs: b
	BBIN_DIR=. BLIB_DIR=. ./abc -c brt.s lib.b

b: b.h b0.c b1.c
	$(CC) b0.c b1.c -o b

install: b abc libs
	mkdir -p $(INSTALL_DIR)/bin
	cp abc b $(INSTALL_DIR)/bin
	mkdir -p $(INSTALL_DIR)/lib
	cp link.ld lib.o brt.o $(INSTALL_DIR)/lib

%.o: %.s
	as --32 $^ -o $@

clean:
	rm -f *.o b a.out
