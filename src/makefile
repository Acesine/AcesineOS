# I'm writting on mac, so compiled a cross platform gcc to avoid some frustration...
LD= /usr/local/crossgcc/bin/i686-elf-ld
CC= /usr/local/crossgcc/bin/i686-elf-gcc

KERNEL_PATH= ./kernels
HELLO_WORLD_KERNEL= $(KERNEL_PATH)/hello_world_kernel.c
CHRISTMAS_TREE_KERNEL= $(KERNEL_PATH)/christmas_tree.c
KERNEL= $(CHRISTMAS_TREE_KERNEL)

all: clean local

boot.bin: boot.asm
	nasm boot.asm -f bin -o boot.bin

kernel.bin: kernel.o kernel_entry.o
	$(LD) -Ttext 0x9000 kernel_entry.o kernel.o --oformat binary -o kernel.bin

kernel.o:
	$(CC) -ffreestanding -c $(KERNEL) -o kernel.o

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

acesine.img: boot.bin kernel.bin
	cat boot.bin kernel.bin > bootable.tmp
	dd if=bootable.tmp of=acesine.img bs=512
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
