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
		addi $t2, $t2, 0 #counter for spaces in between letters
		addi $t3, $t3, 0 #counter for letters
		
		addi $s0, $s0, 35 	#static base register 
		addi $s1, $s1, 1 	#temp for powerStorage
		
		la $t4, userInputStorage
		la $t5, powerStorage
		Loop:
			lb $a1, 0($a0)
			addi $a0, $a0, 1
			beq $a1, 10, emptyInputB
			beq $a1, 0, emptyInputB
			beq $a1, 32, Loop
			addi $t0, $t0, 1	#Boolean for having seen a character is True
			sb $a1, 0($t4)		#put $a1 (first valid char) in char storage
			addi $t3, $t3, 1 	#counter for letters increment by 1
			addi $t2, $t2, 1	#counter for letters and spaces incremented by 1
			move $s3, $t3
