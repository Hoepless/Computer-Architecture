.section .data

test_out: .string "Check\n"
input: .string "%d %d %d %d"
output_i: .string "int: %ld\n"
output_f: .string "%f\n"
output_sum_n_avg: .string "sum = %f\navg = %f\n"
output_geo_sum: .string "geo_sum = %f\n"

a: .int 0, 0
x: .int 0, 0
c: .int 0, 0
m: .int 0, 0

.section .text













sum:


    mov $0, %r12
    fldl (%rsi)
    inc %r12
.sum.loop:
    cmp $16, %r12
    jge .sum.loop.end
 
    fldl (%rsi, %r12, 8)
    faddp
 
    inc %r12
    jmp .sum.loop
 
.sum.loop.end:
  
    pop %r13
    
    // lea output_i(%rip), %rdi
    // pop %rsi
    // xor %eax, %eax
    // call printf@plt
    // push %rsi

    fstl 8(%rsp)
    
    push $16
    fildl (%rsp)
    fdivrp
    pop %r12
    fstpl (%rsp)
    
    push %r13

 
    ret












geo_sum:
    push $0
    fildl (%rsp)
    pop %r12

    mov $1, %r8

.geo_sum.loop:
    cmp $16, %r12
    jge .geo_sum.loop.end

    fldl (%rsi, %r12, 8)

    push %r8
    fildl (%rsp)
    pop %r8

    fmulp
    faddp

    mov %r8, %rax
    mov $2, %r9
    mul %r9
    mov %rax, %r8


    inc %r12
    jmp .geo_sum.loop

.geo_sum.loop.end:
    pop %rax
    fstpl (%rsp)
    push %rax
    ret














rnd_gen:
    fildl x(%rip)
	mov $0, %r12
    fstpl (%r9, %r12, 8)
    fildl m(%rip)
	
.rnd.loop:
	cmp $16, %r12
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

    lea input(%rip), %rdi
    lea x(%rip), %rsi
    lea a(%rip), %rdx
	lea c(%rip), %rcx
	lea m(%rip), %r8
    xor %eax, %eax
    call scanf@plt

# RANDOM
    sub $128, %rsp
    lea (%rsp), %r9
    call rnd_gen

# PRINT ARRAY
    lea test_out(%rip), %rdi
    xor %eax, %eax
    call printf@plt

    mov $0, %r12
main.loop:
    cmp $16, %r12
    jge main.loop.end
 
    lea output_f(%rip), %rdi
    lea (%rsp), %r9
    movsd (%r9, %r12, 8), %xmm0
    mov $1, %eax
    call printf@plt
 
    inc %r12
    jmp main.loop
main.loop.end:




# SUN AND AVG
    lea (%rsp), %rsi
    sub $16, %rsp
    call sum
    lea output_sum_n_avg(%rip), %rdi
    movsd 8(%rsp), %xmm0
    movsd (%rsp), %xmm1
    mov $2, %eax
    call printf@plt
    add $16, %rsp




# GEO SUM
    lea (%rsp), %rsi
    call geo_sum
    lea output_geo_sum(%rip), %rdi
    movsd (%rsp), %xmm0
    mov $1, %eax
    call printf@plt

    add $128, %rsp
	leave	

	xor %eax, %eax
    ret
    
// # AUCA_SFW_6990
# 12341234 23456436135 34723623 6753245
# mode = 147
# 34 42 21 432



