%define SYS_WRITE	1
%define SYS_EXIT	60
%define STDOUT		1


section .data

newline db 0x0a
text db "decimal number = "
textl equ $ - text
text2 db "hexadecimal number = 0x"
textl2 equ $ - text2
text3 db "ERROR: invalid decimal number"
textl3 equ $ - text3


section .bss


outbuf resb 8
num resb 8
outbuf2 resb 1

buf resb 2

section .text
	global _start


;;------------------------------------------------------------------------------------------
write_e:
	call write_newline

	mov rax, 1
	mov rdi, 1
	mov rsi, text3
	mov rdx, textl3
	syscall
	
	call write_newline
	call end
	
;;-------------------------------------------------------------------------
write_eon:
	mov rax, 1
	mov rdi, 1
	mov rsi, text3
	mov rdx, textl3
	syscall
	
	call write_newline
	call end
;;-------------------------------------------------------------------------
write_argument:
	mov	rax, SYS_WRITE	; write syscall
	mov	rdi, STDOUT	; fd = 1 (stdout)
	
	mov	rdx, 0		; count bytes
	
	push r9
	
	search_eos:
	;; here we have to specify the string size (byte) 
	cmp	[r9], byte 0	; end of string (0) reached?
	je	eos_found	; yes, end of loop
	inc	rdx		; count

	inc	r9		; next position in string
	jmp	search_eos
eos_found:
	pop	rsi
	syscall
	
	cmp rdx, 9
	je write_e
	
	ret
	
;;------------------------------------------------------------------------------------------
write_newline:

	mov	rax, SYS_WRITE	; write syscall
	mov	rdi, STDOUT	; fd = 1 (stdout)
	mov	rsi, newline	; string
	mov	rdx, 1		; length
	syscall
	ret
	

;;-------------------------------------------------------------------------------
write_d:

	mov rax, 1
	mov rdi, 1
	mov rsi, text
	mov rdx, textl
	syscall
	ret
;;------------------------------------------------------------------------------------------
write_h:

	

	;;error falsche eingabe
	cmp [r10], byte '0'
	jl write_eon
	cmp [r10], byte '9'
	jg write_eon
	inc r10
	cmp [r10], byte 0
	je noe
	jmp write_h

noe:

	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, textl2
	syscall
	

	ret
;;--------------------------------------------------------------------------
getl:
	cmp [r12], byte 0
	je found
	inc r11		;;counter
	inc r12
	jmp getl

found:
	
	ret

;;----------------------------------------------------------------
mul10:
	imul r12,10
	jmp back
mul100:
	imul r12, 100
	jmp back
mul1000:
	imul r12, 1000
	jmp back
mul10000:
	imul r12, 10000
	jmp back
mul100000:
	imul r12, 100000
	jmp back
mul1000000:
	imul r12, 1000000
	jmp back
mul10000000:
	imul r12, 10000000
	jmp back
mul100000000:
	imul r12, 100000000
	jmp back
mul1000000000:
	imul r12, 1000000000
	jmp back
calc:

;;länge des String bestimmen
	xor r11, r11
	call getl
;;in hex umrechnen
;;zahl ist an der stelle r13 in asci mit der länge r11(dezimal-zeichen)
	xor r15,r15
	mov r15, r11
	xor r9, r9	;;zähler von hinten
	

	xor r12, r12
	mov r12, [r13+r15-1]
	and r12, 0x000000ff
	sub r12, 48
	mov r14, r12
read:
	inc r9
	dec r15
	cmp r15, 0
	je toHex
	mov r12, [r13+r15-1]
	and r12, 0x000000ff
	sub r12, 48

	cmp r9,1
	je mul10
	cmp r9,2
	je mul100
	cmp r9, 3
	je mul1000
	cmp r9, 4
	je mul10000
	cmp r9, 5
	je mul100000
	cmp r9, 6
	je mul1000000
	cmp r9, 7
	je mul10000000
	cmp r9, 8
	je mul100000000
	cmp r9, 9
	je mul1000000000
back:
	add r14, r12
	cmp r15, 0
	je toHex
	jmp read
	
	
toHex:
	
	xor r12, r12
	mov r12,r14
	xor r14, r14
	mov r14, r12

	xor r10, r10
	mov r10, 7


	mov [outbuf], byte 0x30
	mov [outbuf+1], byte 0x30
	mov [outbuf+2], byte 0x30
	mov [outbuf+3], byte 0x30
	mov [outbuf+4], byte 0x30
	mov [outbuf+5], byte 0x30
	mov [outbuf+6], byte 0x30
	mov [outbuf+7], byte 0x30
	mov [outbuf+8], byte 0x30

toAsci:
	and r14, 0x0000000f
	cmp r14, 9
	jg isLetter
	jmp isNumber
isNumber:
	add r14, 48
	jmp continue
isLetter:
	add r14, 87
continue:
	
	mov [outbuf+r10], byte r14b		;;es hat funktioniert
	dec r10
	dec r11
	cmp r11, 0
	je write_hex
	xor r14, r14
	shr r12, 4
	mov r14, r12
	jmp toAsci

write_hex:

	mov rax, 1
	mov rdi, 1
	lea rsi, [outbuf]
	mov rdx, 8
	syscall
	
	
	ret

;;------------------------------Main-------------------------------------------------------------
_start:
	pop r8 ;;Anzahl der Argumente
	pop r9 ;;Name des Programmes
	pop r9 ;;erstes eingegebenes Argument
	mov r10, r9	;;hier fängt die Zahl an
	mov r12, r9
	mov r13, r9
	
	call write_d
	call write_argument
	call write_newline
	call write_h
	call calc
	call write_newline
end:
	mov rax, 60
	mov rdi, 0
	syscall
