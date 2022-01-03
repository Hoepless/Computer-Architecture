.section .data

inp: .string "%ld %ld"
out: .string "%ld\n"

.section .text

add1:
	mov %edi, %eax
	cltq
	ret

add2:
	mov %edi, %eax
	cltq
	mov %rax, %rdi 
	mov %esi, %eax
	cltq
	add %rdi, %rax
	ret

add10:
	xor %rax, %rax
	add %rdi, %rax
	add %rsi, %rax
	add %rdx, %rax
	add %rcx, %rax
	add %r8, %rax
	add %r9, %rax

	pop %rdi
	pop %rsi
	pop %rdx
	pop %rcx
	pop %r8

	add %rsi, %rax
	add %rdx, %rax
	add %rcx, %rax
	add %r8, %rax
	
	push %rdi
	ret

.global main

main:
	push %rbp
	mov %rsp, %rbp

	mov $1, %edi 
	call add1


	lea out(%rip), %rdi 
	mov %rax, %rsi 
	xor %eax, %eax
	call printf@plt

	mov $1, %edi
	mov $2, %esi
	call add2

	lea out(%rip), %rdi
	mov %rax, %rsi
	xor %eax, %eax
	call printf@plt

	mov $1, %rdi
	mov $2, %rsi
	mov $3, %rdx
	mov $4, %rcx
	mov $5, %r8
	mov $6, %r9
	push $7
	push $8
	push $9
	push $10
	call add10

	lea out(%rip), %rdi
	mov %rax, %rsi
	xor %eax, %eax
	call printf@plt

	mov %rbp, %rsp
	pop %rbp

	xor %eax, %eax
	ret

