.data
	string: .space 100
	endMsg: .asciiz "\nLongest sequence of digits in string:\n"
.text
main:
	# reading string to "string"
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
	li $t1, 0 	# t1 will be - current length of digit string
	li $t2, 0	# t2 will be - current length of longest string up  to this point
loop:
	lb $t0, ($a0)		# loading current digit to t0
	beq $t0, '\n', endLoop	# if its new line then end loop
	sub $t0, $t0, '0'	# converting it to int (not necessary but easier to deal with)
	blt $t0, 0, notDigit	# if it is not between 0-9 then go to "notDigit" instruction
	bgt $t0, 9, notDigit
	beqz $t1, start		# if it is a digit then check if its first digit in substring or not (t1 holds length of current digit substring - checking if its 0)
	add $t1, $t1, 1		# if not then increase current substring length (t0)
	add $a0, $a0, 1		# increment a0 pointer to point ot next symbol
	b loop
	
	start:
		move $a1, $a0		# if it is first digit in substring save its adress
		add $t1, $t1, 1		# increase current substring length (t0)
		add $a0, $a0, 1		# increment a0 pointer to point ot next symbol
		b loop
	
	notDigit:
		bgt $t1, $t2, change	# if current symbol is not a digit then check if current substring of digits wasnt the longest (t2 holds longest length of substring up to this point)
		li $t1, 0		# if its not clear current substring length t1
		add $a0, $a0, 1		# increment a0 pointer to point ot next symbol
		b loop
		change:
			move $t2, $t1		# if t1 is the longest, save it to t2 as new longest 
			move $a2, $a1		# also save its adress
			li $t1, 0		# and clear it
			add $a0, $a0, 1	
			b loop
	
endLoop:
	bgt $t1, $t2, changeAgain	# check if string didnt ended with longest digit substring
	b nextStep			# if not go to printing longest  digit substring
changeAgain:
	move $t2, $t1			# if yes then save current substring
	move $a2, $a1

nextStep:
	# printing longest substring
	la $a0, endMsg			
	li $v0, 4
	syscall
	
displayLoop:	# loop repeates itself t2 times (length of longest substring) moving through a2 which initialy holds begining of substring
	beqz $t2, end
	lb $t0, ($a2)
	addu $a2, $a2, 1
	subu $t0, $t0, '0'
	subu $t2, $t2, 1
	move $a0, $t0
	li $v0, 1
	syscall
	b displayLoop

end:
	li $v0, 10
	syscall		