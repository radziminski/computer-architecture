
section	.text
global  removenth

removenth:
	push	ebp
	mov		ebp, 	esp
	mov		eax, 	DWORD [ebp+8]	; eax <- address of first arg
	mov 	edx,	[ebp+12]
	xor		edx,	edx
	
check:
	inc 	edx
	mov		cl,		[eax]
	test	cl,		cl
	jz		end
	cmp		edx,	[ebp+12]
	je		remove
	inc		eax
	jmp check
	
remove:
	push	eax
	xor		edx,	edx
loop:
	mov		cl,		[eax+1]
	mov		[eax],	cl
	inc 	eax
	test	cl,		cl
	jnz		loop
	pop		eax
	jmp		check

end:
	mov		eax, 	[ebp+8]
	pop		ebp
	ret
