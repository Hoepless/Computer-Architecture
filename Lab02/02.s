.section .data

output:
    .string "hello, world"

.section .text
.global main
main:

    lea output(%rip), %rdi
    call puts@plt          

    xor %eax, %eax
    ret
