; boot secetion is loaded at 0x0000:0x7c00
; ------------------------------------------------------------------
; Run on mac:
;   nasm boot.asm -f bin -o boot.bin
;   qemu-system-x86_64 boot.bin
; ------------------------------------------------------------------

; - The BITS directive specifies whether NASM should generate code designed to run on
;   a processor operating in 16-bit mode, or 32, 64
BITS 16
; - Boot secetion is loaded at 07C00H. Here are some discussion of similar approches:
;   http://forum.osdev.org/viewtopic.php?f=1&t=20933
ORG 0x7C00

MIN_KERNEL_OFFSET equ 0x9000

; - We are currently in real mode
entry_16:
    mov [BOOT_DRIVE], dl
    mov ax, 0
    mov ds, ax
    mov es, ax
; - Load minimum kernal
; - Still under 1MB limit
    call load_min_kernel_16
; - Print a message in real mode :)
    mov si, KERNEL_LOADED_MESSAGE_16
    call print_string_16
; - Jump to protected mode:
; - Clear interrupts
    cli
; - Load globle descriptor table
    lgdt [gdtr]
; - Lowest bit of CRO controls whether it's protected mode
;   https://en.wikipedia.org/wiki/Control_register
    mov eax, cr0
    or eax, 1
    mov cr0, eax
; - Long jump
    jmp 0x08:entry_32

; - Loop. Equals to 'while(true){;}'
; - We should never reach here.
    jmp $

; - Print a string in real mode
; - Teletype output: https://en.wikipedia.org/wiki/INT_10H
print_string_16:
    pusha
    mov ah, 0x0E
    .loop:
    mov al, [ds:si]
    cmp al, 0
    je .return
    int 0x10
    inc si
    jmp .loop
    .return:
    popa
    ret

load_disk_16:
    push dx
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    int 0x13
    jc .disk_error
    pop dx
    cmp dh, al
    jne .disk_error
    ret
    .disk_error:
    mov si, DISK_ERROR_MSG_16
    call print_string_16
    jmp $

; - Load 10 sectors onto kernal offset
; - TODO: this doesn't work now...
load_min_kernel_16:
    mov bx, MIN_KERNEL_OFFSET
    mov dh, 20
    mov dl, [BOOT_DRIVE]
    call load_disk_16
    ret

; - Var
BOOT_DRIVE db 0
; - Constants
KERNEL_LOADED_MESSAGE_16:
    db 'Kernel loaded!',0
DISK_ERROR_MSG_16:
    db 'Disk error.',0
; - A flat protected mode
;   http://wiki.osdev.org/Global_Descriptor_Table
gdt:
; - NULL
    db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
; - Code selector, limit=2^20=4GB,
    db 0xFF,0xFF,0x00,0x00,0x00,0x9A,0xCF,0x00
; - Data selector, 4GB
    db 0xFF,0xFF,0x00,0x00,0x00,0x92,0xCF,0x00
gdtr:
; - Size = (size of gdt) - 1
    dw $ - gdt - 1
; - Offset of gdt
    dd gdt

; ----- Entering 32 bits world -----
BITS 32
entry_32:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

; - Print something interesting
    call cls
    mov edx, 0xB8000
    mov al, '^'
; - Black-Red
;   https://en.wikipedia.org/wiki/BIOS_color_attributes
    mov ah, 0x0C
    mov [edx], ax
    add edx, 2
    mov al, '_'
    mov [edx], ax
    add edx, 2
    mov al, '^'
    mov [edx], ax
    add edx, 2
    mov al, '.'
    mov [edx], ax
    add edx, 2
    mov al, '.'
    mov [edx], ax
    add edx, 2
    mov al, '.'
    mov [edx], ax
    add edx, 2

    jmp 0x08:MIN_KERNEL_OFFSET
    jmp $

%include "utils.asm"

; - Padding remaining of the section with zeros
times 510-($-$$) db 0

; - Last 2 bytes for magical sequence
dw 0xAA55
