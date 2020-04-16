.data
	string: .space 100
	
.text
# NOT FINISHED - WRON
main:
	# - reading string
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
loop:
	lb $t0, ($a0)
	beq $t0, '\n', endLoop
	bgt $t0, 57, notDigit
	blt $t0, 48, notDigit
	addu $a1, $a0, 1
	addu $a2, $a1, 1
	deleteLoop:
		lb $t1, ($a2)
		sb $t1, ($a1)
		beq $t1, '\n' endDeleteLoop
		addu $a1, $a1, 1
		addu $a2, $a2, 1
		b deleteLoop
	endDeleteLoop:
	sb $0, ($a2)
	notDigit:
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
