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
		#displays the input from the user (userInput)
		li $v0, 4
		la $a0, userInput
		syscall
		
		#reading character in a string
		la $t0, userInput
		lb $a0, ($t0)
		li $v0, 11
		syscall
		
		addu $t0, $t0, 4
		la $t0, userInput
		lb $a0, ($t0)
		li $v0, 11
		syscall
		
		
	#informs system to end main
	li $v0, 10
	syscall
