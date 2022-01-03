 .section .data

in:
	.string "%ld"
out:
	.string "%ld\n"
num:
	.int 0, 0
.section .text

.global main
main:
	push %rbp
	mov %rsp, %rbp

	# call scanf()
	lea in(%rip), %rdi
	lea num(%rip), %rsi
	xor %eax, %eax
	call scanf@plt

	#++number
	mov num(%rip), %rsi
	inc %rsi

	#call printf()
	lea out(%rip), %rdi
	xor %eax, %eax
	call printf@plt

	leave

	xor %eax, %eax
	ret
