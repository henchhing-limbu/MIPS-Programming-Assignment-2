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
		#li $v0, 11		
		#syscall
		
		#addu $t0, $t0, 4
		#la $t0, userInput
		#lb $a0, ($t0)
		#li $v0, 11
		#syscall
		
		#------------------------------------------------------------------------------------------
		#li $t4, 0		#used for finding length of the sliced string
		#li $t5, 1		#loading 1 to $t5
		#li $t0, 0
		#strSlicer:
			lb $t2, 0($t0)
			beq $t2, 44, checkChar
		
		
	#informs system to end main
	Exit:
		li $v0, 10
		syscall
	
	noInput:
		li $v0, 4
		la $a0, errorMessage
		syscall
		j Exit
		
	subProgram_2:
		jal checkChar
		
		
		
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
