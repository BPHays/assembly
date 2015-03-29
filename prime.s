.data

	.global fmt_out
fmt_out:
	.string "%d\n"

.text

	.global main
main:
	
	# 13(%rsp)	boolean prime
	# 12(%rsp)	i (outer counter)
	#  8(%rsp)	i limit (outer limit)
	#  4(%rsp)	j (inner counter)
	#   (%rsp)  j limit (inner limit)

	#create a new stack frame
	pushq %rbp
	movq  %rsp, %rbp
	subq  $16, %rsp

	#set the counter to 1 and the limit to 1000
	movl $1, 12(%rsp)
	movl $10000000, 8(%rsp)

.outerLoopTop:
	movl 12(%rsp), %eax
	cmp  8(%rsp), %eax
	jge  .outerLoopEnd

	#reset counter and limit for the inner loop
	movl $2, 4(%rsp)
	movl 12(%rsp), %edi
	call sqrtFunction

	movl %eax, (%rsp)

.innerLoopTop:
	movl 4(%rsp), %eax
	cmp  (%rsp), %eax
	jge  .innerLoopEnd

	#divide i by j
	movl 12(%rsp), %eax
	xor  %edx, %edx
	movl 4(%rsp), %ebx
	divl %ebx

	#test if j is a factor of i
	cmp  $0, %edx
	je   .factor

	#increment the inner loop counter and return to the top of the loop
	addl $1, 4(%rsp)
	jmp .innerLoopTop

.innerLoopEnd:
	#print the prime
	movq $fmt_out, %rdi
	movl 12(%rsp), %esi
	xor  %rax, %rax
	call printf

.factor:
	#increment the outer loop counter and return to the top of the loop
	addl $1, 12(%rsp)
	jmp .outerLoopTop

.outerLoopEnd:

	#destroy stack frame and return
	addq $16, %rsp
	pop  %rbp
	xor  %rax, %rax
	ret
