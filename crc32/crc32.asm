; This file computes the CRC32 of string given as argument
; using the inverse polynomial

; bkwg@hola.re

[bits 32]

global _start

section .data
string: times 8 db 0

section .text
_start:

cmp DWORD [esp], 2
jnz exit

loc_3301:
                mov edi, DWORD [esp + 8]
                mov ebx, edi
                mov esi, edi
                xor     al, al

loc_330D:
                scasb   ; computing function name length
                jnz     loc_330D

                sub     edi, ebx
                cld
                mov     ecx, -1
                mov     edx, ecx

loc_331A:
                xor     eax, eax
                xor     ebx, ebx
                lodsb                   ; load first byte of function name
                xor     al, cl
                mov     cl, ch          ; shrd dx, cx, 8
                                        ; mov dh, 8
                mov     ch, dl
                mov     dl, dh
                mov     dh, 8

loc_3329:
                shr     bx, 1
                rcr     ax, 1
                jnb     loc_333A
                xor     ax, 8320h       ; CRC-32 (using inverse polynomial : 0xEDB88320)
                xor     bx, 0EDB8h

loc_333A:
                dec     dh
                jnz     loc_3329
                xor     ecx, eax
                xor     edx, ebx
                dec     edi
                jnz     loc_331A
                not     edx
                not     ecx
                mov     eax, edx
                rol     eax, 10h
                mov     ax, cx
                ; result in eax

print_hex:
    mov ecx, 8
    rotate:
        mov edx, 0000000Fh
        and edx, eax
        cmp dl, 9
        jg upper
        add dl, 30h
        jmp store
        upper:
            add dl, 37h
        store:
        mov BYTE [string + ecx - 1], dl
        shr eax, 4
    loop rotate
    mov edx, 8
    mov ecx, string
    mov ebx, 1
    mov eax, 4
    int 0x80

exit:
    mov eax, 1
    mov ebx, 0 
    int 0x80
