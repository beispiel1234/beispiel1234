%define SYS_WRITE	1
%define SYS_EXIT	60
%define STDOUT		1

section .data
newline db 0x0a
I db 'I'
V db 'V'
X db 'X'
L db 'L'
C db 'C'
D db 'D'
M db 'M'
error db "ERROR: no input"
errorl equ $-error
error2 db "ERROR: only one arg allowed"
error2l equ $-error2
error3 db "ERROR: input only numbers"
error3l equ $-error3

section .bss

result resb 100

section .text
	global _start
	
;;-----------------------------------------------------------------
cwI:
	call writeI
	jmp back
cwII:
	call writeI
	call writeI
	jmp back
cwIII:
	call writeI
	call writeI
	call writeI
	jmp back
cwIV:
	call writeI
	call writeV
	jmp back
cwV:
	call writeV
	jmp back
cwVI:
	call writeV
	call writeI
	jmp back
cwVII:
	call writeV
	call writeI
	call writeI
	jmp back
cwVIII:
	call writeV
	call writeI
	call writeI
	call writeI
	jmp back
cwIX:
	call writeI
	call writeX
	jmp back
cwX:
	call writeX
	jmp back1
cwXX:
	call writeX
	call writeX
	jmp back1
cwXXX:
	call writeX
	call writeX
	call writeX
	jmp back1
cwXL:
	call writeX
	call writeL
	jmp back1
cwL:
	call writeL
	jmp back1
cwLX:
	call writeL
	call writeX
	jmp back1
cwLXX:
	call writeL
	call writeX
	call writeX
	jmp back1
cwLXXX:
	call writeL
	call writeX
	call writeX
	call writeX
	jmp back1
cwXC:
	call writeX
	call writeC
	jmp back1


cwC:
	call writeC
	jmp back10
cwCC:
	call writeC
	call writeC
	jmp back10
cwCCC:
	call writeC
	call writeC
	call writeC
	jmp back10
cwCD:
	call writeC
	call writeD
	jmp back10
cwD:
	call writeD
	jmp back10
cwDC:
	call writeD
	call writeC
	jmp back10
cwDCC:
	call writeD
	call writeC
	call writeC
	jmp back10
cwDCCC:
	call writeD
	call writeC
	call writeC
	call writeC
	jmp back10
cwCM:
	call writeC
	call writeM
	jmp back10
	
cwM:
	call writeM
	jmp cwMb
cwM10:
	xor r9,r9
	mov r9, 10
cc:
	call writeM
	dec r9
	cmp r9, 0
	jg cc
	dec r8
	jmp print

cwM100:
	xor r9,r9
	mov r9, 100
dd:
	call writeM
	dec r9
	cmp r9,0
	jg dd
	dec r12
	jmp print
	
cwM1000:
	xor rbx,rbx
	mov rbx, 1000
ee:
	call writeM
	dec rbx
	cmp rbx, 0
	jg ee
	dec r9
	jmp print
	
;;hier ist der Anfang
	
calc:
	call getl
	

	xor r15,r15
	mov r15, r11
pos:
	cmp r15, 1
	je enter
	inc r10
	dec r15
	jmp pos

enter:

	xor r13, r13
	mov r13, [r10]
	and r13, 0x0000000f
	
	xor al, al
	mov al, byte [r10]
	cmp al, 0x30
	jl writeError3
	cmp al, 0x39
	jg writeError3
	
	xor r14,14
	xor r15, r15
	xor rbx, rbx
	xor r8, r8
	xor r12, r12
	xor r9, r9
	cmp r11,2
	jl print
	mov r14, [r10-1]
	and r14, 0x0000000f
	
	xor al, al
	mov al, byte [r10-1]
	cmp al, 0x30
	jl writeError3
	cmp al, 0x39
	jg writeError3
	
	cmp r11,3
	jl print
	mov r15, [r10-2]
	and r15, 0x0000000f
	
	xor al, al
	mov al, byte [r10-2]
	cmp al, 0x30
	jl writeError3
	cmp al, 0x39
	jg writeError3
	
	cmp r11,4
	jl print
	mov rbx, [r10-3]
	and rbx, 0x0000000f
	
	xor al, al
	mov al, byte [r10-3]
	cmp al, 0x30
	jl writeError3
	cmp al, 0x39
	jg writeError3
	
	cmp r11, 5
	jl print
	xor r8, r8
	mov r8, [r10-4]
	and r8, 0x0000000f
	
	xor al, al
	mov al, byte [r10-4]
	cmp al, 0x30
	jl writeError3
	cmp al, 0x39
	jg writeError3
	
	cmp r11, 6
	jl print
	mov r12, [r10-5]
	and r12, 0x0000000f
	
	xor al, al
	mov al, byte [r10-5]
	cmp al, 0x30
	jl writeError3
	cmp al, 0x39
	jg writeError3
	
	cmp r11, 7
	jl print
	mov r9, [r10-6]
	and r9, 0x0000000f
	
	xor al, al
	mov al, byte [r10-6]
	cmp al, 0x30
	jl writeError3
	cmp al, 0x39
	jg writeError3
	

print:
;;M zählen
	cmp r9,1
	jge cwM1000
	
print100M:

	cmp r12,1
	jge cwM100
	
	
print10M:

	cmp r8, 1
	jge cwM10

	

print9M:
	cmp rbx, 0
	je back100


	cmp rbx, 1
	jge cwM
cwMb:	
	dec rbx
	jmp print9M

	
	
	
	

back100:
	
	cmp r15, 1
	je cwC
	cmp r15, 2
	je cwCC
	cmp r15, 3
	je cwCCC
	cmp r15, 4
	je cwCD
	cmp r15, 5
	je cwD
	cmp r15, 6
	je cwDC
	cmp r15, 7
	je cwDCC
	cmp r15, 8
	je cwDCCC
	cmp r15, 9
	je cwCM
	
back10:
	
	cmp r14, 1
	je cwX
	cmp r14, 2
	je cwXX
	cmp r14, 3
	je cwXXX
	cmp r14, 4
	je cwXL
	cmp r14, 5
	je cwL
	cmp r14, 6
	je cwLX
	cmp r14, 7
	je cwLXX
	cmp r14, 8
	je cwLXXX
	cmp r14, 9
	je cwXC
	
back1:
	cmp r13, 1
	je cwI
	cmp r13, 2
	je cwII
	cmp r13, 3
	je cwIII
	cmp r13, 4
	je cwIV
	cmp r13, 5
	je cwV
	cmp r13, 6
	je cwVI
	cmp r13, 7
	je cwVII
	cmp r13, 8
	je cwVIII
	cmp r13, 9
	je cwIX
	

back:
	call write_newline
	ret

;;-------------------------------------------------------------
writeI:
	mov rax, 1
	mov rdi, 1
	lea rsi, [I]
	mov rdx, 1
	syscall

	ret

;;------------------------------------------------------------------------------------
writeV:
	mov rax, 1
	mov rdi, 1
	lea rsi, [V]
	mov rdx, 1
	syscall

	ret

;;--------------------------------------------------------------------
writeX:
	mov rax, 1
	mov rdi, 1
	lea rsi, [X]
	mov rdx, 1
	syscall

	ret

;;--------------------------------------------------------------------
writeC:
	mov rax, 1
	mov rdi, 1
	lea rsi, [C]
	mov rdx, 1
	syscall

	ret

;;--------------------------------------------------------------------
writeD:
	mov rax, 1
	mov rdi, 1
	lea rsi, [D]
	mov rdx, 1
	syscall

	ret

;;--------------------------------------------------------------------
writeL:
	mov rax, 1
	mov rdi, 1
	lea rsi, [L]
	mov rdx, 1
	syscall

	ret

;;--------------------------------------------------------------------
writeM:
	mov rax, 1
	mov rdi, 1
	lea rsi, [M]
	mov rdx, 1
	syscall

	ret

;;--------------------------------------------------------------------
getl:
	cmp [r12], byte 0
	je found
	inc r11		;;counter
	inc r12
	jmp getl

found:
	
	ret
;;------------------------------------------------------------------------------------------
write_newline:

	mov	rax, SYS_WRITE	; write syscall
	mov	rdi, STDOUT	; fd = 1 (stdout)
	mov	rsi, newline	; string
	mov	rdx, 1		; length
	syscall
	ret
	
;;----------------------------------------------------------------------------------------------
writeError:
	mov rax, 1
	mov rdi, 1
	lea rsi, error
	mov rdx, errorl
	syscall
	
	call write_newline
	
	jmp end
;;----------------------------------------------------------------------------------------------
writeError2:
	mov rax, 1
	mov rdi, 1
	lea rsi, error2
	mov rdx, error2l
	syscall
	
	call write_newline
	
	jmp end
;;-----------Main------------------------------------------------------------------
writeError3:
	mov rax, 1
	mov rdi, 1
	lea rsi, error3
	mov rdx, error3l
	syscall
	
	call write_newline
	
	jmp end
;;-----------Main------------------------------------------------------------------
_start:
	pop r8
	cmp r8, 2
	jg writeError2
	pop r9
	pop r9
	mov r12, r9
	mov r10,r9
	
	cmp r9, 0
	je writeError
	
	call calc
	
end:
	mov rax, 60
	mov rdi, 0
	syscall
