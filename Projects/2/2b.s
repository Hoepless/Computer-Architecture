.section .data

test_out: .string "Check\n"
input_prompt: .string "Enter x, a, c, m: "
input_prompt_2: .string "\nEnter A, B: "
input: .string "%d %d %d %d"
input_AB: .string "%d %d"
output_i: .string "int: %ld\n"
output_f: .string "%f\n"


a: .int 0, 0
x: .int 0, 0
c: .int 0, 0
m: .int 0, 0

A: .int 0, 0
B: .int 0, 0

.section .text






# rsi = size of arr
# rdi = base of arr
fun: 
    mov $0, %r12

.fun.loop:
    cmp %rsi, %r12
    jge .fun.loop.end

    fildl B(%rip)
    fildl A(%rip)
    fldl (%rdi, %r12, 8)
    
    fmulp
    faddp

    fstpl (%rdi, %r12, 8)

    inc %r12
    jmp .fun.loop

.fun.loop.end:
    ret









# rsi = size
# r9 = base
rnd_gen:

    fildl x(%rip)
	mov $0, %r12
    fstpl (%r9, %r12, 8)
    fildl m(%rip)
	
.rnd.loop:
	cmp %rsi, %r12
	jge .rnd.loop.end

    fldl (%r9, %r12, 8)
    fildl a(%rip)
    fmulp
    fildl c(%rip)
    faddp
    fprem
    fstpl 8(%r9, %r12, 8)

	inc %r12
	jmp .rnd.loop			
.rnd.loop.end:

	ret














.global main
main:
	push %rbp
	mov %rsp, %rbp

    lea input_prompt(%rip), %rdi
    xor %eax, %eax
    call printf@plt

    lea input(%rip), %rdi
    lea x(%rip), %rsi
    lea a(%rip), %rdx
	lea c(%rip), %rcx
	lea m(%rip), %r8
    xor %eax, %eax
    call scanf@plt

# RANDOM GENERATOR
    sub $256, %rsp
    lea (%rsp), %r9
    mov $32, %rsi
    call rnd_gen

# PRINT ARRAY
    // lea test_out(%rip), %rdi
    // xor %eax, %eax
    // call printf@plt

    mov $0, %r12
    mov $32, %r13
main.loop:
    cmp %r13, %r12
    jge main.loop.end
 
    lea output_f(%rip), %rdi
    lea (%rsp), %r9
    movsd (%r9, %r12, 8), %xmm0
    mov $1, %eax
    call printf@plt
 
    inc %r12
    jmp main.loop
main.loop.end:

    lea input_prompt_2(%rip), %rdi
    xor %eax, %eax
    call printf@plt
    
    lea input_AB(%rip), %rdi
    lea A(%rip), %rsi
    lea B(%rip), %rdx
    xor %eax, %eax
    call scanf@plt

    lea (%rsp), %rdi
    mov $32, %rsi
    call fun

# PRINT MODIFIED ARRAY 
    mov $0, %r12
    mov $32, %r13
main.loop2:
    cmp %r13, %r12
    jge main.loop2.end
 
    lea output_f(%rip), %rdi
    lea (%rsp), %r9
    movsd (%r9, %r12, 8), %xmm0
    mov $1, %eax
    call printf@plt
 
    inc %r12
    jmp main.loop2
main.loop2.end:

    add $256, %rsp
	leave	

	xor %eax, %eax
    ret
    
// # AUCA_SFW_6990
# 12341234 23456436135 34723623 6753245
# mode = 147
# 34 42 21 432



