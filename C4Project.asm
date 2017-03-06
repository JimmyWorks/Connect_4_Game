
		.data
GameBoard:	.space	42		#reserves a block of 42 bytes
ClCount:	.word	0,0,0,0,0,0,0 	#Array of Tokens per Column
#======================== Player Markers ===========================================
#Use these to load marker ascii values and also the values to check for player or computer turn
Player:		.word   79		#Player marker and also ascii value for 'O'
Computer:	.word	88		#Computer marker and also ascii value for 'X'
#===================================================================================
WinCondBool:	.byte	0		#1 if true, 0 if false
PlayerMovePrompt:	.asciiz		"Please pick a column: \n"
SystemError:	.asciiz			"Program has encountered a system error. \n"
FullColMsg:	.asciiz			"That column is full.  Try again. \n"
InvalidMoveMsg:	.asciiz			"Invalid move; please try again. \n"
InvalidCompMoveMsg:	.asciiz		"Computer has made an invalid move. \n"
ColumnHeader:	.asciiz			" 1 2 3 4 5 6 7 \n"
WinMessage:	.asciiz			"Game Over! \n"
Thankyou	.asciiz			"Do you wish to play again \n Enter 0 to exit \n Enter 1 to try again"
		.globl	main
		.text		
		
#============================== Notes ==============================================
#	$s0 = used globally to keep track of current turn
#	    = 79 for player turn
#	    = 88 for computer turn
#	$s1 = used globally to keep track of selected input column, regardless of
#	    	player or computer turn
#===================================================================================

main:
	jal InitializeGameBoard		#Call initializeGameBoard Method
	jal PrintBoard			#print the initial blank board
	GameLoop1:
	jal PlayerMove		#Call PlayerMove Method
	jal PrintBoard
	jal CheckWinCondition
	lb	$t0, WinCondBool
	beq	$t0,1, DisplayWin
	GameLoop2:
	jal ComputerMove
	jal PrintBoard
	jal CheckWinCondition
	lb	$t0, WinCondBool
	beq	$t0,1, DisplayWin	
	j	GameLoop1
		
InitializeGameBoard:
	li	$t0, 0			#load zero into $t0 for counter
	li	$t1, 95			#load ascii code for '_' into $t1
	IGBLoop1:	
	la	$t2, GameBoard		#stores the address of GameBoard into $t2
	add	$t2, $t2, $t0		#adds the offset to the stored address
	sb	$t1,($t2)		#store '_' character into GameBoard with offset $t0
	addi	$t0, $t0, 1		#incrament the counter by 1
	bne	$t0, 42, IGBLoop1	#loop until all 42 slots are filled
	jr	$ra		

PlayerMove:
	lw	$s0, Player		#loads the ascii value for 'O' into $s0
	li	$v0, 4			#system call code for Print String
	la	$a0,PlayerMovePrompt  	#load address of Player move prompt
	syscall				#print User input prompt
	
	li	$v0, 5			#system call code for Read Integer
	syscall				#Read user input
	
	add	$s1, $v0, $zero		#store input to $t0
	j	CheckValidMove		#Check if the move is valid
	
ComputerMove:
	lw	$t0, Computer		#load ascii value for x
	add	$s0, $t0, $zero		#put Computer ascii 'X' into $s0
	
	li	$v0, 42			#system call code for Random integer in range
	li	$a0,100			#load i.d. of pseudorandom number generator
	li	$a1,7  			#load immediate of upper bound of random number
	syscall				#get random number
	addi	$s1, $a0, 1		#store random number into $s1	
	j	CheckValidMove
	
CheckValidMove:	
	#switch for user input
	beq	$s1, 1, NewMove
	beq	$s1, 2, NewMove
	beq	$s1, 3, NewMove
	beq	$s1, 4, NewMove
	beq	$s1, 5, NewMove
	beq	$s1, 6, NewMove
	beq	$s1, 7, NewMove
	
InvalidInput:				#this label is used by different jump calls, but is also automatically executed if CheckValidMove fails
	beq	$s0, 79, InvalidPlayerMove
	beq	$s0, 88, InvalidCompMove	
	j	LogicalError		#print system error if $s0 is not player or computer
	
InvalidPlayerMove:	
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalidMoveMsg  	#load address of invalid move message
	syscall				#print invalid move message	
	j	PlayerMove		#return

InvalidCompMove:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalidCompMoveMsg  #load address of invalid move message
	syscall				#print invalid move message	
	j	ComputerMove		#return
	
NewMove:	
	addi    $s2, $s1, -1 		#Gets current move's index $s2 is the current index
	mul	$t4, $s2, 4		#This is the index offset for word
	lw	$t0, ClCount($t4)	#Store height of the column in t0 
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add 	$t1, $t1, $s2		#Adds column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount($t4)		#store updated count of column 1 into memory
	jr	$ra			#return
	
FullColumn:
	li	$v0, 4			#system call code for Print String
	la	$a0,FullColMsg  	#load address of invalid move message
	syscall				#print invalid move message
	j	InvalidInput
		

PrintBoard:
	li	$t0, 35			#sets $t0 to 35
	
	li	$v0, 4			#system call code for Print String
	la	$a0,ColumnHeader  	#load address of Coulun Header
	syscall				#print Column Header
	
	PBloop1:	
	la	$t1, GameBoard		#stores the address of GameBoard into $t1
	add	$t1, $t1, $t0		#adds the offset to the stored address
		
	li	$v0, 11			#system call code for Print Character
	li	$a0,124  		#load immediate of ascii code for '|'
	syscall				#print '|'
	
	li	$v0, 11			#system call code for Print Character
	lb	$a0,($t1)		#load ascii code stored in offset index of GameBoard
	syscall				#print
	
	div	$t2, $t0, 7		#divide offset by 7 to determine location
	mfhi	$t2			#put the remainder into $t2
	
	beq	$t2, 6, PBloop2		#if the remainder is 6 go to loop2
	
	addi	$t0, $t0, 1		#incrament counter by 1
		
	bne	$t0, 6, PBloop1
	
	#This exists to print the last item
	li	$v0, 11			#system call code for Print Character
	li	$a0,124  		#load immediate of ascii code for '|'
	syscall				#print '|'
	
	li	$v0, 11			#system call code for Print Character
	lb	$a0,GameBoard+6		#load ascii code stored in offset index of GameBoard
	syscall				#print
	
	li	$v0, 11			#system call code for Print Character
	li	$a0,124  		#load immediate of ascii code for '|'
	syscall	
	
	li	$v0, 11			#system call code for Print Character
	li	$a0,10  		#load immediate of ascii code for new line
	syscall				#print new line
	
	jr	$ra
	
	PBloop2:
	li	$v0, 11			#system call code for Print Character
	li	$a0,124  		#load immediate of ascii code for '|'
	syscall				#print '|'
	
	li	$v0, 11			#system call code for Print Character
	li	$a0,10  		#load immediate of ascii code for new line
	syscall				#print new line
	
	subi	$t0, $t0, 13		#decrement counter by 13
	
	bne	$t0, 6, PBloop1
	jr	$ra

CheckWinCondition:
	# $s0 holds the marker: Computer is ascii value 88 for 'X' and Player is ascii value 
	jr	$ra

DisplayWin:


	j	EndGame

EndGame:
	li	$v0, 4			#system call code for Print String
	la	$a0,Thankyou  	#load address of Player move prompt
	syscall				#print User input prompt
	
	li	$v0, 5			#system call code for Read Integer
	syscall				#Read user input
	
	add	$s1, $v0, $zero		#store input to $t0
	beq	$s1, 1, main		#return to begining (NOT DONE)
	
	li      $v0, 10              # terminate program run and
  	syscall                      # Exit
	
LogicalError:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalidCompMoveMsg 	#load address of error prompt
	syscall				#print error prompt	
