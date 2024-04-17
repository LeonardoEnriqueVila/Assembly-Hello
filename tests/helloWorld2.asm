; "Importar" las funciones de la API de Windows
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

section .data
msg db 'Hello, world!', 13, 10, 0
len dd $ - msg
written dd 0

section .text
global main

main:
    mov ecx, dword -11  ; STD_OUTPUT_HANDLE
    call GetStdHandle

    sub rsp, 28h  ; Ajuste para alineación de 16 bytes + espacio para 'written'
    
    mov edx, len        ; nNumberOfCharsToWrite
    lea r8, [msg]       ; lpBuffer
    mov r9, rsp         ; lpNumberOfCharsWritten (apuntamos a parte de la pila ajustada)
    add r9, 20h         ; Ajustamos la dirección para evitar sobreponer el valor en 'mov [rsp+8], rdx'

    mov [rsp + 8], rdx  ; lpNumberOfCharsWritten (dummy, para cumplir con la convención de llamada)
    mov rcx, rax        ; hConsoleOutput
    
    call WriteConsoleA

    add rsp, 28h  ; Restaurar el valor original de RSP
    
    xor ecx, ecx
    call ExitProcess
