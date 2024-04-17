section .text
    global _start

_start:
    mov eax, 1          ; syscall number for exit
    mov ebx, 0          ; status
    int 0x80            ; call kernel
