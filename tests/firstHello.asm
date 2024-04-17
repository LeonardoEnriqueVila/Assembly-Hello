extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

section .data
msg db 'Hello, world!', 0

section .text
global _start

_start:
    ; Obtener el handle de la consola de salida estándar
    mov eax, dword -11     ; STD_OUTPUT_HANDLE
    call GetStdHandle

    ; Escribir mensaje en la consola
    mov ebx, eax            ; Handle de la consola
    mov ecx, msg            ; Mensaje para escribir
    mov edx, 13             ; Longitud del mensaje
    push 0                  ; Padding para stack alignment (64-bit calling convention)
    push edx                ; lpNumberOfBytesWritten (ignorado, ponemos dirección dummy)
    push edx                ; nNumberOfBytesToWrite
    push ecx                ; lpBuffer
    push ebx                ; hConsoleOutput
    call WriteConsoleA

    ; Salir del programa
    push 0                  ; Exit code
    call ExitProcess