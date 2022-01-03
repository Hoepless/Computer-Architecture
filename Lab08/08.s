.section .data

input: .string "%ld"
output: .string "fib = %ld\n"

.section .text

fib:
	dec %rdi
	test %rdi, %rdi
	jz .fib_rec.ret_a

	mov %rsi, %rcx

	mov %rdx, %rsi

	add %rcx, %rdx

	call fib
	jmp .fib_rec.end

.fib_rec.ret_a:
	mov %rsi, %rax	

.fib_rec.end:
	ret

fib_loop:
	dec %rdi
	test %rdi, %rdi
	jz .fib_loop.end

	mov %rsi, %rcx
	mov %rdx, %rsi
	add %rcx, %rdx
	jmp fib_loop

.fib_loop.end:
	mov %rsi ,%rax
	ret

.global main

main:
	push %rbp
	mov %rsp, %rbp

	sub $0x10, %rsp

	lea input(%rip), %rdi
	lea 0x8(%rsp), %rsi
	xor %eax, %eax
	call scanf@plt

	dec %rsi

	mov 0x8(%rsp), %rdi
	mov $0x0, %rsi
	mov $0x1, %rdx
	call fib_loop

	lea output(%rip), %rdi
	mov %rax, %rsi
	xor %eax, %eax
	call printf@plt

	add $0x10, %rsp
	leave

	ret

