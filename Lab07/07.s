.section .data


input_format:
    .string "%ld %ld"

output_format:
    .string "%ld is the greatest number.\n"

equal_message:
    .string "Both numbers are equal."

a:
    .int 0, 0 
b:
    .int 0, 0

.section .text


.global main
main:

    lea input_format(%rip), %rdi
    lea a(%rip), %rsi
    lea b(%rip), %rdx
    xor %eax, %eax
    call scanf@plt

    # if (a > b)
    mov a(%rip), %rsi
    mov b(%rip), %rcx
    cmp %rcx, %rsi 
    jg .main.a_is_greater 

    jl .main.b_is_greater 

    lea equal_message(%rip), %rdi
    call puts@plt

.main.end:
    # return 0;
    xor %eax, %eax
    ret

.main.a_is_greater:

    lea output_format(%rip), %rdi
    xor %eax, %eax
    call printf@plt
    jmp .main.end 

.main.b_is_greater:

    lea output_format(%rip), %rdi
    mov %rcx, %rsi
    xor %eax, %eax
    call printf@plt
    jmp .main.end 