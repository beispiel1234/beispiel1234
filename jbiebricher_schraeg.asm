; ===========================================================================
; 
; print_args64.asm --
; prints command line arguments to stdout
; (simplified version of use_args.asm for script)
;
; Ralf Moeller
; 
;    Copyright (C) 2007
;    Computer Engineering Group
;    Faculty of Technology
;    University of Bielefeld
;    www.ti.uni-bielefeld.de
; 
; 1.0 / 22. Mar 07 (rm)
; - from use_args.asm
; 1.1 / 11. Jun 08 (rm)
; - output of 0x00 char not required
; - label finish removed
; 1.2 / 24. Sep 13 (rm)
; - from print_args.asm, now for 64 bit
; 1.3 /  6. Oct 14 (rm)
; - corrected bug, see date-tag
; 1.4 /  9. Nov 23 (rm)
; - save and restore rcx and r11 (clobbered by syscall)
;       
; ===========================================================================

;;; system calls
%define SYS_WRITE	1
%define SYS_EXIT	60
;;; file ids
%define STDOUT		1
	
;;; start of data section
section .data
;;; a newline character
newline:
 	db 0x0a

;;; start of code section
section	.text
	;; this symbol has to be defined as entry point of the program
	global _start

;;;--------------------------------------------------------------------------
;;; subroutine write_newline
;;;--------------------------------------------------------------------------
;;; writes a newline character to stdout
	
write_newline:
	;; save registers that are used in the code
	push	rax
	push	rdi
	push	rsi
	push	rdx
	;; prepare arguments for write syscall
	mov	rax, SYS_WRITE	; write syscall
	mov	rdi, STDOUT	; fd = 1 (stdout)
	mov	rsi, newline	; string
	mov	rdx, 1		; length

        push 	rcx		; clobbered by syscall
	push	r11		; clobbered by syscall
	syscall			; system call
        pop	r11
	pop	rcx

	;; restore registers (in opposite order)
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
	ret
	
;;;--------------------------------------------------------------------------
;;; subroutine write_string
;;;--------------------------------------------------------------------------
;;; address of 0-terminated string passed in rsi
;;; operation: determines length of string and writes it in ONE write
;;; (plus a second write that appends a new-line character)

write_string:
	;; save registers that are used in the code
;;jetzt schreibt er den ersten Buchstaben jedes Arguments and die richtige stelle


	push rax
	push rdi
	
	push rdx
	push r8
	push r9
	push r10

	mov r8,1			;;länge der ausgabe
	mov r9,1
	

				;;länge des arguments herausfinden r9
	push rsi
search_eos:
	cmp [rsi], byte 0
	je eos_found
	inc rsi
	inc r9			;;länge des jeweiligen Arguments
	jmp	search_eos
eos_found:
	pop rsi
	
			
				;;schreiben vorbereiten
write_Letter:

	mov	rax, SYS_WRITE	
	mov	rdi, STDOUT	
	
	mov	rdx, r8
				


			
	syscall			;;schreibe einen Buchstaben
				
	call write_newline	;;schreibe eine neue Zeile
				
				;;bs durch leerzeichen ersetzen
	
	mov r10, r8
	dec r10
	mov byte [rsi+r10], ' '
				;;zum nächsten buchstaben übergehen
	inc r8				
	cmp r8,r9		;;beenden, falls länge des Arguemnts erreicht wurde
	je flagContinue
	jmp write_Letter
	
				

flagContinue:
	
	pop r10
	pop r9
	pop r8
	pop rdx
	pop rdi
	pop rax
	ret
	
	
	

;;;--------------------------------------------------------------------------
;;; main entry
;;;--------------------------------------------------------------------------

_start:
	pop r9			;; anzahl der arguemente wird in rbx gespeichert
	pop rsi			;;erste arguement 
	dec r9			;;anzahl wird um 1 verringert
	
	cmp r9, 0
	jz end
	
read_args:
	;; print command line arguments
	pop	rsi		; argv[j]
	
	
	call	write_string	; string in rsi is written to stdout



	
	dec	r9		; dec arg-index
	jnz	read_args	; continue until last argument was printed


	;; exit program via syscall exit (necessary!)
end:
	mov	rax, SYS_EXIT	; exit syscall
	mov	rdi, 0		; exit code 0 (= "ok")
	syscall 		; kernel interrupt: system call
