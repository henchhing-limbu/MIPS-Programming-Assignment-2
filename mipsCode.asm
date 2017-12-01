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
		#loading the address of first character and storing it
		la $s1, userInput	#loads the address of the first character of the userInput in $s1
		lb $t1, 0($s1)		#loads the first character into $t1
		beq $t1, 10, noInput	#branches to noInput if $t1 == end of line
		
		li $t6, 0				 #initializing $t6 to be 0 
							 #later used for storing end of substring
		li $t5, 0 				 #initializing $t5 to be 0
							 #later used for storing start of required substring
		li $t8, 0				 #used for moving the stack pointer
		#---------------------
		#goes through the userInput
		#divides the input into substrings for conversion
		loop:
			#checks for spaces at the front and end of string and removes it
			loopTempEnd:
				add $t0, $s1, $t6		 #adds contents of $t6 and $s1 and stores it in $t0
				lb $t2, 0($t0)   	 	 #loads the content stored in $t0 to $t2
				beq $t2, $zero, lastSubString	 #goes to lastSubStirng if $t2 is newline character 
				beq $t2, 10, lastSubString	 #goes to lastSubString if $t2 is endofline character
				beq $t2, 44, loopStartIndex	 #jumps to loopStartIndex if $t2 is ',' 
				addi $t6, $t6, 1		 #$t6 = $t6 + 1
				j loopTempEnd		 	 
			#tempEnd is in $t6
			#it's the end of the substring
			
			#used for knowing the last substring
			li $t1, 0				 #used to update if the substring is last or not
			lastSubString:
				addi $t1,$t1, 1			 #$t1 = $t1 + 1
				j loopStartIndex

			#gives the proper starting index of sub-string
			#the first character which is not space or tab
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
  			#it's the first character which is not space or tab
  			
  			#gives the address of the last character of the substring
  			#the last character is not the actual last character
  
  			loopEndIndex:
  				addi $t4, $t6, 0 			 #adds $t6 and 0 and stores the value in $t4
  				
  				#finds the last character which is not space or tab
  				endIndex:
  					add $t0, $s1, $t4		 #adds $s1 and $t4 and stores in $t0		 
					lb $t2, 0($t0)			 #loads the char at $t0 into $t2
					beq $t2, 9, continue1
					beq $t2, ' ', continue1
				
					#calls the sub_Program2
					#li $v0, 11
					#add $t0, $s1, $t4
					#lb $a0, 0($t0)
					#syscal
					
					#calls subProgram_2 whenever the character is not a space or a tab
					#conversion begins here
					jal subProgram_2		 
					
					#converted decimal value or errorMessage is in $s2
					#output is given by subProgram_3
					#beq $t1, 1, subProgram_3	 #goes to subProgram_3 if $t1 == 1
					jal subProgram_3
					
					continue1: 
					#decreses by 1 so as to check each character from behind	 
					addi $t4, $t4, -1
					j endIndex
			#endIndex is in $t4
			
			continue3:
			li $t5, 1			 	#jumps to exit the program
			beq $t1, $t5, Exit		 	#goes to Exit if $t1 == $t5 i.e. if it was the last Substring
					
			addi $t6, $t6, 1			 #points to next character after comma
								 #$t6 = $t6 + 1
			addi $t5, $t6, 0			 #$t5 = $t6	
			j loop
		
		#informs system to end main
		Exit:
			li $v0, 10
			syscall
					
	#displays the errorMessage and jumps to Exit
	noInput:
		li $v0, 4
		la $a0, errorMessage	
		syscall
		j Exit
	
	#displays the output
	subProgram_3:
		#loading data from the stack
		#we add 4 in this case
		#-----
		lw $t3, 0($sp)				#loads the word on stack to $t3		 
		addi $sp, $sp, 4			#moves the pointer to contiguous address of stack
		#--------
		#checks for overflow
		#checks for unsinged
		blt $t3, $zero, signedToUnsigned 	 #branch to signedToUnsigned if $t3 < $zero
		
		li $v0, 1			 	#syscall for printing integer
		addi $a0, $t3, 0		 	#adds contents of $t3 and 0 and stores in $a0
		syscall
		
		j continue3				 #jumps to Exit
			
		signedToUnsigned:
			li $t1, 10			 #initiates $t1 = 10
			divu $t3, $t1			 #divides $t4 by $t1
			mflo $t2			 #contents of $LO are moved to $t2
			move $a0, $t2 			 #moves contents of $a0 to $t2
			li $v0, 1			 #system call code for printing integer
			syscall

			mfhi $t2			 #contents of $HI are moved to $t2
			move $a0, $t2 			 #moves contents of $t2 to $a0
			li $v0, 1			 #system call code for priting integer
			syscall
			j continue3
	
	#stores errorMessage into $s2 and jumps and returns addres to where it was called
	invalidString:
		la $s2, errorMessage
		jr $ra
		
	#converts a single hexadecimal string to a decimal string	
	subProgram_2:
		li $s2, 0 				 #initializing $s2 to be 0
							 #the converted decimal value will be stored here
							 
		#checking the length of the substring and checking its validity
		sub $t3, $t4, $t5			 #subtracts $t4 from $t5 and stores the result in $t3
		
		li $t7, 9
		blt $t3, $t7, continue2			 #goes to continue2 if $t3 is less than $t7
		j invalidString				 #jumps to invalidString
		
		#loops through each character of the subtring
		continue2:
			add $t0, $s1, $t5
			lb $t2, 0($t0)			 #loads the char in $t5 to $t2
			jal checkChar			 #calls checkChar and returns value at $v1
			beq $v1, 0, invalidString	 #goes to invalidString if $v1 is 0
			jal subprogram_1
			sll $s2, $s2, 4			 #shift left $s2 by 1 byte
			add $s2, $s2, $t2
			addi $t5, $t5, 1		 #$t5 = $t5 + 1
			beq $t5, $t4, return		 #jumps back to loop
			j continue2
			
			#jumps back to where subProgram_2 was called with the stored value in $s2
			return:
			addi $sp, $sp, -4
			sw $s2, 0($sp)
			#addi $sp, $sp, -4
			#sw $v0, ($sp)
			#la $ra, ($s7)
			#jr $ra
			jr $ra
			
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
	#converts each character into decimal value
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
