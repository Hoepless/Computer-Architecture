
.section .data
input: .string "%ld"
output: .string "fact = %ld\n"

fact:
	test %rdi, %rdi
	jz .fact.ret_1

	push %rdi
	dec %rdi
	call fact
	pop %rdi
	mul %rdi
	ret

.fact.ret_1:
	mov $0x1, %rax
	ret

.section .text
.global main

fact_loop:
	mov $0x1, %rax
	mov $0x2, %rsi
.fact_loop.body:
	cmp %rdi, %rsi
	jg .fact_loop.end
	mul %rsi
	inc %rsi
	jmp .fact_loop.body

.fact_loop.end:
	ret

main:
	push %rbp
	mov %rsp, %rbp

	sub $0x10, %rsp

	lea input(%rip), %rdi
	lea (%rsp), %rsi
	xor %eax, %eax
	call scanf@plt

	mov (%rsp), %rdi
	call fact_loop

	lea output(%rip), %rdi
	mov %rax, %rsi
	xor %eax, %eax
	call printf@plt

	add $0x10, %rsp

	mov %rbp, %rsp
	pop %rbp

	ret
	