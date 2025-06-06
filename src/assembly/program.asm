section .data
    alfabeto db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 0

section .text
    global main
    extern GenerateCode
    extern printfRand
    extern srand
    extern time

main:
    call GenerateLoop
    xor rax, rax
    ret

GenerateLoop:
    ; Inicializar gerador de números aleatórios
    xor rdi, rdi        ; time(NULL)
    call time
    mov rdi, rax        ; usar resultado de time() como seed
    call srand
    
    ; Chamar GenerateCode
    lea rdi, [alfabeto] ; passar endereço do alfabeto
    call GenerateCode
    
    ; Chamar printfRand com o resultado
    mov rdi, rax        ; resultado de GenerateCode está em rax
    xor rax, rax
    ret