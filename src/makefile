all: clean local

boot.bin: boot.asm
	nasm boot.asm -f bin -o boot.bin

kernel.bin: kernel.o kernel_entry.o
	/usr/local/crossgcc/bin/i686-elf-ld -Ttext 0x9000 kernel_entry.o kernel.o --oformat binary -o kernel.bin

kernel.o: kernel.c
	/usr/local/crossgcc/bin/i686-elf-gcc -ffreestanding -c kernel.c -o kernel.o

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

acesine.img: boot.bin kernel.bin
	cat boot.bin kernel.bin > bootable.tmp
	dd if=bootable.tmp of=acesine.img bs=512 count=20
	dd if=/dev/zero count=20 >> acesine.img

local: acesine.img

run: acesine.img
	make clean
	make
	qemu-system-x86_64 acesine.img

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.img
	rm -f *.tmp
