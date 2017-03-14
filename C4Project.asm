		.data
GameBoard:	.space	42		#reserves a block of 42 bytes
ClCount:	.word	0,0,0,0,0,0,0 	#Array of Tokens per Column
WinCondition:	.word	4		#Number of Tokens to Win
#======================== Player Markers ===========================================
#Use these to load marker ascii values and also the values to check for player or computer turn
Player:		.word   79		#Player marker and also ascii value for 'O'
Computer:	.word	88		#Computer marker and also ascii value for 'X'
#===================================================================================
WinCondBool:	.byte	0		#1 if true, 0 if false
PlayerMoveMsg:	.asciiz			"Please pick a column: \n"
SystemError:	.asciiz			"Program has encountered a system error. \n"
FullColMsg:	.asciiz			"That column is full.  Try again. \n"
InvalidMsg:	.asciiz			"Invalid selection.  Please try again. \n"
InvalComMovMsg:	.asciiz			"Computer has made an invalid move. \n"
ColumnHeader:	.asciiz			" 1 2 3 4 5 6 7 \n"
WinMsg:		.asciiz			"Congratulations!  You WIN!! \n"
LoseMsg:	.asciiz			"You LOSE, you goober!! \n"
Thankyou:	.asciiz			"Do you wish to play again \n Enter 0 to exit \n Enter 1 to try again"
DEBUG:		.asciiz			"DEBUG: Checking horizontal case..."	#for debug testing
DEBUG2:		.asciiz			"DEBUG2: win val: "
Newline:	.asciiz			"\n"
		.globl	main
		.text		
		
#============================== Notes ==============================================
#	$s0 = used globally to keep track of current turn
#	    = 79 for player turn
#	    = 88 for computer turn
#	$s1 = used globally to keep track of selected input column, regardless of
#	    	player or computer turn
#	$s2 = current move's physical address in Gameboard Array
#	$s3 = current move's column index
#	$s4 = current move's row index
#	$s6 = 79, register holder for player token in ascii value.  Compare to $s0 for current turn
#	$s7 = 88, register holder for computer token in ascii value.  Compare to $s0 for current turn
#
#================== How to Use Column and Row Indexing =============================
#
#	6   |_35|_36|_37|_38|_39|_40|_41|
#	5   |___|___|_._|_._|_._|_33|_34|
#   	4   |___|___|_+6|_+7|_+8|___|___|  To get the negative diagonal pieces, +/- 6 from point of reference
#  ROWS	3   |___|___|_-1|_x_|_+1|___|___|  To get the positive diagonal pieces, +/- 8 from point of reference
#   	2   |___|___|_-8|_-7|_-6|___|___|  To get the vertical pieces, +/- 7 from point of reference
#   	1   |_7_|_8_|_._|_._|_._|___|___|  To get the horizontal pieces, +/- 1 from the point of reference
#	0   |_0_|_1_|_2_|_3_|_4_|_5_|_6_|  where x + starting address of array = address of xth element
#	      0   1   2   3   4   5   6   (note: do not need to multiply by size of element since elements
#		   COLUMNS		   	are characters (size = 1 byte))
#====================================================================================


main:
	# Global Constants for Loading Token or Checking Current Turn
	lw	$s6, Player		#Holder for player token
	lw	$s7, Computer		#Holder for computer token
	
NewGame:
	jal 	InitializeGame		#Call to Initialize New Game
	jal 	PrintBoard		#print the initial blank board
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

InitializeGame:																		
	InitializeGameBoard:
	li	$t0, 0			#load zero into $t0 for counter
	li	$t1, 95			#load ascii code for '_' into $t1
	IGLoop1:	
	la	$t2, GameBoard		#stores the address of GameBoard into $t2
	add	$t2, $t2, $t0		#adds the offset to the stored address
	sb	$t1,($t2)		#store '_' character into GameBoard with offset $t0
	addi	$t0, $t0, 1		#incrament the counter by 1
	bne	$t0, 42, IGLoop1	#loop until all 42 slots are filled
	
	InitializeColCounters:
	
	li	$t0, 0			#load zero into $t0 for counter
	IGLoop2:
	la	$t2, ClCount		#load address of ClCount into $t2
	add	$t2, $t2, $t0		#adds the offset to the stored address
	sw	$0, ($t2)
	addi	$t0, $t0, 4		#increment by 4 for size of word
	bne	$t0, 28, IGLoop2
	
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
	la	$a0,InvalidMsg  	#load address of invalid move message
	syscall				#print invalid move message	
	j	PlayerMove		#return

InvalidCompMove:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalComMovMsg  #load address of invalid move message
	syscall				#print invalid move message	
	j	ComputerMove		#return
	
NewMove:	
	addi    $s3, $s1, -1 		#Store current move's column index in $s3
	mul	$t4, $s3, 4		#This is the index offset for word
	lw	$t0, ClCount($t4)	#Store height of the column in t0
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add 	$t1, $t1, $s3		#Adds column offset
	la	$s2, GameBoard		#load base address of GameBoard into $s2
	add	$s2, $s2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($s2)		#store player character into calculated address
	add	$s4, $t0, $0		#Store current move's row index in $s4
	addi	$t0, $t0, 1		#add 1 to column count
	sw	$t0, ClCount($t4)	#store updated count of column 1 into memory
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
#	$s2 = current move's physical address in Gameboard Array
#	$s3 = current move's column index
#	$s4 = current move's row index
#	$s6 = 79, register holder for player token in ascii value.  Compare to $s0 for current turn
#	$s7 = 88, register holder for computer token in ascii value.  Compare to $s0 for current turn
#===================================================================================
	lw	$t9, WinCondition

CheckVertical:
# You cannot have token above the placed token, so only check directly below.
# Also note: it is impossible to win vertically if there are less than 4 tokens high
	
	#Initial Check for Row Index >= 3
	slti	$t2, $s4, 3			#if number of tokens in column is less than 4 (index 3)
	bne	$t2, $0, CheckHorizontal	#branch to next check
	
	li	$t0, 1				#counter for counting tokens-in-a-row
	add	$t4, $s4, $0			#set traversing row index to the last token
	add	$t2, $s2, $0			#set traversing physical address to the last token
	VerticalLoop:	
	subi	$t4, $t4, 1			#set traversing row index to one below
	subi	$t2, $t2, 7			#set traversing physical address to one below
	lb	$t1, ($t2)			#load the token in the traversing checker
	bne	$t1, $s0, CheckHorizontal	#if it is not equal to the current player's token, branch to next check
	
	addi	$t0, $t0, 1			#else, tokens-in-a-row++
	beq	$t0, $t9, WinnerFound		#if tokens-in-a-row = win condition, found a winner
	beq	$t4, $0, CheckHorizontal	#if traversing row index is equal to 0 (base row), go to next check
	j	VerticalLoop
		
CheckHorizontal:
# You cannot win horizontally without a token in the center column for win-condition = 4-in-a-row

	lw	$t1, ClCount+12			#load the height in index 3, base address + index 3 * 4 bytes/word
	add	$t1, $t1, -1			#Subtract 1 from height to find height in terms of index
	slt	$t1, $t1, $s4
	beq	$t1, 1, CheckNegDiag		#if the value in the center column is '_' i.e blank, then go to next check

	#======= DEBUG ROUTINE FOR CHECKING VALUES =========	
	li	$v0, 4					   #
	la	$a0, DEBUG 				   #	
	syscall					   	   #
							   #
	#li	$v0, 1					   #		
	#add	$a0, $t0, $0	#select register to check  #
	#syscall				  	   #
							   #
	li	$v0, 4					   #		
	la	$a0, Newline				   #	
	syscall						   #
	#======= DEBUG ROUTINE FOR CHECKING VALUES =========

	li	$t0, 1				#counter for counting tokens-in-a-row
	add	$t3, $s3, $0			#set traversing column index to the last token
	add	$t2, $s2, $0			#set traversing physical address to the last token
	HorizontalLoopLeft:	
	beq	$t3, 0, HorizontalRight		#if the traversing column index is 0, go to next check
	
	add	$t3, $t3, -1			#set traversing column index to one left
	add	$t2, $t2, -1			#set traversing physical address to one left
	lb	$t1, ($t2)			#load the token in the traversing checker
	bne	$t1, $s0, HorizontalRight	#if it is not equal to the current player's token, branch to next check
	
	addi	$t0, $t0, 1			#else, tokens-in-a-row++
	beq	$t0, $t9, WinnerFound		#if tokens-in-a-row = win condition, found a winner
	j	HorizontalLoopLeft
	
	HorizontalRight:			#Keeping the current counter for tokens-in-a-row
	add	$t3, $s3, $0			#reset traversing column index to the last token
	add	$t2, $s2, $0			#reset traversing physical address to the last token
	
	HorizontalLoopRight:
	beq	$t3, 6, CheckNegDiag		#if the traversing column index is 6, go to next check
	
	add	$t3, $t3, 1			#set traversing column index to one right
	add	$t2, $t2, 1			#set traversing physical address to one right
	lb	$t1, ($t2)			#load the token in the traversing checker
	bne	$t1, $s0, CheckNegDiag		#if it is not equal to the current player's token, branch to next check
	
	addi	$t0, $t0, 1			#else, tokens-in-a-row++
	beq	$t0, $t9, WinnerFound		#if tokens-in-a-row = win condition, found a winner
	j	HorizontalLoopRight
	
#	Reference Variables:

#	$t0 = counter
#	$s2 = current move's physical address in array
#	$s3 = current move's column index
#	$s4 = current move's row index

#	$t2 = traversing physical address in array
#	$t3 = traversing column index
#	$t4 = traversing row index
CheckNegDiag:


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
CheckPosDiag:
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
	li	$v0, 4			#system call code for Print String
	la	$a0, WinMsg 		#load address of win message
	syscall				#print
	j	EndGame
	
ComputerWinner:
	li	$v0, 4			#system call code for Print String
	la	$a0, LoseMsg 		#load address of win message
	syscall				#print
	j	EndGame

EndGame:
	li	$v0, 4			#system call code for Print String
	la	$a0, Thankyou  		#load address 
	syscall				#print 
	EndGameLoop:	
	li	$v0, 5			#system call code for Read Integer
	syscall				#Read user input
	
	add	$t1, $v0, $zero		#store input to $t0
	beq	$t1, 0, EndProgram	#Exit the program
	beq	$t1, 1, NewGame		#return to begining (NOT DONE)
	
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalidMsg  	#load address of invalid message
	syscall				#print invalid message
	j	EndGameLoop

EndProgram:	
	li      $v0, 10              	# terminate program run and
  	syscall                      	# Exit
	
LogicalError:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalComMovMsg 	#load address of error prompt
	syscall				#print error prompt	
