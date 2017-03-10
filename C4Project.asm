		.data
GameBoard:	.space	42		#reserves a block of 42 bytes
ClCount:	.word	0,0,0,0,0,0,0 	#Array of Tokens per Column
#======================== Player Markers ===========================================
#Use these to load marker ascii values and also the values to check for player or computer turn
Player:		.word   79		#Player marker and also ascii value for 'O'
Computer:	.word	88		#Computer marker and also ascii value for 'X'
#===================================================================================
WinCondBool:	.byte	0		#1 if true, 0 if false
PlayerMoveMsg:	.asciiz			"Please pick a column: \n"
SystemError:	.asciiz			"Program has encountered a system error. \n"
FullColMsg:	.asciiz			"That column is full.  Try again. \n"
InvalidMoveMsg:	.asciiz			"Invalid move; please try again. \n"
InvalComMovMsg:	.asciiz			"Computer has made an invalid move. \n"
ColumnHeader:	.asciiz			" 1 2 3 4 5 6 7 \n"
WinMsg:		.asciiz			"Game Over! \n"
Thankyou:	.asciiz			"Do you wish to play again \n Enter 0 to exit \n Enter 1 to try again"
		.globl	main
		.text		
		
#============================== Notes ==============================================
#	$s0 = used globally to keep track of current turn
#	    = 79 for player turn
#	    = 88 for computer turn
#	$s1 = used globally to keep track of selected input column, regardless of
#	    	player or computer turn
#	$s2 = win condition, 0 = no winner, 1 = player winner, 2 = computer winner
#	$s3 = current move's row index
#	$s4 = current move's column index
#	$s6 = 79, register holder for player token in ascii value.  Compare to $s0 for current turn
#	$s7 = 88, register holder for computer token in ascii value.  Compare to $s0 for current turn
#===================================================================================

main:
	lw	$s6, Player		#Holder for player token
	lw	$s7, Computer		#Holder for computer token
	
NewGame:
	jal InitializeGameBoard		#Call initializeGameBoard Method
	jal PrintBoard			#print the initial blank board
	lw	$s0, Player		#Set first turn to player by loading the ascii value for player token 'O' into $s0

GameLoop:
	jal	CurrentMove
	jal	PrintBoard
	jal 	CheckWinCondition
	jal	SwitchPlayers
	j	GameLoop

# end of GameLoop
	
SwitchPlayers:
	beq	$s0, $s6, SwitchToCPU
	beq	$s0, $s7, SwitchToPlayer
	j	LogicalError
		
	SwitchToCPU:
	add	$s0, $s7, $0	
	jr	$ra	
	SwitchToPlayer:
	add	$s0, $s6, $0
	jr	$ra
																		
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

CurrentMove:
	beq	$s0, $s6, PlayerMove
	beq	$s0, $s7, ComputerMove
	j	LogicalError
	
PlayerMove:

	li	$v0, 4			#system call code for Print String
	la	$a0,PlayerMoveMsg  	#load address of Player move prompt
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
	beq	$s0, $s6, InvalidPlayerMove
	beq	$s0, $s7, InvalidCompMove	
	j	LogicalError		#print system error if $s0 is not player or computer
	
InvalidPlayerMove:	
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalidMoveMsg  	#load address of invalid move message
	syscall				#print invalid move message	
	j	PlayerMove		#return

InvalidCompMove:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalComMovMsg  #load address of invalid move message
	syscall				#print invalid move message	
	j	ComputerMove		#return
	
NewMove:	
	addi    $s3, $s1, -1 		#Store current move's row index in $s3
	mul	$t4, $s3, 4		#This is the index offset for word
	lw	$t0, ClCount($t4)	#Store height of the column in t0
	add	$s4, $t0, $0		#Store current move's column index in $s4
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add 	$t1, $t1, $s3		#Adds column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount($t4)	#store updated count of column 1 into memory
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
#============================== Notes ==============================================
#	$s0 = used globally to keep track of current turn
#	    = 79 for player turn
#	    = 88 for computer turn
#	$s1 = used globally to keep track of selected input column, regardless of
#	    	player or computer turn
#	$s2 = win condition, 0 = no winner, 1 = player winner, 2 = computer winner
#	$s3 = current move's row index
#	$s4 = current move's column index
#	$s6 = 79, register holder for player token in ascii value.  Compare to $s0 for current turn
#	$s7 = 88, register holder for computer token in ascii value.  Compare to $s0 for current turn
#===================================================================================
	# Let $t0 be the counter for consecutive tokens, it will be initialized and reused for
	# every case: positive diagonal, negative diagonal, vertical and horizontal cases
	addi	$t0, $0, 1
#Create integer i for index in game board array and integer j for modified index checked

#Check vertical for win-condition
	#set j = i
	#while there is a token directly below of the position of last token, i.e. j is not index 0-6
	#compare the j - 7 token to the token of interest
	#if equal
		#vertical++
		#j - 7
	#else
		#break
	#if vertical > 4
		#return true

#Check horizontal for win-condition
	#set j = i
	#while there is a token directly right of the position of last token, i.e. j mod 7 is not 6
	#compare the j + 1 token to the token of interest
	#if equal
		#horizontal++
		#j + 1
	#else
		#break
	#set j = i
	#while there is a token directly left of the position of the last token, i.e. j mod 7 is not 0
	#compare the j - 1 token to the token of interest
	#if equal
		#horizontal++
		#j - 1
	#else
		#break
	#if horizontal > 4
		#return true

#Check negative diagonal for win-condition
	#set j = i
	#while there is a token directly left-above of the position of last token, i.e. j mod 7 is not 0 AND j is not index 35-41
	#compare the j + 6 token to the token of interest
	#if equal
		#negativeD++
		#j + 6
	#else
		#break
	#set j = i
	#while there is a token directly right-below of the position of last token, i.e. j mod 7 is not 6 AND j is not index 0-6
	#compare the j - 6  token to the token of interest
	#if equal
		#negativeD++
		#j - 6
	#else
		#break
	#if negativeD++ > 4
	#return true

#Check positive diagonal for win-condition
	#set j = i
	#while there is a token directly right-above of the position of last token, i.e. j mod 7 is not 6 AND not index 35-41
	#compare the j + 8 token to the token of interest
	#if equal
		#positiveD++
		#j + 8
	#else
		#break
	#set j = i
	#while there is a token directly left-below of the position of the last token, i.e. j mod 7 is not 0 AND not index 0-6
	#compare j - 8 token to the token of interest
	#if equal
		#positiveD++
		#j - 8
	#else
		#break
	#if positiveD > 4
	#return true

	jr	$ra			#No winner found, return to game loop
	
WinnerFound:
	beq	$s0, $s6, PlayerWinner
	beq	$s0, $s7, ComputerWinner
	j	LogicalError

PlayerWinner:	
ComputerWinner:
DisplayWin:
	li	$v0, 4			#system call code for Print String
	la	$a0, WinMsg 		#load address of win message
	syscall				#print

	j	EndGame

EndGame:
	li	$v0, 4			#system call code for Print String
	la	$a0, Thankyou  		#load address of Player move prompt
	syscall				#print User input prompt
	
	li	$v0, 5			#system call code for Read Integer
	syscall				#Read user input
	
	add	$s1, $v0, $zero		#store input to $t0
	beq	$s1, 1, NewGame		#return to begining (NOT DONE)
	
	li      $v0, 10              	# terminate program run and
  	syscall                      	# Exit
	
LogicalError:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalComMovMsg 	#load address of error prompt
	syscall				#print error prompt	
