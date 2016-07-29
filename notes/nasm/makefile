all: clean
	nasm -f macho64 hello_world.asm
	ld hello_world.o -o hello_world
	./hello_world

clean:
	rm -f *.o
	rm -f *.s
	rm -f hello_world