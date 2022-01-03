.section .data

input: .string "%d %d %d %d"
output: .string "%d\n"
output_min: .string "min = %d\n"
output_max: .string "max = %d\n"
output_mode: .string "mode = %d\n"
output_median: .string "median = %d\n"
output_geo_sum: .string "geo_sum = %d\n"
output_sum_n_avg: .string "sum = %d\navg = %d\n"

a: .int 0, 0
x: .int 0, 0
c: .int 0, 0
m: .int 0, 0










.section .text

sort:
	mov $0, %r12

.sort.loop_i:
	cmp $15, %r12
	jge .sort.end_i


	mov $0, %r13
	.sort.loop_j:
		cmp $15, %r13
		jge .sort.end_j
		mov (%rsi, %r13, 8), %rax
		mov 8(%rsi, %r13, 8), %rdi
		cmp %rax, %rdi
		jl .sort.swap

		.loop.ret_from_swap:
		inc %r13
		jmp .sort.loop_j

	.sort.end_j:
	inc %r12
	jmp .sort.loop_i

.sort.swap:
	mov %rdi, (%rsi, %r13, 8)
	mov %rax, 8(%rsi, %r13, 8)
	jmp .loop.ret_from_swap

.sort.end_i:
	xor %rax, %rax
	ret













sum_n_avg:
	xor %rax, %rax
	mov $0, %r12

.sum_n_avg.loop:
	cmp $16, %r12
	jge .sum_n_avg.loop.end

	add (%rsi, %r12, 8), %rax
	inc %r12
	jmp .sum_n_avg.loop

.sum_n_avg.loop.end:
	mov $16, %rsi
	mov %rax, %r13
	div %rsi
	ret













# rdi = n
median:
	mov %rdi, %rax
	mov $2, %r8
	div %r8
	cmp $0, %rdx
	je .median.even_n

	mov (%rsi, %rax, 8), %r8
	mov %r8, %rax
	jmp .median.end


.median.even_n:
	mov (%rsi, %rax, 8), %r8
	mov -8(%rsi, %rax, 8), %r9
	add %r8, %r9
	mov %r9, %rax
	mov $2, %r8
	div %r8

.median.end:
	ret
















# array = r8
# currNumber = rdi
# modeNum = rsi
# currCount = rdx
# maxCount = rcx
mode:
	mov $0, %r12
	mov (%r8, %r12, 8), %rdi
	mov %rdi, %rsi
	mov $1, %rdx
	mov $1, %rcx
	mov $1, %r12

.mode.loop:
	cmp $16, %r12
	jge .mode.loop.end

	cmp %rdi, (%r8, %r12, 8)
	je .mode.count.inc
	jne .mode.new_currNumber


	inc %r12
	jmp .mode.loop

.mode.count.inc:
	inc %rdx
	inc %r12
	jmp .mode.loop

.mode.new_currNumber:
	cmp %rdx, %rcx
	jl .mode.new_maxCount

.mode.new_maxCount.ret:
	mov $1, %rdx
	mov (%r8, %r12, 8), %rdi
	inc %r12
	jmp .mode.loop

.mode.new_maxCount:
	mov %rdx, %rcx
	mov %rdi, %rsi
	jmp .mode.new_maxCount.ret

.mode.loop.end:
	mov %rsi, %rax
	ret









# array = rdi
# res = rcx
# pow_two = r8
geo_sum:
	mov $0, %rcx
	mov $0, %r12
	mov $2, %r8

.geo_sum.loop:
	cmp $16, %r12
	jge .geo_sum.loop.end

	# arra[i-1]
	xor %rax, %rax
	mov (%rdi, %r12, 8), %rax
	mul %r8
	add %rax, %rcx

	mov %r8, %rax
	mov $2, %rsi
	mul %rsi
	mov %rax, %r8

	inc %r12
	jmp .geo_sum.loop

.geo_sum.loop.end:
	mov %rcx, %rax
	ret
















rnd_gen:
	mov $0, %r12
	
.rnd.loop:
	cmp $16, %r12
	jge .rnd.loop.end

	mov (%rsi, %r12, 8), %rax
	mul %rdi
	add %r8, %rax
	div %rcx
	mov %rdx, 8(%rsi, %r12, 8)
	inc %r12
	jmp .rnd.loop	
		
.rnd.loop.end:

	ret












.global main
main:
	sub $8, %rsp

	lea input(%rip), %rdi
	lea x(%rip), %rsi
	lea a(%rip), %rdx
	lea c(%rip), %rcx
	lea m(%rip), %r8
	xor %eax, %eax
	call scanf@plt
	
	sub $128, %rsp
	push %rbp
	mov %rsp, %rbp

	mov a(%rip), %rdi
	mov x(%rip), %rsi
	mov %rsi, 8(%rbp)
	lea 8(%rbp), %rsi
	mov c(%rip), %r8
	mov m(%rip), %rcx	

# RANDOM
	call rnd_gen

# SORT
	lea 8(%rbp), %rsi
	call sort

# PRINT ARRAY
	mov $0, %r12

main.loop:
	cmp $16, %r12
	jge main.loop.end

	
	lea output(%rip), %rdi			
	mov 8(%rbp, %r12, 8), %rsi
	xor %eax, %eax
	call printf@plt

	inc %r12
	jmp main.loop
main.loop.end:
	
# MIN
	# lea 8(%rbp), %rsi
	# call min
	lea output_min(%rip), %rdi			
	mov 8(%rsp), %rsi
	xor %eax, %eax
	call printf@plt

# MAX
	# lea 8(%rbp), %rsi
	# call max
	lea output_max(%rip), %rdi			
	mov 128(%rsp), %rsi
	xor %eax, %eax
	call printf@plt

# SUM AND AVG
	lea 8(%rbp), %rsi
	call sum_n_avg
	lea output_sum_n_avg(%rip), %rdi			
	mov %r13, %rsi
	mov %rax, %rdx
	xor %eax, %eax
	call printf@plt

# MEDIAN
	mov $16, %rdi
	lea 8(%rbp), %rsi
	call median
	lea output_median(%rip), %rdi			
	mov %rax, %rsi
	xor %eax, %eax
	call printf@plt

# MODE
	lea 8(%rbp), %r8
	call mode
	lea output_mode(%rip), %rdi		
	mov %rax, %rsi	
	xor %eax, %eax
	call printf@plt

# GEOMETRIC SUM
	lea 8(%rbp), %rdi
	call geo_sum
	lea output_geo_sum(%rip), %rdi		
	mov %rax, %rsi	
	xor %eax, %eax
	call printf@plt

	leave	
	add $136, %rsp

	xor %eax, %eax
	ret

# AUCA_SFW_6990
# 12341234 23456436135 34723623 6753245
# 34 42 21 432 - mode = 147



