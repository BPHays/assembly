.data

.text
	.global sqrtFunction
	# int number	(%rsp)
	# int x			4(%rsp)
sqrtFunction:
	#create a new stack frame
	pushq %rbp
	movq  %rsp, %rbp
	subq  $8, %rsp

	#get parameters from registers
	movl %edi, (%rsp) #the number
	movl %edi, %eax #initial guess

	#put 2 in esi to be used later in division
	movl $2, %esi

	#do until newtons method returns a difference of less than 0
.looptop:
	movl %eax, 4(%rsp)
	
	#perform newtons method for square roots
	movl (%rsp), %eax
	xor  %edx, %edx
	divl 4(%rsp)
	addl 4(%rsp), %eax
	xor  %edx, %edx
	divl %esi

	#get newX - x and store the value
	movl 4(%rsp), %ebx
	cmp  %eax, %ebx
	je  .return
	jl  .useLastX
	jg  .looptop

.useLastX:
	#put the previous value of x into eax
	movl %ebx, %eax

.return:
	#destroy the stack frame and return the sqrt
	addq $8, %rsp
	pop  %rbp
	ret
