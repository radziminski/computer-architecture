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
	
	li $t1, 0 	# t1 will be a length of current substring of digits( if its >0 it means that previous symbol was digit - 0 otherwise)
loop:
	lb $t0, ($a0)		# loading current digit to t0
	beq $t0, '\n', endLoop	# if its new line then end loop
	sub $t0, $t0, '0'	# converting it to int (not necessary but easier to deal with)
	blt $t0, 0, notDigit	# if it is not between 0-9 then go to "notDigit" instruction
	bgt $t0, 9, notDigit
	beqz $t1, start		# checking if it is the first digit in substring (if length t1 is 0)
	add $t1, $t1, 1
	add $a0, $a0, 1
	b loop
	start:			# if it is the first digit in substring then set length to 1 
	li $t1, 1
	move $a1, $a0		# and save its adress
	add $a0, $a0, 1
	b loop
	
	notDigit:		
	bnez $t1, reverse	# if current symbol is not a digit check if previous symbol wasnt sigit (if the substring of digit hasnt ended)
	add $a0, $a0, 1		# if not move to next iteration
	b loop
	reverse:		# if yes then we have to reverse it:
	sub $t1, $t1, 1		# we started counting length on 1 so we have to substract 1 from it
	add $a2, $a1, $t1	# pointing a2 to last digit in substring
	revLoop:
		beq $a2, $a1, endRevLoop	# if both a1 a2 points to the same place it means we had odd length, end loop
		bgtu $a1, $a2 endRevLoop	# if a1 points further then a2 then end loop (we covered whole substring)
		lb $t2, ($a1)			# swaping digits at a1 and a2 (reversing order)
		lb $t3, ($a2)
		sb $t3, ($a1)
		sb $t2, ($a2)
		addu $a1, $a1, 1		# moving forward in a1 and bacward with a2
		subu $a2, $a2, 1
		b revLoop
	endRevLoop:
	li $t1, 0				# clearing length and moving to next iteration
	add $a0, $a0, 1
	b loop
endLoop:
	bnez $t1, reverseAgain			# checking if string hasnt ended with substring
	b nextStep
reverseAgain:					# if yes then we are repating process from "reverse" label
	sub $t1, $t1, 1
	add $a2, $a1, $t1
	revLoopAgain:
		beq $a2, $a1, endRevLoopAgain
		bgtu $a1, $a2 endRevLoopAgain
		lb $t2, ($a1)
		lb $t3, ($a2)
		sb $t3, ($a1)
		sb $t2, ($a2)
		addu $a1, $a1, 1
		subu $a2, $a2, 1
		b revLoopAgain
	endRevLoopAgain:
	b nextStep
	
nextStep:					# printing result
	la $a0, string
	li $v0, 4
	syscall
	
end:
	li $v0, 10
	syscall		
