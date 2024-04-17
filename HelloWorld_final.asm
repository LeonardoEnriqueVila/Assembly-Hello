; "Importar" las funciones de la API de Windows
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

section .data
msg db 'Hello, world!', 13, 10, 0  ; Mensaje a escribir seguido de CR, LF y NULL.
len dd $ - msg                     ; Longitud del mensaje, calculada automáticamente.
written dd 0                       ; Variable para almacenar el número de caracteres escritos.

section .text
global main 

main:
    ; Obtener el handle de la consola de salida estándar.
    mov ecx, dword -11  ; STD_OUTPUT_HANDLE
    call GetStdHandle

    ; Preparar la pila para la llamada a WriteConsoleA.
    sub rsp, 40h        ; Asegura suficiente espacio en la pila para alineación y argumentos.

    ; Preparar argumentos para WriteConsoleA.
    mov rcx, rax                   ; Primer argumento: hConsoleOutput
    lea rdx, [msg]                 ; Segundo argumento: lpBuffer (dirección del mensaje)
    mov r8d, [len]                 ; Tercer argumento: nNumberOfCharsToWrite
    lea r9, [written]              ; Cuarto argumento: lpNumberOfCharsWritten
    mov qword [rsp + 20h], 0       ; Quinto argumento: lpReserved (NULL), colocado en la pila.

    ; Llamar a WriteConsoleA.
    call WriteConsoleA

    ; Restaurar la pila.
    add rsp, 40h

    ; Salir del programa.
    xor ecx, ecx       ; Código de salida 0.
    call ExitProcess

