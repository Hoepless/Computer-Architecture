.section .data

input_format:
    .string "%ld %ld"
output_format:
    .string "%ld\n"
a:
    .int 0, 0
b:
    .int 0, 0

.section .text

gcd:
    test %rsi, %rsi
    jz .ret_a

    mov %rdi, %rax
    cqo
    mov %rsi, %rdi
    div %rsi
    mov %rdx, %rsi
    call gcd
    jmp .end

.ret_a:
    mov %rdi, %rax
.end:
    ret

gcd_loop:
    test %rsi, %rsi
    jz .gcd_loop.end

    mov %rdi, %rax
    cqo
    mov %rsi, %rdi
    div %rsi
    mov %rdx, %rsi
    jmp gcd_loop

.gcd_loop.end:
    mov %rdi, %rax
    ret

.global main

main:
    push %rbp
    mov %rsp, %rbp

    sub $0x10, %rsp

    lea input_format(%rip), %rdi
    lea 0x8(%rsp), %rsi
    lea (%rsp), %rdx
    xor %eax, %eax
    call scanf@plt

    mov 0x8(%rsp), %rdi
    mov (%rsp), %rsi
    call gcd_loop
    mov %rax, %rsi
    lea output_format(%rip), %rdi
    xor %eax, %eax
    call printf@plt

    add $0x10, %rsp
    # return 0;
    leave

    xor %eax, %eax
    ret
