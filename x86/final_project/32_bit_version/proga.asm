
section	.text
global  flipdiagbmp1

flipdiagbmp1:
; PROLOGUE
	push	ebp
	mov		ebp, 	esp
; Pushing save registers
	push	ebx
	push	edi	
	push	esi

; bitmap pointer at:	[ebp+8]
; bitmap (pixel) width:	[ebp+12]


; Getting actual image width in bytes 
	mov		edx,	[ebp+12]
	and		edx,	31		; getting % 32 
	jz 		skip
	neg		edx
	add		edx,	32
	
; Pushing result on stack
skip:
	add		edx,	[ebp+12]
	sar		edx,	3		; dividing result by 8 to get bytes
	push	edx		;byte width at [ebp - 16]



; ================================
; Main Processing Loop
;	ebx-> i (y's)
;	edi-> j (x's)
	mov		ebx,	1	; i = 1
forILoop:
	cmp		ebx,	[ebp+12]	; compering against image height
	jz		endForILoop	
	xor		edi,	edi
forJLoop:
	cmp		edi,	ebx			; j < i
	jz		endForJLoop

	; esi => arr
	; ecx => byte width
	; eax => x
	; edx => y

	; Position and mask of (j, i) [x, y] pixel
	; Byte width stack arg:
	mov		ecx,	[ebp - 16]
	; Array stack arg:
	mov		esi,	[ebp + 8]
	; Reg arguments: x, y:
	mov		eax,	edi
	mov		edx,	ebx
	; Function Call
	call	getPositon
	; Returns:
	; eax - arr pos, edx - mask
	; Saving them:
	push	eax		; getting posiution on the stack (no registers left)
	push	edx		; getting mask on the stack (no registers left)
	

	; Position and mask of (i, j) [y, x] pixel
	; Byte width stack arg:
	mov		ecx,	[ebp - 16]
	; Array stack arg:
	mov		esi,	[ebp + 8]
	; Reg arguments: x, y:
	mov		eax,	ebx
	mov		edx,	edi
	; Function Call
	call	getPositon
	; Returns:
	; eax - arr pos, edx - mask

 	pop		ecx		; getting mask of first
	pop		esi		; gettin position of first
 	mov		ch,		dl	; saving mask of second

	; movePixel argumentS:
	; dl - byte of source = esi
	; eax - position of dest = eax
 	; cl - mask of source, ch - mask of dest
	mov		dh,		[eax]
	mov		dl,		[esi]
	call movePixel

	; dl - byte of source = eax
	; eax - position of dest = esi
 	; cl - mask of source, ch - mask of dest
	mov		dl,		dh
	mov		eax,	esi
	mov		dh,		cl
	mov		cl,		ch
	mov		ch,		dh
	call movePixel

	; === END OF LOOP J ===
	inc		edi
	jmp		forJLoop
endForJLoop:
	; === END OF LOOP I ===
	inc		ebx
	jmp		forILoop
endForILoop:

;======== mian loop end =======

; restoring save registers
	add		esp,	4	; byte width pop
	pop		esi
	pop		edi
	pop 	ebx

	;EPILOGUE
	pop		ebp
	ret


;////////////////////////////////////////
;/////////    FUNCTIONS   ///////////////
;////////////////////////////////////////

; Function that returns adress of byte with given pixel and the mask 
; arguments:	
; eax -> x
; ecx -> y
; edx -> width
getPositon:
	push	ebp
	mov		ebp, 	esp
	push	ebx

	; esi => arr
	; ecx => byte width
	; eax => x
	; edx => y
	
	imul	edx,	ecx		;(byteWidth * bitY)

	; Getting x offset
	mov		ecx,	eax 	; x
	and		ecx,	7		; % 8
	mov		bl,		cl		; saving x offset in bl
	neg		ecx
	add		ecx,	eax
	sar		ecx,	3		 ; getting byte x position x /= 8
		
	add		ecx,	edx		;byteX += (byteWidth * bitY);

	mov		eax, 	esi	; array
	add		eax,	ecx		; getting array position

	; Mask caclulationg
	mov		dl,		1
	mov		cl,		7
	sub		cl,		bl
	shl		dl,		cl		; shiftings of 1

	; mask returned in dl

exit:
	pop		ebx
	pop 	ebp
	ret

; //////////////////////////////////////////////
; Function that puts value of pixel from source to destination
; whats important, it does no modifies any registers!
movePixel:
	push	ebp
	mov		ebp,	esp
	push	ebx

	; dl - source byte
	; eax - position of destination
 	; cl - mask first, ch - mask second

	mov		bh,		[eax]
	mov		bl,		dl
	and		bl,		cl
	jz		saveZero

	or		bh,		ch
	jmp		saveAfter

saveZero:
	mov		bl,		ch
	not		bl
	and		bh,		bl

saveAfter:
	mov		[eax],	bh

	pop		ebx
	pop		ebp
	ret