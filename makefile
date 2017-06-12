CC = nasm

ARCA = elf32
ARCL = elf_i386

DFLAGS = -g -F stabs
AFLAGS = -f
LFLAGS = -m

LINKER = ld

SRC = ./src/MatriceMul.asm

all : clean-objects matriceMul

clean-objects:
	rm -rf ./src/MatriceMul.o 

matriceMul: compile link 

compile:
	$(CC) $(AFLAGS) $(ARCA) $(DFLAGS) $(SRC)
link:
	$(LINKER) $(LFLAGS) $(ARCL) -o ./bin/matriceMul ./src/*.o