
section	.text
global  funcName

funcName:
	push	ebp
	mov		ebp, 	esp
	mov		eax, 	DWORD [ebp+8]	; eax <- address of first arg
	
	mov		eax, 	[ebp+8]
	pop		ebp
	ret
