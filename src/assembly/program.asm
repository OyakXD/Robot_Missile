section .data
    alfabeto db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    seed dq 0
    newline db 10, 0
    c dq 1013904223
    a dq 1664525

    msg_start db 'ROBOT MISSILE', 10, 0
    msg_input db 'TYPE THE CORRECT CODE: ', 0
    msg_find db 'TICK..FZZZ...CLICK..!', 10, 0
    msg_find2 db 'YOU DID IT', 10, 0
    msg_after db 'LATER ', 0        
    msg_before db 'EARLIER ', 0        
    msg_output1 db 'LETTER (A-Z) TO', 10, 0
    msg_output2 db 'DEFUSE THE MISSILE', 10, 0
    msg_output3 db 'YOU HAVE 4 CHANCES', 10, 0
    msg_invalid db 'ENTER ONLY LETTERS FROM A TO Z!', 10, 0
    msg_game_over db 'YOU BLEW IT', 10, 0
    msg_game_over2 db 'THE CORRET CODE WAS: ', 0
    msg_game_over3 db 'BOOOOOOOOOOOOOOOOOM...', 10, 0
    msg_chances db 'REMAINING CHANCES: ', 0

section .bss
    codigo resb 1
    tentativa resb 2
    chances resb 1

section .text
    global _start

_start:
    ; Inicializa o número de chances
    mov byte [chances], 4

    ; Função para gerar uma letra aleatória.
    call init_seed
    call generate_code

    lea rdi, [msg_start]
    call print_string
    
    lea rdi, [msg_output1]
    call print_string
    
    lea rdi, [msg_output2]
    call print_string
    
    lea rdi, [msg_output3]
    call print_string
    
    jmp game_loop


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

game_loop:

    ; Verifica se ainda tem chances
    cmp byte [chances], 0
    je game_over

    lea rdi, [msg_chances]
    call print_string
    mov al, [chances]
    add al, '0'             ; converte número para ASCII
    call print_char
    lea rdi, [newline]
    call print_string

    lea rdi, [msg_input]
    call print_string

input_loop:
    call read_char
    mov [tentativa], al

    ; Validação: verifica se é uma letra maiúscula (A-Z)
    cmp al, 'A'
    jl invalid_input
    cmp al, 'Z'
    jg invalid_input


    mov al, [tentativa]
    mov bl, [codigo]
    call missile

    cmp al, 1
    je game_won

    dec byte [chances]
    jmp game_loop

invalid_input:
    lea rdi, [msg_invalid]
    call print_string
    jmp input_loop

game_won:
    lea rdi, [msg_find]
    call print_string
    lea rdi, [msg_find2]
    call print_string

    mov rax, 60
    mov rdi, 0
    syscall

game_over:
    lea rdi, [msg_game_over3]
    call print_string
    lea rdi, [msg_game_over]
    call print_string
    lea rdi, [msg_game_over2]
    call print_string
    mov al, [codigo]        
    call print_char
    lea rdi, [newline]
    call print_string
    mov rax, 60
    mov rdi, 1              
    syscall

missile:
    cmp al, bl
    je missile_achou
    jl missile_depois       
    jmp missile_antes     

missile_antes:
    lea rdi, [msg_before]
    call print_string
    mov al, [tentativa]     
    call print_char
    lea rdi, [newline]
    call print_string
    mov al, 0              
    ret

missile_depois:
    lea rdi, [msg_after]
    call print_string
    mov al, [tentativa]     
    call print_char
    lea rdi, [newline]
    call print_string
    mov al, 0               
    ret

missile_achou:
    mov al, 1               
    ret