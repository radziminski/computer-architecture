.data
	string: .space 100
	endMsg: .asciiz "\nString with changed digits:\n"
.text
main:
	# reading string
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
loop: 			# looping thorugh all symbols and checking if symbol is a digit, then processing it
	lb $t0, ($a0)		# loading next symbol
	beq $t0, '\n', endLoop	# if its new line then end loop (end of a string)
	# sub $t0, $t0, '0'	# converting it to integer
	blt $t0, '0', notDigit	# checking if its between 0-9 (if it is a digit)
	bgt $t0, '9', notDigit
	
	li $t1, '9'		# if yes then substracting it from 9 and saving the result on the same place in memory
	sub $t1, $t1, $t0
	add $t1, $t1, '0'		# converting back to ascii
	sb $t1, ($a0)			# storing it on the same place
	add $a0, $a0, 1		# incrementing a0 to point to next symbol
	
	b loop			# repeating loop
notDigit:
	add $a0, $a0, 1		# if its not a digit then going to next symbol
	b loop
	
endLoop:	
	# printing string (wich already has changed digits) to the user:
	la $a0, endMsg
	li $v0, 4
	syscall
	
	la $a0, string
	li $v0, 4
	syscall

	li $v0, 10
	syscall
