.data
	userPrompt: .asciiz "Enter the string: "
	userInput: .space 1001
.text
	main:
		#prints the userPrompt
		li $v0, 4
		la $a0, userPrompt
		syscall
		
		#gets userInput from the user
		li $v0, 8
		la $a0, userInput
		li $a1, 1001
		syscall
		
		#$sp - initializes to some address at the beginning of the program
