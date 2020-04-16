.data
	string: .space 100
	
.text
main:
	# - reading string
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
	# - reading two numbers (starting and ending point of cut)
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $v0, 5
	syscall
	move $t1, $v0

	# t0 - starting point, #t1 - ending point
	bge $t1, $t0, next # - checking the order (if it was start - end then do nothing, swap them otherwise)
	move $t2, $t0
	move $t0, $t1
	move $t1, $t2
	
next:
	sub $t1, $t1, $t0 # changing ending point to: how much numbers we should delete after start (t1 = end - start = t1 - t0)
	li $t2, 0
loop:	# searching for starting point of delete sequence and setting a0 to it
	lb $t3, ($a0)
	beq $t3, '\n', final	# if its after strings end then print string imidiatly
	beq $t2, $t0, endLoop
	addu $a0, $a0, 1
	addu $t2, $t2, 1
	b loop
	
endLoop:
	li $t2, 0
	
	deleteLoop:	# loop that deletes t1 number of symbols starting at a0
	bgt $t2, $t1, final 	# t2 keeps track at which iteration we are in - if we deleted enogh numbers of syymbols then move to the end
	add $a1, $a0, 1		# a1 is a0 + 1 
	move $a2, $a0		# a2 is a0
	toStringEnd:		# loop that deletes symbol at a0 and moves all symbols to the right of it one step to the left
		lb $t3, ($a1)		# loading next symbol
		beqz $t3, final		# if its 0 it means the string has already ended so we can finish program
		sb $t3, ($a2)		# otherwise it stores it in current bit
		beq $t3, '\n', endToStringEnd	# if its /n symbol it means its the end of string
		addu $a1, $a1, 1	# moving to the next symbol
		addu $a2, $a2, 1
		b toStringEnd
	endToStringEnd:
	sb $0, ($a1)		# in case last bit was /n we are storing 0 (end of string) at its place
	add $t2, $t2, 1		# moving to next interation
	b deleteLoop
final:
	# printing result
	la $a0, string
	li $v0, 4
	syscall
	
end:
	li $v0, 10
	syscall




