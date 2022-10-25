.section .data

input	:	.asciz "Enter a number: "
getInt	:	.asciz "%d"
output	:	.asciz "!%d = %d\n"
complex	:	.asciz "Factorial of a negative number is complex\n"

.section .text

.global main

main:
	// Get input
	ldr x0, =input
	bl printf
	
	sub sp, sp, 8
	
	ldr x0, =getInt
	mov x1, sp
	bl scanf
	
	// load x into arg register, initialize result (x1) to 1
	ldursw x0, [sp]
	mov x1, 1
	
	// Store original x on stack for printing later
	sub sp, sp, 8
	str x0, [sp]
	
	// If x < 0 -> complex number (and seg fault)
	cmp x0, 0
	blt negative
	
	bl fact
	
print:
	// load output string, mov result to x2, input to x1
	ldr x0, =output
	mov x2, x1
	ldr x1, [sp]
	bl printf
	
	b exit
	
fact:
	// if x == 0, should return 1, otherwise continues with fact
	cmp x0, 0
	bne skip
	br x30
	
skip:
	// x1 is serving as an accumulator
	mul x1, x1, x0
	sub x0, x0, 1
	
	// Store return address on stack and recurse
	sub sp, sp, 8
	str x30, [sp]
	bl fact
	
	// Restore return address from stack, deallocate, and return
	ldr x30, [sp]
	add sp, sp, 8
	br x30
	
negative:
	ldr x0, =complex
	bl printf
	b exit
	
exit:
	mov x0, 0
	mov x8, 93
	svc 0
	ret
