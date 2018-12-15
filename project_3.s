.data
invalid_length: .asciiz "Input is too long." #declare variables used to print error messages
wrong_base: .asciiz "Invalid base-35 number."
input_empty: .asciiz "Input is empty."
user_string: .space 40000
.text

main:

  li $v0, 8  #get user_input
  la $a0, user_string
  li $a1, 40000
  syscall
  add $t1, $0, 0 #initialize registers
  add $t2, $0, 0
  add $t7, $0, 2
  la $t0, user_string
  lb $t1,0($t0) #load first character of string
  #CHECKING IF INPUT IS EMPTY
  beq $t1, 10, Empty_Error
  beq $t1, 0 Empty_Error
  addi $s0, $0, 35
  addi $t4, $0, 1
  addi $t5, $0, 0
  addi $t6, $0, 0
ignore_spaces:
  lb $t1,0($t0)
  addi $t0, $t0, 1 #Start counter
  addi $t2, $t2, 1
  beq $t1, 32, ignore_spaces #if character is a space skip over it
  beq $t1, 10, Empty_Error
  beq $t1, $0, Empty_Error
see_first_chars:
  lb $t1,0($t0) #load first character
  addi $t0, $t0, 1
  addi $t2, $t2, 1
  beq $t1, 10, return_start #if character is a newline go back to start of the string
  beq $t1, 0, return_start #If character is null return to start
  bne $t1, 32, see_first_chars #If its a space look at the next character
see_rest_chars:
  lb $t1,0($t0) #Load first character
  addi $t0, $t0, 1
  addi $t2, $t2, 1
  beq $t1, 10, return_start
  beq $t1, 0, return_start
  bne $t1, 32, Wrong_Base_Error
  j see_some_more_chars_or_spaces #Continue to the rest of characters in the string
return_start:
  sub $t0, $t0, $t2     #restarting the pointer in char_array
  la $t2, 0             #restaring the counter
next_char:
  lb $t1,0($t0) #load character 
  addi $t0, $t0, 1 #start counter
  beq $t1, 32, next_char #if its a space load next character
  addi $t0, $t0, -1
string_length:
  lb $t1, ($t0)
  addi $t0, $t0, 1
  addi $t2, $t2, 1
  beq $t1, 10, loop_assist 
  beq $t1, 0, loop_assist
  beq $t1, 32, loop_assist 
  beq $t2, 5, Too_Long_Error #If string is greater than 5 indexes its too long
  j string_length
loop_assist: #Assist with counter tracking
  sub $t0, $t0, $t2
  sub $t2, $t2, $t4
  lb $t1, ($t0)
  sub $s1, $t2, $t4
Find_largest_exponent:
  beq $s1, 0, Ascii_converter #Bringing base to last power of the string
  mult $t4, $s0 #multiply base by its exponent
  mflo $t4
  sub $s1, $s1, 1
  j Find_largest_exponent
  multiply:
  mult $t1, $t4 #multiply ascii by number receive from power-base multiplication
  mflo $t5            #sub_sum
  add $t6, $t6, $t5     #final sum
  beq $t4, 1, Exit
  div $t4, $s0 #dividing t4 to the next power of base
  mflo $t4
  add $t0, $t0, 1
  lb $t1,0($t0)
  j Ascii_converter
Exit:
  move $a0, $t6 #moves sum to a0
  li $v0, 1 #prints contents of a0
  syscall
  li $v0,10 # Successfully ends program
  syscall
Ascii_converter:
  blt $t1, 48, Wrong_Base_Error #checks if character is before 0 in ASCII chart
  blt $t1, 58, Numbers #checks if character is between 48 and 57
  blt $t1, 65, Wrong_Base_Error #checks if character is between 58 and 64
  blt $t1, 90, Upper_Case #checks if character is between 65 and 85
  blt $t1, 97, Wrong_Base_Error #checks if character is between 76 and 96
  blt $t1, 122, Lower_Case #checks if character is between 97 and 121
  blt $t1, 128, Wrong_Base_Error #checks if character is between 118 and 127
Upper_Case:
  addi $t1, $t1, -55 #set register to start of ASCII for upper case letter
  j multiply
Lower_Case:
  addi $t1, $t1, -87 #set register to start of ASCII for lower case letter
  j multiply
Numbers:
  addi $t1, $t1, -48 #set register to start of ASCII for numbers
  j multiply
#BRANCHES FOR ERROR MESSAGES
Empty_Error:
  la $a0, input_empty #loads error message an empty string
  li $v0, 4
  syscall
  li $v0,10 #ends program
  syscall
Too_Long_Error:
  la $a0, invalid_length #loads error message for too long string
  li $v0, 4
  syscall
  li $v0,10 #ends program
  syscall
Wrong_Base_Error:
  la $a0, wrong_base #loads error message for a string of the wrong base
  li $v0, 4
  syscall
  li $v0,10 #ends program
  syscall
jr $ra 
