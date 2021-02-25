; This file computes the CRC32 of string given as argument
; using the inverse polynomial.
; It was extracted from a malware.

; Note that the nullbyte of the string is taken into account !

; bkwg@hola.re

[bits 32]

global _start

section .data
string: times 8 db 0

section .text
_start:

cmp DWORD [esp], 2
jnz exit

; Beginning of CRC32 calculation

; The real CRC is in dx:cx
; But the code is using a tmp var, bx:ax, for computation

loc_3301:
                mov     edi, DWORD [esp + 8]
                mov     ebx, edi
                mov     esi, edi
                xor     al, al

loc_330D:
                scasb                   ; computing function name length
                jnz     loc_330D

                sub     edi, ebx
                cld
                mov     ecx, -1         ; 1) Initializing CRC
                mov     edx, ecx        ;         //

loc_331A:
                xor     eax, eax
                xor     ebx, ebx
                lodsb                   ; 1.2) Load first byte of function name

                xor     al, cl          ; 2) XORing nth byte with current CRC

                mov     cl, ch          ; making things complicated here:
                mov     ch, dl          ; the code is using al to save the lowest byte
                mov     dl, dh          ; in order to use dh as a counter (see below)
                mov     dh, 8

loc_3329:
                shr     bx, 1
                rcr     ax, 1           ; 3) odd ?
                jnb     loc_333A        ; 3.1) if not, just leave the crc shifted
                xor     ax, 8320h       ; 3.2) if yes xor with the inversed polynomial 0xEDB88320)
                xor     bx, 0EDB8h      ;      //

loc_333A:
                dec     dh              ; 3.3) for each bit repeat the preceding process
                jnz     loc_3329
                xor     ecx, eax
                xor     edx, ebx
                dec     edi             ; dec length
                jnz     loc_331A
                not     edx
                not     ecx

                ; combining results
                mov     eax, edx
                rol     eax, 10h
                mov     ax, cx

                ; final result in eax

; print result in hex
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
