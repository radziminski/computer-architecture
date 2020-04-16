section	.text
global  remlastnum

remlastnum:
	push	ebp
	mov		ebp, 	esp
	mov		eax, 	DWORD [ebp+8]	; eax <- address of first arg
	xor		edx,	edx
find:
	mov		cl,		[eax]
	inc		eax
	test	cl,		cl
	jz		found
	cmp		cl,		'1'
	jl		find
	cmp 	cl,		'9'
	jg		find
	mov		cl,		[eax-2]
	cmp 	cl,		'9'
	jg		change
	cmp		cl,		'1'
	jl		change
	mov		edx,	eax
	jmp find
change:
	test	edx,	edx
	jz		skip
	add		esp,	4
skip:
	push	eax
	mov		edx,	eax
	jmp 	find
	
found:
	test	edx,	edx
	jz		end
	add		edx,	2
delete:
	dec		edx
	mov		eax,	[ebp-4]
	cmp		eax,	edx
	jz	end

remove:	
	mov		cl,		[eax]
	mov		[eax-1],	cl
	inc		eax
	test	cl,		cl
	jnz		remove
	jmp 	delete
	
end:
	mov		eax, 	[ebp+8]
	mov		esp,	ebp
	pop		ebp
	ret
