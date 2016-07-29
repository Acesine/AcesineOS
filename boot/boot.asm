; boot secetion is loaded at 0x0000:0x7c00
[BITS 16]
[ORG  0x7C00]

; real mode
mov bp, 0x9000
mov sp, bp

mov ah, 0x0E
mov al, 'A'
int 0x10
mov al, 'c'
int 0x10
mov al, 'e'
int 0x10
mov al, 's'
int 0x10
mov al, 'i'
int 0x10
mov al, 'n'
int 0x10
mov al, 'e'
int 0x10
mov al, 'O'
int 0x10
mov al, 'S'
int 0x10
mov al, ':'
int 0x10
mov al, ')'
int 0x10

; switching to 32 bits protected mode
cli
lgdt [GDT_DESCRIPTOR]
mov eax, cr0
or eax , 0x1
mov cr0, eax

; padding with zeros
times 510-($-$$) db 0
; last 2 bytes for magical sequence
dw 0xAA55
