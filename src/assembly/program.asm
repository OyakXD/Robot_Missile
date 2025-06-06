section .data
    alfabeto db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    seed dq 0
    newline db 10, 0
    c dq 1013904223
    a dq 1664525

section .bss
    letra_escolhida resb 1 ;

section .text
    global _start

_start:
    call init_seed

    call generate_code

    mov rax, 60
    mov rdi, 0
    syscall


; Função para gerar número pseudo-aleatório usando Linear Congruential Generator (LCG)
; Fórmula: next = (a * seed + c) % m
; Usando constantes como a=1664525, c=1013904223, m=2^32
random_gen:
    mov rax, [seed] 
    mov rdx, [a]
    mul rdx        ; rax = seed * a
    add rax, [c]    ; rax + c
    and rax, 0xFFFFFFFF     ; módulo mantém apenas 32 bits baixos
    mov [seed], rax
    ret

; Função para obter seed baseado no tempo atual, mesma função do srand() do C
init_seed: 
    rdtsc       ; Lê contador de ciclos do processador
    shl rdx, 32     ; contador de 64 bits
    or rax, rdx     
    mov [seed], rax
    ret

generate_code:
    call random_gen
    xor rdx, rdx
    mov rbx, 26
    div rbx

    mov al, [alfabeto + rdx]
    mov [letra_escolhida], al
    ret

