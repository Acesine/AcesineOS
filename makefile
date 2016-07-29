BOOT_DIR = boot

all: boot.bin
	qemu-system-x86_64 $(BOOT_DIR)/boot.bin

boot.bin:
	nasm $(BOOT_DIR)/boot.asm -f bin -o $(BOOT_DIR)/boot.bin

debug: all
	qemu-system-x86_64 -s -S $(BOOT_DIR)/boot.bin

clean:
	rm -f $(BOOT_DIR)/boot.bin
