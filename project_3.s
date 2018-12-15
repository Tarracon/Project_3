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
			
			StoreChars:
				lb $a1, 0($a0)
				addi $a0, $a0, 1
				beq $a1, 10, storePowers
				beq $a1, 0, storePowers
				beq $a1, 32, SeenSpaceandChar
				bne $a1, 32, SeeingChars
				j StoreChars
		SeenSpaceandChar:
			li $t1, 1			#Boolean for having seen a space after a char is True
			addi $t2, $t2, 1 	#incrementing counter for letters and spaces after letters
			j StoreChars
		SeeingChars:
			addi $t2, $t2, 1			#counter for letters and spaces incremented by 1
			addi $t3, $t3, 1 			#counter for letters increment by 1
			addi $t4, $t4, 1			#incrementing address of valid chars array
			beq $t1, 1, invalidInputB 	#if we see a character after seeing spaces and chars, ruled invalid
			beq $t3, 5, longInputB 		#jump to say that the input is too long and exit
			sb $a1, 0($t4)
			move $s3, $t3
			j StoreChars
	storePowers:
		beq $t3, 0, call_subprog
		sw $s1,  powerStorage($t7)
		mul $s1, $s1, $s0
		addi $t3, $t3, -1
		addi $t7, $t7, 4
		j storePowers
call_subprog:
	addi $sp, $sp, -12
	sw $t5, 0($sp)		#power array
	sw $t4, 4($sp)		#char array
	sw $s3, 8($sp)		#length
	
	jal ChangeBase
	
	lw $a0, 0($sp)
	addi $sp, $sp, 4
		
	li $v0, 1 #prints contents of a0
	syscall
	
	li $v0,10 	#ends program
	syscall
		
	jr $ra	
.globl ChangeBase
ChangeBase:
		lw $a1, 0($sp) 		#power array
		lw $a0, 4($sp)		#char array
		lw $a3, 8($sp)		#length
		addi $sp, $sp, 12
		
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $s7, 4($sp)
	
		beq $a3, 0, return_num
		
		lb $t0, 0($a0) 	#curr char
		lw $t1, ($a1)	#curr power
		
		addi $a0, $a0, -1
		addi $a1, $a1, 4
		
		addi $a3, $a3, -1
		check_string:
			bgt $t0, 121, invalidInputB	
			bgt $t0, 96, lowerB						#checks if character is between 97 and 117
			bgt $t0, 89, invalidInputB 				#checks if character is between 76 and 96
			bgt $t0, 64, upperB 					#checks if character is between 58 and 64
			bgt $t0, 57, invalidInputB 				#checks if character is between 48 and 57
			bgt $t0, 47, numberB					#checks if character is before 0 in ASCII chart
			j invalidInputB
		lowerB:
			addi $t0, $t0, -87 	#subtracts 87 from the ASCII value
			j multiply
		upperB:
			addi $t0, $t0, -55 	#subtracts 48 from the ASCII value
			j multiply
		
		numberB:
			addi $t0, $t0, -48 	#subtracts 48 from the ASCII value
			j multiply
			
		multiply:
			mul $s7, $t1, $t0 

			addi $sp, $sp, -12
			sw $a1, 0($sp) 		#power array
			sw $a0, 4($sp)		#char array
			sw $a3, 8($sp)		#length
			
			jal ChangeBase
			
			lw $v0, 0($sp)
			addi $sp, $sp, 4
			add $v0, $s7, $v0 
			
			lw $ra, 0($sp)
			lw $s7, 4($sp)
			addi $sp, $sp, 8

			addi $sp, $sp, -4
			sw $v0, 0($sp)
						
			jr $ra
		return_num:
			li $v0, 0
			lw $ra, 0($sp)
			lw $s7, 4($sp)
			addi $sp, $sp, 8
			
			addi $sp, $sp, -4
			sw $v0, 0($sp)
			
			jr $ra
invalidInputB:
	bgt $t2, 4, longInputB
	
	la $a0, invalidInput
	li $v0, 4
	syscall 
	
	li $v0, 10
	syscall
