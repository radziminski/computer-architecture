.data
	string: .space 100
	
.text
main:
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	
loop:
	lb $t0, ($a0)
	beq $t0, '\n', endLoop
	bgt $t0, 57, notDigit
	blt $t0, 48, notDigit
	move $a1, $a0
	move $a2, $a0
	addu $a1, $a1, 1
	toStringEnd:
		lb $t1, ($a1)
		sb $t1, ($a2)
		beq $t1, '\n', endToStringEnd
		addu $a1, $a1, 1
		addu $a2, $a2, 1
		b toStringEnd
	endToStringEnd:
	sb $0, ($a1)
	b loop
	
	notDigit:
	addu $a0, $a0, 1
	b loop
endLoop:

	la $a0, string
	li $v0, 4
	syscall
	
end:
	li $v0, 10
	syscall