
section	.text
global  flipdiagbmp1

flipdiagbmp1:
; PROLOGUE
	push	rbp
	mov		rbp, 	rsp
; Pushing save registers
	push	rbx
	push 	r12

; bitmap pointer at:				rdi (was [rbp+16])
; bitmap (pixel) width:				rsi (was [rbp+24])
; bitmap byte width with padding:	r10 (after friest few instructions)

; Functions preserve the registers rbx, rsp, rbp, r12, r13, r14, and r15; 
; while rax, rdi, rsi, rdx, rcx, r8, r9, r10, r11 are scratch registers. 

; free: rax, rcx, rdx,
; using rdi, r10, r11, r12 as arguments passed to function getPos

; Getting actual image width in bytes
	mov		r10d,	esi
	and		r10d,	31		; getting % 32
	jz 		skip
	neg		r10d
	add		r10d,	32
skip:
	add		r10d,	esi
	sar		r10d,	3		; dividing result by 8 to get bytes

; ================================
; Main Processing Loop
;	r8 -> i (y's)
;	r9 -> j (x's)
	mov		r8d,	1	; i = 1
forILoop:
	cmp		r8d,	esi	; compering against image height
	jz		endForILoop
	xor		r9d,	r9d
forJLoop:
	cmp		r9d,	r8d			; j < i
	jz		endForJLoop

	; rdi  => arr			
	; r10 => byte width 	
	; r11 => x
	; r12 => y

	; Position and mask of (j, i) [x, y] pixel
	; Byte width stack arg: r10
	; Array stack arg:		rdi
	; Reg arguments: x, y:
	mov		r11d,	r9d
	mov		r12d,	r8d
	; Function Call
	call	getPositon
	; Returns:
	; eax - arr pos, cl - mask
	; saving them for later (in register that are not modified by getPosition routine)
	mov		rbx,	rax
	mov		dl,		cl

	; Position and mask of (i, j) [y, x] pixel
	; Byte width stack arg: r10
	; Array stack arg:		rdi
	; Reg arguments: x, y:
	mov		r11d,	r8d
	mov		r12d,	r9d
	; Function Call
	call	getPositon
	; Returns:
	; rax - arr pos, cl - mask
	mov		dh,		cl
	
	; have pos of first pixel at rbx
	; pos of second at rax
	; mask of first in dl and of second in cl

	; movePixel argumentS:
	; r12b - byte of source = rbx
	; rax - position of dest = rax
 	; dl - mask of source, dh - mask of dest
	mov		r11b,	[rax]	; saving bute from dest
	mov		r12b,	[rbx]
	call movePixel

	; r12b - byte of source = eax
	; eax - position of dest = esi
 	; dl - mask of source, dh - mask of dest
	mov		r12b,		r11b
	mov		rax,	rbx
	mov		ch,		dl
	mov		dl,		dh
	mov		dh,		ch
	call movePixel

	; === END OF LOOP J ===
	inc		r9d
	jmp		forJLoop
endForJLoop:
	; === END OF LOOP I ===
	inc		r8d
	jmp		forILoop
endForILoop:

;======== mian loop end =======


; ; restoring save registers
	pop		r12
	pop		rbx

	;EPILOGUE
	pop		rbp
	ret


;////////////////////////////////////////
;/////////    FUNCTIONS   ///////////////
;////////////////////////////////////////

; Function that returns adress of byte with given pixel and the mask
getPositon:
	push	rbp
	mov		rbp, 	rsp

	; using rdx, r10, rbx, r12 as arguments passed to functions
	; rdi  => arr			
	; r10 => byte width 	
	; r11 => x
	; r12 => y

	; Getting x offset
	mov		ecx,	r11d 	; x
	and		ecx,	7		; % 8
	mov		al,		cl		; saving x offset in bl
	neg		ecx
	add		ecx,	r11d
	sar		ecx,	3		 ; getting byte x position x /= 8

	imul	r12d,	r10d	;(byteWidth * bitY)
	add		r12d,	ecx		;byteX += (byteWidth * bitY);

	add		r12,	rdi		; getting array position
	; Mask caclulationg
	mov		ch,		1
	mov		cl,		7
	sub		cl,		al
	shl		ch,		cl		; shiftings of 1
	mov		cl,		ch

	mov		rax,	r12
	; rax - arr pos
	; cl - mask
exit:
	pop 	rbp
	ret

; //////////////////////////////////////////////
; Function that puts value of pixel from source to destination
; whats important, it does no modifies any registers!
movePixel:
	push	rbp
	mov		rbp,	rsp

	; r12b - source byte
	; rax - position of destination
 	; dl - mask source, dh - mask dest

	mov		ch,		[rax]
	mov		cl,		r12b
	and		cl,		dl
	jz		saveZero

	or		ch,		dh
	jmp		saveAfter

saveZero:
	mov		cl,		dh
	not		cl
	and		ch,		cl

saveAfter:
	mov		[rax],	ch

	pop		rbp
	ret