; "Importar" las funciones de la API de Windows
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

; Seccion de datos
section .data
; 13: "Carriage Return" (CR) -> volver el cursor al inicio de la línea.
; 10: "Line Feed" (LF) -> CR+LF se utiliza como el fin de línea estándar en archivos de texto y asegurar que salida de consola se muestre correctamente en una nueva línea.
; 0: Char nulo
msg db 'Hello, world!', 13, 10, 0 ; Guarda mensaje en simbolo "msg"
; $ representa la dirección actual en el código fuente durante el ensamblaje
; $ - msg calcula diferencia entre direc actual (justo después de la cadena) y direc donde comienza msg. 
; Diferencia igual a longitud de cadena porque cada char ocupa 1 byte
len dd $ - msg ; Calcula la longitud del mensaje
written dd 0 ; Espacio para almacenar el número de caracteres escritos

; Seccion de código
section .text
global main ; proceso de inicialización y salida del programa -> Main por su sinergia con biblioteca CRT de Windows

main:
    ; Obtener el handle de la consola de salida estándar
    mov ecx, dword -11 ; STD_OUTPUT_HANDLE
    call GetStdHandle

    ; ECX ahora tiene el handle de la consola
    ; Preparar argumentos para WriteConsoleA
    mov edx, len                  ; Se carga la longitud del mensaje en EDX.
    lea r8, [msg]                 ; lpBuffer - Se usa LEA (Load Effective Address) para cargar la dirección de la cadena msg en R8.
    lea r9, [written]             ; lpNumberOfCharsWritten
    sub rsp, 20h                  ; Shadow space + align stack to 16 bytes -> ajustar stack 32 bytes (20h). Shadow Space -> Se reserva 32 Bytes en la pila antes de hacer la llamada
    ; El shadow space y la alineación de pila son requerimientos de la convención de llamadas x64 de Windows
    mov [rsp + 8], rdx            ; lpNumberOfBytesWritten (espacio temporal en stack)
    mov rcx, rax                  ; hConsoleOutput - handle de la consola
    mov rdx, r8                   ; lpBuffer - puntero al mensaje
    mov r9d, edx                  ; nNumberOfBytesToWrite - longitud del mensaje
    call WriteConsoleA

    ; Ajustar el stack antes de salir
    add rsp, 20h                  ; Revertir el ajuste del stack

    ; Salir del programa
    xor ecx, ecx                  ; Exit code 0
    call ExitProcess


