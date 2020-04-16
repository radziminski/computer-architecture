.data
	string: .space 100
	endMsg: .asciiz "\nString with changed digits:\n"
.text
main:
	# reading string to "string"
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
	li $t3, 0
loop:
	lb $t0, ($a0)
	beq $t0, '\n', endLoop	# if its new line then end loop
	sub $t0, $t0, '0'	# converting it to int (not necessary but easier to deal with)
	blt $t0, 0, notDigit	# if it is not between 0-9 then go to "notDigit" instruction
	bgt $t0, 9, notDigit
	mul $t2, $t2, 10
	add $t2, $t2, $t0
	add $a0, $a0, 1
	b loop
	
	notDigit:
	bgt $t2, $t3 save
	li $t1, 0
	li $t2, 0
	add $a0, $a0, 1
	b loop
	
	save:
	move $t3, $t2
	add $a0, $a0, 1
	li $t1, 0
	li $t2, 0
	b loop

endLoop:
	move $a0, $t3
	li $v0, 1
	syscall


end:
	li $v0, 10
	syscall	
