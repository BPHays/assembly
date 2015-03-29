.data

	.global prompt
prompt:
	.string "Enter a number: "

	.global fmt_int
fmt_int:
	.string "%d"

	.global msg_out
msg_out:
	.string "the square root is %d\n"

.text
	.global main
main:
	#create a new stack frame
	pushq %rbp
	movq  %rsp, %rbp
	subq  $16, %rsp

	#prompt the user for input
	movq  $prompt, %rdi
	xor   %rax, %rax
	call printf

	#record the user's input
	movq  $fmt_int, %rdi
	movq  %rsp, %rsi
	xor   %rax, %rax
	call  scanf

	#initialize newX to the value specified by the user
	movl (%rsp), %eax
	movl %eax, 8(%rsp)

	#do until newtons method returns a difference of less than 0
.looptop:
	movl 8(%rsp), %eax
	movl %eax, 12(%rsp)
	
	#perform newtons method for square roots
	movl (%rsp), %eax
	xor  %edx, %edx
	divl 12(%rsp)
	addl 12(%rsp), %eax
	xor  %edx, %edx
	movl $2, %ebx
	divl %ebx
	movl %eax, 8(%rsp)

	#get newX - x and store the value
	movl 8(%rsp), %eax
	movl 12(%rsp), %ebx
	cmp  %eax, %ebx
	jle   .printOut
	jg   .looptop

.printOut:
	#print the root
	movq $msg_out, %rdi
	movl 12(%rsp), %esi
	xor  %rax, %rax
	call printf

	#destroy the stack frame
	addq $16, %rsp
	pop  %rbp
	xor  %rax, %rax
	ret
