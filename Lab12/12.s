.section .data

inp: .string "%lu %lu"
out: .string "%lu\n"

.section .text

table:
	.quad 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

fn:
	mov $-1, %rax

	lea table(%rip), %rcx
	mov -8(%rcx, %rsi, 8), %rax
	  
	ret

.global main
main:
	push %rbp
	mov %rsp, %rbp

	sub $16, %rsp

	lea inp(%rip), %rdi
	lea 8(%rsp), %rsi
	lea (%rsp), %rdi
	xor %eax, %eax
	call scanf@plt

	mov 8(%rsp), %rdi
	mov (%rsp), %rsi

	call fn

	mov %rbp, %rsp
	pop %rbp


	xor %eax, %eax
	ret
