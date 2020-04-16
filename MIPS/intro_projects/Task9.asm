.data
	string: .space 100
	
.text
main:
	# - reading string
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
	li $t1, 0
loop:
	lb $t0, ($a0)
	beq $t0, '\n', endLoop
	bgt $t0, 122, skip
	blt $t0, 97, skip
	beq $t1, 2, upper
	add $t1, $t1, 1
	b skip
	
	upper:
	sub $t0, $t0, 32
	sb $t0, ($a0)
	li $t1, 0
	b skip
	
	
	skip:
	addu $a0, $a0, 1
	b loop
endLoop: 
	# printing result
	la $a0, string
	li $v0, 4
	syscall
	
end:
	li $v0, 10
	syscall
