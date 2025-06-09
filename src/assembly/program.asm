section .data
    alfabeto db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    newline db 10, 0

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

random_gen:
    rdrand rax
    ret
generate_code:
    call random_gen
    xor rdx, rdx
    mov rbx, 26
    div rbx

    mov al, [alfabeto + rdx]
    mov [codigo], al
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

read_char:
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    lea rsi, [tentativa]    ; buffer
    mov rdx, 2              ; lê 2 bytes (char + newline)
    syscall
    
    ; Converte para maiúscula se for minúscula
    mov al, [tentativa]
    cmp al, 'a'
    jl not_lowercase
    cmp al, 'z'
    jg not_lowercase
    sub al, 32              ; converte para maiúscula
    
not_lowercase:
    ret

print_string:
    mov rsi, rdi            ; copia endereço da string
    xor rcx, rcx            ; contador = 0

count_loop:
    cmp byte [rsi + rcx], 0 ; verifica fim da string
    je print_now
    inc rcx
    jmp count_loop

print_now:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, rsi            ; endereço da string
    mov rdx, rcx            ; tamanho
    syscall
    ret

print_char:
    push rax                ; salva registrador
    mov [tentativa], al     ; usa buffer temporário
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    lea rsi, [tentativa]    ; endereço do caractere
    mov rdx, 1              ; 1 byte
    syscall
    pop rax                 ; restaura registrador
    ret