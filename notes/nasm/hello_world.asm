; ----------------------------------------------------------------------------
; Run on mac: 
;   nasm -f macho64 hello_world.asm
;   ld hello_world.o -o hello_world
; ----------------------------------------------------------------------------
section .text                   ; - SECTION or SEGMENT directive changes the section of
                                ;   the output file where the code will be assembled.
                                ; - .text represents the CODE segment

global start                    ; - NASM directive GLOBAL applys to a symbol before the
                                ;   defination of the symbol
                                ; - 'start' is the default entry point here
                                ; - https://sourceware.org/binutils/docs/ld/Entry-Point.html#Entry-Point
                                ; - So instead of using harded coded 'start', we can use
                                ;   'blabla', and use 'ld hello_world.o -e blabla -o hello_world'
                                ;   to link

start:
    mov rax, 0x02000004         ; - syscall number for 'write' is 4:
                                ;   http://opensource.apple.com//source/xnu/xnu-1504.3.12/bsd/kern/syscalls.master
                                ; - However Mac os has 'syscall' class for 64 bit system calls:
                                ;   http://opensource.apple.com//source/xnu/xnu-1699.26.8/osfmk/mach/i386/syscall_sw.h
                                ; - Note that 1 is for Mach and 0 is invalid. The class is left
                                ;   shifted by 24

    mov rdi, 1                  ; - 1 is fid of stdout, and there are parameters for write syscall
    mov rsi, msg
    mov rdx, msglen
    syscall                     ; - Here's the convention of parameters of syscall:
                                ;   https://en.wikibooks.org/wiki/X86_Assembly/Interfacing_with_Linux

    mov eax, 0x02000001         ; - syscall number 1 is 'exit'
    mov rdi, 0                  ; - exit(0); The same as 'xor rdi, rdi'
    syscall

segment .data                   ; - SEGMENT is the same as SECTION
                                ; - .data represents the DATA segment

msg db 'Hello, world!', 0x0A    ; - 0x0A (aka 10) is ascii of '\n'

msglen equ $-msg                ; - '$' means current position
                                ; - Similarly '$$' means the begining of current section