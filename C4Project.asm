		.data
GameBoard:	.space	42		#reserves a block of 42 bytes
ClCount1:	.word	0		#initializes the column 1 count to zero
ClCount2:	.word	0		#initializes the column 2 count to zero
ClCount3:	.word	0		#initializes the column 3 count to zero
ClCount4:	.word	0		#initializes the column 4 count to zero
ClCount5:	.word	0		#initializes the column 5 count to zero
ClCount6:	.word	0		#initializes the column 6 count to zero
ClCount7:	.word	0		#initializes the column 7 count to zero
WinCondBool:	.byte	0		#1 if true, 0 if false
PlayerMovePrompt:	.asciiz		"Please pick a column: \n"
InvalidMoveMsg:	.asciiz			"Invalid move; please try again. \n"
ColumnHeader:	.asciiz			" 1 2 3 4 5 6 7 \n"
WinMessage:	.asciiz			"Game Over! \n"
		.globl	main
		.text		
main:
	jal InitializeGameBoard		#Call initializeGameBoard Method
	jal PrintBoard			#print the initial blank board
	GameLoop1:
	li	$s1, 1
	jal TakeUserInput		#Call TakeUserInput Method
	jal PrintBoard
	jal CheckWinCondition
	lb	$t0, WinCondBool
	beq	$t0,1, DisplayWin
	GameLoop2:
	li	$s1, 2
	jal ComputerMove
	jal PrintBoard
	jal CheckWinCondition
	lb	$t0, WinCondBool
	beq	$t0,1, DisplayWin	
	j	GameLoop1
		
InitializeGameBoard:
	li	$t0, 0			#load zero into $t0 for counter
	IGBLoop1:	
	li	$t1, 95			#load ascii code for '_' into $t1
	la	$t2, GameBoard		#stores the address of GameBoard into $t2
	add	$t2, $t2, $t0		#adds the offset to the stored address
	sb	$t1,($t2)		#store '_' character into GameBoard with offset $t0
	addi	$t0, $t0, 1		#incrament the counter by 1
	bne	$t0, 42, IGBLoop1	#loop until all 42 slots are filled
	jr	$ra		

TakeUserInput:
	li	$s0, 79			#loads the ascii value for 'O' into $s0
	li	$v0, 4			#system call code for Print String
	la	$a0,PlayerMovePrompt  	#load address of Player move prompt
	syscall				#print User input prompt
	
	li	$v0, 5			#system call code for Read Integer
	syscall				#Read user input
	
	#switch for user input
	beq	$v0, 1, MoveC1
	beq	$v0, 2, MoveC2
	beq	$v0, 3, MoveC3
	beq	$v0, 4, MoveC4
	beq	$v0, 5, MoveC5
	beq	$v0, 6, MoveC6
	beq	$v0, 7, MoveC7
	
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalidMoveMsg  	#load address of invalid move message
	syscall				#print invalid move message
	jr	$ra			#return
		
	MoveC1:
	lw	$t0,ClCount1		#load number of pieces in column 1 into $t0
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount1		#store updated count of column 1 into memory
	jr	$ra			#return
	MoveC2:
	lw	$t0,ClCount2		#load number of pieces in column 2 into $t0
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add	$t1,$t1,1		#add column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount2		#store updated count of column 1 into memory
	jr	$ra			#return
	MoveC3:
	lw	$t0,ClCount3		#load number of pieces in column 2 into $t0
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add	$t1,$t1,2		#add column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount3		#store updated count of column 1 into memory
	jr	$ra			#return
	MoveC4:
	lw	$t0,ClCount4		#load number of pieces in column 2 into $t0
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add	$t1,$t1,3		#add column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount4		#store updated count of column 1 into memory
	jr	$ra			#return
	MoveC5:
	lw	$t0,ClCount5		#load number of pieces in column 2 into $t0
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add	$t1,$t1,4		#add column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount5		#store updated count of column 1 into memory
	jr	$ra			#return
	MoveC6:
	lw	$t0,ClCount6		#load number of pieces in column 2 into $t0
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add	$t1,$t1,5		#add column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount6		#store updated count of column 1 into memory
	jr	$ra			#return
	MoveC7:
	lw	$t0,ClCount7		#load number of pieces in column 2 into $t0
	beq	$t0, 6, FullColumn
	mul	$t1,$t0,7 		#multiply the number of pieces in column by 7
	add	$t1,$t1,6		#add column offset
	la	$t2, GameBoard		#load base address of GameBoard into $t2
	add	$t2, $t2, $t1		#add the adress of GameBoard with calculated offset
	sb	$s0, ($t2)		#store player character into calculated address
	add	$t3, $t0,1		#add 1 to column count and store in $t3
	sw	$t3, ClCount7		#store updated count of column 1 into memory
	jr	$ra			#return
	
	FullColumn:
	beq	$s1,1,FC1		#if the current turn is player then branch
	j	ComputerMove
	FC1:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalidMoveMsg  	#load address of invalid move message
	syscall				#print invalid move message
	j	GameLoop1
		

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
	lb	$a0,GameBoard+6	#load ascii code stored in offset index of GameBoard
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
	
ComputerMove:
	li	$v0, 42			#system call code for Random integer in range
	li	$a0,100			#load i.d. of pseudorandom number generator
	li	$a1,7  			#load immediate of upper bound of random number
	syscall				#get random number
		
	
	li	$t0, 88			#load ascii value for x
	add	$s0, $t0, $zero		#put Computer ascii 'X' into $s0
	
	beq	$a0, 0, MoveC1
	beq	$a0, 1, MoveC2
	beq	$a0, 2, MoveC3
	beq	$a0, 3, MoveC4
	beq	$a0, 4, MoveC5
	beq	$a0, 5, MoveC6
	beq	$a0, 6, MoveC7
	j	ComputerMove

CheckWinCondition:
	jr	$ra

DisplayWin:

EndGame:
