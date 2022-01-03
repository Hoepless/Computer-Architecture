.section .data

inp_f:
	.string "%ld %ld"
out_f:
	.string "SOMA = %ld\n"
a:
	.int 0, 0
b: 
	.int 0, 0	

.section .text

.global main

main:

	push %rbp
	mov %rsp, %rbp

	lea inp_f(%rip), %rdi
	lea a(%rip), %rsi
	lea b(%rip), %rdx

	xor %eax, %eax
	call scanf@plt

	mov a(%rip), %rsi
	mov b(%rip), %rdx
	add %rdx, %rsi
	# add %rsi, %rcx

	lea out_f(%rip), %rdi
	
	xor %eax, %eax
	call printf@plt

	leave

	xor %eax, %eax
	ret
