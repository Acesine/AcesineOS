; boot secetion is loaded at 0x0000:0x7c00
; ------------------------------------------------------------------
; Run on mac:
;   nasm boot.asm -f bin -o boot.bin
;   qemu-system-x86_64 boot.bin
; ------------------------------------------------------------------

; - The BITS directive specifies whether NASM should generate code designed to run on
;   a processor operating in 16-bit mode, or 32, 64
[BITS 16]
; - Boot secetion is loaded at 07C00H. Here are some discussion of similar approches:
;   http://forum.osdev.org/viewtopic.php?f=1&t=20933
[ORG 0x7C00]

; - We are currently in real mode
start:
; - Teletype output: https://en.wikipedia.org/wiki/INT_10H
    mov ah, 0x0E
    mov al, ':'
    int 0x10
    mov al, ')'
    int 0x10
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
    jmp 0x08:protected

; - Loop. Equals to 'while(true){;}'
; - We should never reach here.
    jmp $

[BITS 32]
protected:
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

    jmp $

; - A utility routine to clear screen
cls:
    pusha
    mov edx, 0xB8000
    mov bx, 0
    .loop:
    cmp bx, 4000
    jz .return
    mov ax, 0x00
    mov [edx], ax
    add bx, 2
    add edx, 2
    jmp .loop
    .return:
    popa
    ret

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

; - Padding remaining of the section with zeros
times 510-($-$$) db 0

; - Last 2 bytes for magical sequence
dw 0xAA55
