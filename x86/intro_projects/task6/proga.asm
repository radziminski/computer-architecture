
section	.text
global  leaverng

leaverng:
	push	ebp
	mov		ebp, 	esp
	mov		eax, 	DWORD [ebp+8]	; eax <- address of first arg
letterCheck:
	mov		edx,	eax
	mov 	cl,		[eax]
	test	cl,		cl
	jz		end
	cmp		cl,		[ebp+12]
	jl		remove
	cmp 	cl,		[ebp+16]
	jg		remove
	inc		eax
	jmp		letterCheck
	
remove:
	mov 	cl,		[edx+1]
	mov		[edx],	cl
	inc		edx
	test	cl,		cl
	jnz		remove
	jmp 	letterCheck
end:
	mov		eax, 	[ebp+8]
	pop		ebp
	ret
