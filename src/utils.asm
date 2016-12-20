; ----- Protected Mode Utils -----
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
