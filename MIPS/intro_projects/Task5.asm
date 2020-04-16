.data
	string: .space 100
	
.text
main:
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
	li $t1, 0
	li $t2, 0
loop:
	lb $t0, ($a0)
	beq $t0, '\n', endLoop
	bgt $t0, 57, notDigit
	blt $t0, 48, notDigit
	li $t1, 1
	add $a0, $a0, 1
	b loop
	
	notDigit:
	bnez $t1, addOne
	add $a0, $a0, 1
	b loop
	
	addOne:
	add $t2, $t2, 1
	li $t1, 0
	add $a0, $a0, 1
	b loop
	
endLoop:
	beqz $t1, print
	add $t2, $t2, 1
print:
	move $a0, $t2
	li $v0, 1
	syscall
	
end:
	li $v0, 10
	syscall
		