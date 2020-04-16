
section	.text
global  replnum

replnum:
	push	ebp
	mov		ebp, 	esp
	mov		eax, 	DWORD [ebp+8]	; eax <- address of first arg
	xor		edx,	edx
	
letter:
	; getting current char to eax
	mov		cl,		[eax]
	inc 	eax
	; checking if its end of streing
	test 	cl,		cl
	jz		end
	; checking if its letter
	cmp		cl,		'1'
	jl		skip
	cmp		cl,		'9'
	jg 		skip
	;checking if its first number of part of series of number
	test	edx,	edx
	jnz 	letter
	dec 	eax
	;its first num so storing adress of first num in edx
	mov 	edx,	eax
	jmp 	letter
skip:
	;checking if we found ending of num sequence
	test	edx,	edx	
	jz		letter
	; yes so storing current pointer eax
	dec 	eax
	mov		cl,		[ebp+12]
	mov		[edx],	cl
	inc 	edx
	push	eax
remove:
	; checking if we deleted all numbers
	cmp		edx,	[ebp-4]
	jz		endrem
	;decrementing eax since we shifted everything
	pop		eax
	dec		eax
	push	eax
	; storing edx in eax
	mov		eax,	edx
shiftc:
	;getting next char and storing it at eax
	mov		cl,		[eax+1]
	mov		[eax],	cl
	;checking if its end of number (if its 0)
	test	cl,		cl
	jz		remove
	; going to next iteration
	inc		eax
	jmp 	shiftc
	
endrem:
	;after deleting sequence poping eax and zeroing edx, going to next iteration
	pop 	eax
	xor		edx,	edx
	jmp		letter

end:
	;at the end checking if string has not end with number sequence
	test	edx,	edx
	jz		epi
	; if yes storing null terminator at beginning of it
	mov		cl,		[ebp+12]
	mov		[edx],	cl
	mov		cl,	[eax-1]
	mov		[edx+1],	cl
epi:
	;epilogue
	mov		eax, 	[ebp+8]
	mov		esp,		ebp
	pop		ebp
	ret
