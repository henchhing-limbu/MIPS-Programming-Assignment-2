.data
	prompt: .asciiz "Enter a string: "
	userInput: .space 1001
	errorMessage: .asciiz "NaN"
.text
	main:
		#dsiplays the prompt saying the user to input data
		li $v0, 4 		#tells the system to be ready for printing string
		la $a0, prompt          #loads address of prompt to $a0
		syscall			#prints the string
		
		#gets input from the user
		li $v0, 8
		la $a0, userInput	#loads the address of the userInput in $a0
		li $a1, 1001		#specifies the number of bytes to read
		syscall
		
		#reading character in a string
		la $s1, userInput	#loads the address of the first character of the userInput in $s1
		lb $t1, 0($s1)		#loads the first character into $t1
		beq $t1, 10, noInput	#branches to noInput if $t1 == end of line
		
		li $t6, 0				 #initializing $t6 to be 0
		li $t5, 0 				 #initializing $s2 to be 0
		li $t1, 0				 #used for knowing the last substring
		loop:
			#checks for spaces at the front and end of string and removes it
			loopTempEnd:
				add $t0, $s1, $t6		 #adds contents of $t6 and $s1 and stores it in $t0
				lb $t2, 0($t0)   	 	 #loads the content stored in $t0 to $t2
				beq $t2, $zero, lastSubString	 
				beq $t2, 10, lastSubString
				beq $t2, 44, loopStartIndex
				addi $t6, $t6, 1
				j loopTempEnd		 	
			#tempEnd is in $t6
			
			#used for knowing the last substring
			lastSubString:
				addi $t1,$t1, 1			 #$t1 = $t1 + 1
				j loopStartIndex

			#gives the proper starting index of sub-string
			loopStartIndex:
				add $t0, $s1, $t5		 #adds $s1 and $s2 and stores it in $t0
				lb $t2, 0($t0)			 #loads the content of $t0 into $t2
				beq $t2, 9, continue		 #jumps to cont if $t2 == tab
				beq $t2, ' ', continue		 #jumps to cont if character is space
				j loopEndIndex			 #jumps to loopEndIndex
				continue:	
				addi $t5, $t5, 1		 #adds 1 to $s2 and stores it in $s2
				j loopStartIndex		 #jumps back to loopStartIndex
  			#startIndex is in $t5
  			
  			#gives the address of the last character of the substring
  			addi $t4, $t6, 0 			 #adds $t6 and 0 and stores the value in $t4
  			loopEndIndex:
  				add $t0, $s1, $t4		 #adds $s1 and $t4 and stores in $t0		 
				lb $t2, 0($t0)			 #loads the char at $t0 into $t2
				beq $t2, 9, continue1
				beq $t2, ' ', continue1
				jal subProgram_2		
				beq $t1, 1, subProgram_3	 #goes to subProgram_3 if $t1 == 1
				continue1:	 
				addi $t4, $t4, -1
				j loopEndIndex
			#endIndex is in $t4
			
			addi $t6, $t6, 1			 #incrementing $t6 by 1
			addi $t5, $t6, 0			 #$t5 = $t6	
		
		
	#informs system to end main
	Exit:
		li $v0, 10
		syscall
	
	invalidString:
		li $v0, 4
		la $a0, errorMessage
		jr $ra
					
	#displays the errorMessage and jumps to Exit
	noInput:
		li $v0, 4
		la $a0, errorMessage	
		syscall
		j Exit
	
	#displays the output
	subProgram_3:
	
	#converts a single hexadecimal string to a decimal string		
	subProgram_2:
		sub $t3, $t4, $t5			 #subtracts $t4 from $t5 and stores the result in $t3
		li $t7, 8
		blt $t3, $t7, continue2			 #goes to continue2 if $t3 is less than $t7
		j invalidString				 #jumps to invalidString
		continue2:
		#-------------------------------------------------------------------
		#To be continued
			
	#checks validity of the characters	
	checkChar:
		bgt $t2, 102, invalid		 	 #jumps to invalid if value at $t5 > 102
		bgt $t2, 96, valid		 	 #jumps to valid if value at $t5 > 96
		bgt $t2, 70, invalid		 	 #jumps to invalid if value at $t5 > 70
		bgt $t2, 64, valid		 	 #jumps to valid if value at $t5 > 57
		bgt $t2, 57, invalid		 	 #jumps to invalid if value at $t5 > 57
		bgt $t2, 47, valid		 	 #jumps to valid if value at $t5 > 47
		j invalid			 	 #jumps to invalid
		
		invalid:
			li $v1, 0			 #initiates $v1 to be 0
			jr $ra
			
		valid:
			li $v1, 1			 #inititates $v1 to be 1
			jr $ra
	
	#converts hexadecimal number to its decimal value
	subprogram_1: 			 
		blt $t2, 58, conv1		 	 #branches to conv1 if value at $t5 < 58
		blt $t2, 71, conv2		 	 #branches to conv2 if value at $t5 < 71
		blt $t2, 103, conv3		 	 #branches to conv3 if value at $t5 < 103
		
		#converts hexadecimal values from 0-9 into decimal
		conv1:
			addi $t2, $t2, -48	 	 #adds -48 to  $t5 and stores it in $t5
			jr $ra	 			 #jumps to statements whose address is $ra
		
		#converts hexadecimal values from A-F into decimal values	
		conv2:
			addi $t2, $t2, -55	 	 #addis -55 to $t5 and stores it in $t5
			jr $ra
			
		#converts hexadecimal values from a-f into decimal values
		conv3:
			addi $t2, $t2, -87	 	 #adds -87 to $t5 and stores it in $t5
			jr $ra
