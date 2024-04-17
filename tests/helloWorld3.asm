; "Importar" las funciones de la API de Windows
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

section .data
msg db 'Hello, world!', 13, 10, 0
len dd $ - msg
written dd 0  ; Aunque es opcional, lo incluimos para depuración

section .text
global main 

main:
    mov ecx, dword -11 ; STD_OUTPUT_HANDLE
    call GetStdHandle

    mov edx, len
    lea r8, [msg]
    lea r9, [written]  ; lpNumberOfCharsWritten, aunque opcional, puede ayudar en la depuración

    sub rsp, 28h        ; Ajuste de pila por convención de llamadas y alineación
    ; Usamos QWORD para mantener consistencia en x64.
    mov qword [rsp + 20h], 0  ; lpReserved debe ser NULL, lo colocamos en el stack directamente
    mov rcx, rax        ; hConsoleOutput
    mov rdx, r8         ; lpBuffer
    mov r8, r9          ; nNumberOfCharsToWrite
    mov r9, rsp         ; lpNumberOfCharsWritten, pero apuntamos al espacio reservado en la pila
    
    call WriteConsoleA

    add rsp, 28h        ; Restauramos el stack

    xor ecx, ecx
    call ExitProcess
