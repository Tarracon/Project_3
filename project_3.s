.data
    longInput: .asciiz "Input is too long."
    emptyInput: .asciiz "Input is empty."
    invalidInput: .asciiz "Invalid base-35 number."

    userInput: .space 50000
    userInputStorage: .space 32
	powerStorage: .word 0:4
.text

.globl main
main:
		#prompting the user to input
		li $v0, 8
		la $a0, userInput
		li $a1, 50000
		syscall
		
		li $t0, 0 #Boolean
		li $t1, 0 #Boolean
		
		li $t7, 0 #handles my array
		
