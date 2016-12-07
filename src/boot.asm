; boot secetion is loaded at 0x0000:0x7c00
; ------------------------------------------------------------------
; Run on mac:
;   nasm boot.asm -f bin -o boot.bin
;   qemu-system-x86_64 boot.bin
; ------------------------------------------------------------------

    BITS 16                 ; - The BITS directive specifies whether NASM should generate code designed to run on 
                            ;   a processor operating in 16-bit mode, or 32, 64
    ORG 0                   ; - Boot secetion is loaded at 07C00H. Here are some discussion of similar approches:
                            ;   http://forum.osdev.org/viewtopic.php?f=1&t=20933
    jmp 0x07C0:start

start:                      ; - We are currently in real mode

    mov ah, 0x0E            ; - Teletype output: https://en.wikipedia.org/wiki/INT_10H
    mov al, ':'
    int 0x10
    mov al, ')'
    int 0x10

    jmp $                   ; - Loop. Equals to 'while(true){;}'

times 510-($-$$) db 0       ; - Padding remaining of the section with zeros

dw 0xAA55                   ; - Last 2 bytes for magical sequence