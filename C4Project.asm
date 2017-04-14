		.data
#=========================================================================================================================
#	Bitmap Display Mapping
#=========================================================================================================================
# 	Setting up Bitmap Display
#
#	Please make sure to follow these directions or MARS will crash!!
#
#	1. Go to Tools > Bitmap Display
#
#	2. Select following options for Bitmap Display:
#		a. Unit Width in Pixels: 8
#		b. Unit Height in Pixels: 8
#		c. Display Width in Pixels: 512
#		d. Display Height in Pixels: 512
# IMPORTANT!!   e. Base address for display: 0x10010000 (static data)
#
# 	3. Click "Connect to MIPS"
#
#	NOTE: If you try to skip step 3 and connect after MIPS is already running the
#	      program, the program will freeze and a force shutdown will be needed!!
#
# 			Colors for Bitmap Display:
#			Red:		0x00FF0000
#			Blue:		0x003333FF
#			White:		0x00FFFFFF
#			Yellow:		0x00FFFF00
#			Green:		0x0000FF00
#			Black:		0x00000000
#=========================================================================================================================
#Reserves a block of 4096 bytes for 64 x 64 pixel board	(addresses: 268,500,992 - 268,517,376)
Bitmap:		.space	16384
#Pixel Indices in 64x64 pixel Bitmap Display (Pixel Index 0-4093)
#Pixel indices below are the column numbers on Bitmap Display (array length: 83 words)
BitmapNumbers:	.word	3524,3525,3533,3534,3542,3543,3550,3553,3559,3560,3561,3562,3569,3570,3577,3578,3579,3580,3589,3596
BitmapNumbers1:	.word	3599,3605,3608,3614,3617,3623,3632,3635,3644,3653,3663,3672,3678,3681,3687,3696,3708,3717,3726,3735
BitmapNumbers2:	.word	3742,3743,3744,3745,3752,3753,3760,3761,3762,3771,3781,3789,3800,3809,3818,3824,3827,3835,3845,3852
BitmapNumbers3:	.word	3861,3864,3873,3882,3888,3891,3899,3908,3909,3910,3916,3917,3918,3919,3926,3927,3937,3943,3944,3945
BitmapNumbers4:	.word	3953,3954,3963

#Pixel indices for printing, "You Win!" (array length: 62 words)
BitmapYouWin: 	.word 	1617,1619,1622,1623,1626,1629,1632,1636,1638,1640,1644,1646,1681,1683,1685,1688,1690,1693,1696,1698
BitmapYouWin1: 	.word 	1700,1702,1704,1705,1708,1710,1746,1749,1752,1754,1757,1760,1762,1764,1766,1768,1770,1772,1774,1810
BitmapYouWin2: 	.word 	1813,1816,1818,1821,1824,1826,1828,1830,1832,1835,1836,1874,1878,1879,1883,1884,1889,1891,1894,1896
BitmapYouWin3: 	.word 	1900,1902

#Pixel indices for printing, "You Lose!" (array length: 66 words)
BitmapYouLose: 	.word 	1616,1680,1745,1809,1873,1618,1682,1625,1689,1753,1817,1628,1692,1756,1820,1631,1695,1759,1823,1887
BitmapYouLose1: .word 	1882,1888,1883,1889,1684,1748,1812,1687,1751,1815,1621,1877,1622,1878,1635,1636,1639,1640,1641,1643
BitmapYouLose2: .word 	1644,1645,1647,1698,1701,1703,1707,1711,1762,1765,1768,1771,1772,1775,1826,1829,1833,1835,1891,1892
BitmapYouLose3: .word 	1895,1896,1899,1900,1901,1903	

#Pixel indices for printing, "Player" (array length: 57 words)
BitmapPlayer:	.word	1607,1608,1609,1611,1616,1617,1620,1622,1624,1625,1626,1628,1629,1630,1671,1673,1675,1679,1682,1684
BitmapPlayer1:	.word	1686,1688,1692,1694,1735,1736,1737,1739,1743,1744,1745,1746,1749,1752,1753,1756,1757,1799,1803,1807
BitmapPlayer2:	.word	1810,1813,1816,1820,1822,1863,1867,1868,1869,1871,1874,1877,1880,1881,1882,1884,1886
#Pixel indices for printing, "1" (array length: 8 words)
BitmapNo1:	.word	1633,1634,1698,1762,1826,1890,1889,1891

#Pixel indices for printing, "2" (array length: 10 words)
BitmapNo2:	.word	1633,1634,1762,1825,1889,1635,1699,1763,1890,1891

#Pixel indices for printing, "Wins!" (array length: 43 words)
BitmapWins:	.word	1638,1642,1644,1646,1650,1652,1653,1654,1656,1702,1704,1706,1708,1710,1711,1714,1716,1720,1766,1768
BitmapWins1:	.word	1770,1772,1774,1776,1778,1781,1784,1830,1832,1834,1836,1838,1841,1842,1846,1895,1897,1900,1902,1906
BitmapWins2:	.word	1908,1909,1912
#=========================================================================================================================
#	Music and Sound 
#=========================================================================================================================
#	How to Implement
#	
#	1.	Use the following format for allocating space for all musical details:
#		Music_<Name>_NoteCt:	.word	#number of notes
#		Music_<Name>_Note:	.word	#each note value separated by commas
#		Music_<Name>_Dur:	.word	#each note duration separated by commas
#		Music_<Name>_Instr:	.word	#each note instrument separated by commas
#		Music_<Name>_Vol:	.word	#each note volume separated by commas
#
#	2.	Instructions needed to implement the sound should be added where it is desired to be played.
#		The sub-routine that implements this is PlaySound.  Make sure to Jump-and-Link to PlaySound and
#		save the current return address in the stack, if needed.
#
#	3.	The following temporary registeries need to be initialized before the jal call is made:
#		$t4 -- loaded with number of notes to be played
#		$t0 -- loaded with base address of duration of note
#		$t1 -- loaded with base address of array of duration of note
#		$t2 -- loaded with base address of array of instrument of note
#		$t3 -- loaded with base address of array of volume of note
#
#	Sample:
#		la	$t4, Music_Victory_NoteCt
#		lw	$t4, ($t4)		
#		la	$t0, Music_Victory_Note
#		la	$t1, Music_Victory_Dur
#		la	$t2, Music_Victory_Instr
#		la	$t3, Music_Victory_Vol
#		jal	PlaySound
#=========================================================================================================================
#Victory Sound
Music_Victory_NoteCt:	.word	4
Music_Victory_Note:	.word	69, 70, 71, 72
Music_Victory_Dur:	.word	250, 250, 250, 750
Music_Victory_Instr:	.word	5, 5, 5, 5
Music_Victory_Vol:	.word	90, 95, 100, 110

#Defeat Sound
Music_Defeat_NoteCt:	.word	16
Music_Defeat_Note:	.word	79, 67, 72, 76, 75, 68, 84, 71, 81, 72, 76, 81, 79, 72, 74, 76
Music_Defeat_Dur:	.word	300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300
Music_Defeat_Instr:	.word	5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
Music_Defeat_Vol:	.word	90,90,90,90,90,90,90,90,90,90,90,90,90,90,90,90
#Player Placement
Music_player_NoteCt:	.word	2
Music_player_Note:	.word	83, 84
Music_player_Dur:	.word	75, 600
Music_player_Instr:	.word	1, 1
Music_player_Vol:	.word	100
#sound effect
Music_placement_NoteCt:	.word	1
Music_placement_Note:	.word	84
Music_placement_Dur:	.word	600
Music_placement_Instr:	.word	1
Music_placement_Vol:	.word	100
#=========================================================================================================================
#	GameBoard Memory
#=========================================================================================================================
#	How to Use Column and Row Indexing 
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
#
#=========================================================================================================================
GameBoard:	.space	42		#reserves a block of 42 bytes
ClCount:	.word	0,0,0,0,0,0,0 	#Array of Tokens per Column
WinCondition:	.word	4		#Number of Tokens to Win

#	Player Markers 
#	Use these to load marker ascii values and also the values to check for player or computer turn

Player:		.word   79		#Player marker and also ascii value for 'O'
Computer:	.word	88		#Computer marker and also ascii value for 'X'
#=========================================================================================================================
#	Memory for Printed Strings 
#=========================================================================================================================

#Welcome Banner for the Run I/O
WelcomeBanner:	.ascii			"\n\n=================================================================================================\n"
WelcomeBanner1:	.ascii			"\n  /$$$$$$                                                      /$$           /$$   /$$"
WelcomeBanner2:	.ascii			"\n /$$__  $$                                                    | $$          | $$  | $$"
WelcomeBanner3:	.ascii			"\n| $$  \\__/  /$$$$$$  /$$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$        | $$  | $$"
WelcomeBanner4:	.ascii			"\n| $$       /$$__  $$| $$__  $$| $$__  $$ /$$__  $$ /$$_____/|_  $$_/        | $$$$$$$$"
WelcomeBanner5:	.ascii			"\n| $$      | $$  \\ $$| $$  \\ $$| $$  \\ $$| $$$$$$$$| $$        | $$          |_____  $$"
WelcomeBanner6:	.ascii			"\n| $$    $$| $$  | $$| $$  | $$| $$  | $$| $$_____/| $$        | $$ /$$            | $$"
WelcomeBanner7:	.ascii			"\n|  $$$$$$/|  $$$$$$/| $$  | $$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/            | $$"
WelcomeBanner8:	.ascii			"\n \\______/  \\______/ |__/  |__/|__/  |__/ \\_______/ \\_______/   \\___/              |__/"
WelcomeBanner9:	.ascii			"\n\n=================================================================================================\n\n"
WelcomeBanner10:.asciiz			"Welcome to Connect 4!\n\n\n"

SelectMode:	.asciiz			"Please select a game mode:\n\n1 - 1 Player\n2 - 2 Players\n\n"
InvalidModeMsg:	.asciiz			"Invalid game mode selected.  Please try again: "
SelectDifficult:.asciiz			"\nPlease select a difficulty\n\n1 - Easy Mode\n2 - Normal Mode\n3 - Hard Mode\n\n"
InvalDiffMsg:	.asciiz			"Invalid game difficulty selected.  Please try again: "
PlayerMoveMsg:	.asciiz			"Please pick a column: \n"
SystemError:	.asciiz			"Program has encountered a system error. \n"
FullColMsg:	.asciiz			"That column is full.  Try again. \n"
InvalidMsg:	.asciiz			"Invalid selection.  Please try again333. \n"
InvalComMovMsg:	.asciiz			"Computer has made an invalid move. \n"
ColumnHeader:	.asciiz			" 1 2 3 4 5 6 7 \n"
WinMsg:		.asciiz			"\n\n====================\n\nCongratulations!  You WIN!! \n\n====================\n\n"
LoseMsg:	.asciiz			"\n\n====================\n\nYou LOSE, you goober!! \n\n====================\n\n"
P1WinMsg:	.asciiz			"\n\n====================\n\nCongratulations!  Player 1 WINS!! \n\n====================\n\n"
P2WinMsg:	.asciiz			"\n\n====================\n\nCongratulations!  Player 2 WINS!! \n\n====================\n\n"
Thankyou:	.asciiz			"Do you wish to play again? \n Enter 0 to exit \n Enter 1 to play again\n\n"
DEBUG:		.asciiz			"DEBUG: "	#for debug testing
DEBUG2:		.asciiz			"DEBUG2: "
DEBUG3:		.asciiz			"DEBUG3: "
DEBUG4:		.asciiz			"Switching players: "
Newline:	.asciiz			"\n"
		.globl	main
		
#=========================================================================================================================
#	Exception Handling 
#=========================================================================================================================		
		.ktext 0x80000180
   	move $k0,$v0   # Save $v0 value
   	move $k1,$a0   # Save $a0 value
   	
   	la   $a0, ExceptionMsg  # address of string to print
   	li   $v0, 4    # Print String service
   	syscall
   	
   	move $v0,$k0   # Restore $v0
   	move $a0,$k1   # Restore $a0
  	mfc0 $k0,$14   # Coprocessor 0 register $14 has address of trapping instruction
   	addi $k0,$k0,4 # Add 4 to point to next instruction
   	mtc0 $k0,$14   # Store new address back into $14
   	eret           # Error return; set PC to value in $14
   	
   		.kdata	
ExceptionMsg:	.asciiz			"You cannot enter characters. \n\n"				
		
									
#=========================================================================================================================
#	Program Main
#=========================================================================================================================
#	Important Notes:
#
#	$s0 = used globally to keep track of current turn
#	    = 79 for player turn (used in many comparisons for branching, jumping, displaying ascii board)
#	    = 88 for computer turn (used in many comparisons for branching, jumping, displaying ascii board)
#	$s1 = used globally to keep track of selected input column, regardless of
#	    	player or computer turn
#	$s2 = current move's physical address in Gameboard Array
#	$s3 = current move's column index
#	$s4 = current move's row index
#	$s5 = game mode, 1 - 1 player, 2 - 2 player --- For 1P modes: 3 - Easy Mode, 4 - Normal Mode, 5 - Hard Mode
#	$s6 = color of current turn (0x00FFFF00, yellow for P1, 0x00FF0000, red for P2)
#========================================================================================================================= 
#	Program Welcome, Game Initialization and Main Game Loop
#========================================================================================================================= 	
		.text	
main:   
	
	li	$v0, 4			#system call code for Print String
	la	$a0, WelcomeBanner  	#load address of Welcome Banner
	syscall				#print User input prompt
	
NewGame:
	jal 	InitializeGame		#Call to Initialize New Game
	jal	InitializeBitmap	#Initialize the Bitmap for the Gameboard Display
	jal	SelectGameMode		#select game mode
	jal 	PrintBoard		#print the initial blank board
	jal	SetFirstMove		#Set first move depending on difficulty mode, if 1-player mode

GameLoop:
	jal	CurrentMove
	jal	PrintBoard
	jal	UpdateBitmap
	jal 	CheckWinCondition
	jal	SwitchPlayers
	j	GameLoop

#========================================================================================================================= 	

SelectGameMode:
	li	$v0, 4			#system call code for Print String
	la	$a0, SelectMode  	#load address of Select Game Mode
	syscall				#print user input prompt	
	RetryGameMode:		
	li 	$v0, 5
	syscall
	
	add	$s5, $v0, $0
	
	beq 	$s5, 1, ValidMode
	beq	$s5, 2, ValidMode
	
InvalidMode:
	li	$v0, 4			#system call code for Print String
	la	$a0, InvalidModeMsg  	#load address of Invalid Mode
	syscall				#print user input prompt
	
	j 	RetryGameMode
ValidMode:
	addi $a0, $zero, 84
	addi $a1, $zero, 600
	addi $a2, $zero, 1
	addi $a3, $zero, 90
	li $v0, 33
	syscall 
	beq	$s5, 1, SelectDifficulty
	jr	$ra	
	
SelectDifficulty:
	li	$v0, 4			#system call code for Print String
	la	$a0, SelectDifficult  	#load address of Select Game Mode
	syscall				#print user input prompt		
	RetryDifficulty:
	li 	$v0, 5
	syscall		
	
	add	$s5, $v0, $0
	beq	$s5, 1, ValidDifficulty
	beq	$s5, 2, ValidDifficulty
	beq	$s5, 3, ValidDifficulty

InvalidDifficulty:	
	li	$v0, 4			#system call code for Print String
	la	$a0, InvalDiffMsg  	#load address of Invalid Mode
	syscall				#print user input prompt
Wrongsound:
	addi $a0, $zero, 50
	addi $a1, $zero, 200
	addi $a2, $zero, 16
	addi $a3, $zero, 100
	li $v0, 33
	syscall 
	addi $a0, $zero, 50
	addi $a1, $zero, 200
	addi $a2, $zero, 16
	addi $a3, $zero, 100
	li $v0, 33
	syscall	
	j 	RetryDifficulty

ValidDifficulty:
	addi $a0, $zero, 84
	addi $a1, $zero, 600
	addi $a2, $zero, 1
	addi $a3, $zero, 90
	li $v0, 33
	syscall 
	add	$s5, $s5, 2		#offset selection by 2 to correct game mode selection, e.g. Selected Easy Mode = 1 + 2 = Game Mode 3	
	jr	$ra
			
SwitchPlayers:
	beq	$s0, 79, SwitchToCPU
	beq	$s0, 88, SwitchToPlayer
	j	LogicalError
		
	SwitchToCPU:
	li	$s0, 88
	li	$s6, 0x00FF0000		
	jr	$ra	
	SwitchToPlayer:
	li	$s0, 79
	li	$s6, 0x00FFFF00
	
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

InitializeBitmap:
# Colors for Bitmap Display:
#	Red:		0x00FF0000
#	Blue:		0x003333FF
#	White:		0x00FFFFFF
#	Yellow:		0x00FFFF00
#	Green:		0x0000FF00
#	Black:		0x00000000

ClearBoard:
	li 	$t0, 0			# $t0, x = 0 (initialize x-coor, the pixel rows)
    	li 	$t1, 0			# $t1, y = 0 (initialize y-coor, the pixel columns)    	  	
    	li	$t5, 0x00000000		# $t5 holds the 24-bit RGB, here it's black

	ClearBitmapLoop:    	
    	sll	$t2, $t0, 8		# Get the current row index ( x * 256 bytes)
    	sll	$t3, $t1, 2		# Get the current col index ( y * 4 bytes)
  	add	$t7, $t2, $t3		# Get the current pixel location ( x + y )
    	sw	$t5, 0x10010000($t7)	# Add the pixel location offset to base address of bitmap display space and store color there
    	beq	$t1, 63, bitmapnextrow	# If printed last pixel in row, go to cycle next row
    	add	$t1, $t1, 1		# Otherwise, go to next pixel
    	j	ClearBitmapLoop		# Print it again
    	
	bitmapnextrow:			# If last pixel in row,
	beq	$t0, 63, PrintBitmapDividers	# If currently in last row, go to next routine
	li	$t1, 0			# Else, reset column index to zero
	add	$t0, $t0, 1		# And add 1 to the row index
	j	ClearBitmapLoop		# Go back to print next row

  PrintBitmapDividers:	
     PrintBitmapLatBars:
	li	$t0, 0			# $t0, x = 0 (initialize x-coor, the pixel rows)
	li	$t1, 0			# $t1, y = 0 (initialize y-coor, the pixel columns) 
	li	$t5, 0x003333FF		# $t5 holds the 24-bit RGB, here it's blue
	li	$t6, 256		# $t6 holds max bytes for a 64-pixel dimension (64 words = 256 bytes)

	LatBarsBitmapLoop:    	
    	sll	$t2, $t0, 8		# Get the current row index ( x * 256 bytes)
    	sll	$t3, $t1, 2		# Get the current col index ( y * 4 bytes)
  	add	$t7, $t2, $t3		# Get the current pixel location ( x + y )
    	sw	$t5, 0x10010000($t7)	# Add the pixel location offset to base address of bitmap display space and store color there
    	beq	$t1, 63, NextLatBar	# If printed last pixel in row, go to cycle next row
    	add	$t1, $t1, 1		# Otherwise, go to next pixel
    	j	LatBarsBitmapLoop	# Print it again
    	
	NextLatBar:			# If last pixel in row,
	beq	$t0, 63, PrintBitmapLongBars	# If currently in last row, go to next routine
	li	$t1, 0			# Else, reset column index to zero
	bge	$t0, 54, LastLatBars	# If in rows 54-63, print every row incrementing in LastLatBars
	add	$t0, $t0, 9		# Else, save 8 pixels for game token and print next bar, x = x + 9
	j	LatBarsBitmapLoop	# Go back to print row
	
	LastLatBars:			# If in the last 54-63 rows,
	add	$t0, $t0, 1		# x = x + 1, print every row
	j	LatBarsBitmapLoop	# Go back to print it
	
     PrintBitmapLongBars:
   	li	$t0, 0			# $t0, x = 0 (initialize x-coor, the pixel rows)
   	li	$t1, 0			# $t1, y = 0 (initialize y-coor, the pixel columns) 
	li	$t5, 0x003333FF		# $t5 holds the 24-bit RGB, here it's blue
	li	$t6, 256		# $t6 holds max bytes for a 64-pixel dimension (64 words = 256 bytes)
	   	
   	LongBarsBitmapLoop:
   	sll	$t2, $t0, 8		# Get the current row index ( x * 256 bytes)
    	sll	$t3, $t1, 2		# Get the current col index ( y * 4 bytes)
  	add	$t7, $t2, $t3		# Get the current pixel location ( x + y )
    	sw	$t5, 0x10010000($t7)	# Add the pixel location offset to base address of bitmap display space and store color there
    	beq	$t0, 54, NextLongBar	# If current pixel is at row 54, go to next long bar
    	add	$t0, $t0, 1		# Else, print next pixel down, x = x + 1
    	j	LongBarsBitmapLoop	# Go back to print it
    	
	NextLongBar:			# If current long bar is done printing,
	beq	$t1, 63, PrintBMNumbers	# If last long bar in the row, return to main routine
	li	$t0, 0			# Else, reset x index to zero
	add	$t1, $t1, 9		# Save 8 pixels for the game token and print next bar, y = y + 9
	j	LongBarsBitmapLoop	# Go back to print it
	
PrintBMNumbers:
	add	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la	$a0, BitmapNumbers
	li	$a1, 83
	li	$a2, 0x00FFFFFF
	jal	BitmapPrint
	
	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra

JumpReturn:
	jr	$ra			# Jump Return for branch statements

SetFirstMove:
PlayerMovesFirst:
	beq	$s5, 5, ComMovesFirst	#If Game Mode 5 (1P and Hard Mode), Computer moves first.  Else, P1 moves first
	
	lw	$s0, Player		#Set first turn to player 1 by loading the ascii value for player token 'O' into $s0
	li	$s6, 0x00FFFF00
	jr	$ra
ComMovesFirst:
	lw	$s0, Computer
	li	$s6, 0x00FF0000
	jr	$ra
	

CurrentMove:
	beq	$s0, 79, PlayerMove
	beq	$s5, 2, PlayerMove	#if the game is 2-player mode ($s5 = 2), then let player 2 move
	beq	$s0, 88, ComputerMove
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
	
	li	$v0, 32
	li	$a0, 600
	syscall
	
	beq	$s5, 3, EasyMode
	beq	$s5, 4, NormalMode
	beq	$s5, 5, HardMode
	j	LogicalError
	
HardMode:	#In-Progress....

	li	$s1, 0
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	jal	FirstMoveCheck
		bne	$s1, $0, BestMove
	jal	Bottom3Check
		bne	$s1, $0, BestMove
	jal	BottomWinCheck
		bne	$s1, $0, BestMove
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	j	RandomMove

NormalMode:	#unimplemented for now
		#whatever the logic is, must end with a jump to CheckValidMove
EasyMode:

RandomMove:
	lw	$t0, Computer		#load ascii value for x
	add	$s0, $t0, $zero		#put Computer ascii 'X' into $s0
	
	li	$v0, 42			#system call code for Random integer in range
	li	$a0, 100			#load i.d. of pseudorandom number generator
	li	$a1, 7  			#load immediate of upper bound of random number
	syscall				#get random number
	addi	$s1, $a0, 1		#store random number into $s1	
	j	CheckValidMove

BestMove:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	j	CheckValidMove
	
			
FirstMoveCheck:
	la	$t0, ClCount
	lw	$t0, 12($t0)
				
	beq	$t0, $0, Select4
	jr	$ra

Bottom3Check:
	la	$t0, ClCount
	lw	$t1, 8($t0)
	
	beq	$t1, $0, Select3
	
	lw	$t1, 16($t0)	
	
	beq	$t1, $0, Select5
	
	jr	$ra

BottomWinCheck:	
	la	$t0, GameBoard			#Load address of the GameBoard into $t0
	addi	$t0, $t0, 2			#Let $t0 hold the address of the token: one token to the left of the bottom center token
	li	$t1, 3				#Let $t1 hold the current column
	
BWCheckLoopLeft:	
	beq	$t1, $0, BWCheckRight
	
	lb	$t2, ($t0)
	beq	$t2, 79, BWCheckRight
	beq	$t2, 95, BWCheckNextMove
	
	add	$t0, $t0, -1
	add	$t1, $t1, -1
	j	BWCheckLoopLeft
	
BWCheckRight:
	
	la	$t0, GameBoard
	addi	$t0, $t0, 4
	li	$t1, 5
	
BWCheckLoopRight:			
	beq	$t1, 8, BWCheckNoMove
	
	lb	$t2, ($t0)
	beq	$t2, 79, BWCheckNoMove
	beq	$t2, 95, BWCheckNextMove
	
	add	$t0, $t0, 1
	add	$t1, $t1, 1
	j	BWCheckLoopRight

BWCheckNoMove:
	jr	$ra
	
BWCheckNextMove:
	add	$s1, $t1, $0
	jr	$ra
				
Select4:
	li	$s1, 4
	jr	$ra
Select3:
	li	$s1, 3
	jr	$ra
Select5:
	li	$s1, 5
	jr	$ra
		
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
	beq	$s5, 2, InvalidPlayerMove
	beq	$s0, 88, InvalidCompMove	
	j	LogicalError		#print system error if $s0 is not player or computer
	
InvalidPlayerMove:	
	teqi	$zero, 0
	
	#li	$v0, 4			#system call code for Print String
	#la	$a0,InvalidMsg  	#load address of invalid move message
	#syscall				#print invalid move message
Wrongmovessound:
	addi $a0, $zero, 50
	addi $a1, $zero, 200
	addi $a2, $zero, 16
	addi $a3, $zero, 100
	li $v0, 33
	syscall 
	addi $a0, $zero, 50
	addi $a1, $zero, 200
	addi $a2, $zero, 16
	addi $a3, $zero, 100
	li $v0, 33
	syscall	
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
	beq	$s0, 79, playermovesound
notplayersoundmove:	
	la	$t4, Music_placement_NoteCt
	lw	$t4, ($t4)		# $t4 loaded with number of notes
	la	$t0, Music_placement_Note	# $t0 must be loaded with base address of array of notes
	la	$t1, Music_placement_Dur	# $t1 must be loaded with base address of array of duration of note
	la	$t2, Music_placement_Instr# $t2 must be loaded with base address of array of instrument of note
	la	$t3, Music_placement_Vol	# $t3 must be loaded with base address of array of volume of note
	jal	PlaySound		#play sound
	jr	$ra			#return
playermovesound:
la	$t4, Music_placement_NoteCt
	lw	$t4, ($t4)		# $t4 loaded with number of notes
	la	$t0, Music_player_Note	# $t0 must be loaded with base address of array of notes
	la	$t1, Music_player_Dur	# $t1 must be loaded with base address of array of duration of note
	la	$t2, Music_player_Instr# $t2 must be loaded with base address of array of instrument of note
	la	$t3, Music_player_Vol	# $t3 must be loaded with base address of array of volume of note
	jal	PlaySound		#play sound
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
	

UpdateBitmap:				# Update Current Game Board with Last Token Placment
	# Find Last Token Placement to Find Location on Bitmap
	mul	$t0, $s3, 9		# Current column index * 9 pixels
	add	$t0, $t0, 1		# Add 1 pixel for the first border pixel
	
	beq	$s4, 0, BitmapIndex5	# If token is in row index 0, it is index 5 from the top
	beq	$s4, 1, BitmapIndex4	# If token is in row index 1, it is index 4 from the top
	beq	$s4, 2, BitmapIndex3	# If token is in row index 2, it is index 3 from the top
	beq	$s4, 3, BitmapIndex2	# If token is in row index 3, it is index 2 from the top
	beq	$s4, 4, BitmapIndex1	# If token is in row index 4, it is index 1 from the top
	beq	$s4, 5, BitmapIndex0	# If token is in row index 5, it is index 0 from the top
	j	LogicalError
    BitmapIndex5:
  	li	$t1, 5			# $t1 holds row index from the top
  	j	ContUpdateBitmap
    BitmapIndex4:
  	li	$t1, 4			# $t1 holds row index from the top
  	j	ContUpdateBitmap
    BitmapIndex3:
  	li	$t1, 3			# $t1 holds row index from the top
  	j	ContUpdateBitmap
    BitmapIndex2:
  	li	$t1, 2			# $t1 holds row index from the top
  	j	ContUpdateBitmap
    BitmapIndex1:
  	li	$t1, 1			# $t1 holds row index from the top
  	j	ContUpdateBitmap
    BitmapIndex0:
  	li	$t1, 0			# $t1 holds row index from the top
  	j	ContUpdateBitmap

  ContUpdateBitmap:			# After getting the row index from the top,
	mul	$t1, $t1, 9		# Multiply by 9 pixels
	add	$t1, $t1, 1		# Add 1 pixel for border pixel
	sll	$t1, $t1, 6		# Multiply by 64 pixels per row to get to first pixel in correct row
	add	$t0, $t0, $t1		# Add column pixel offset
	sll	$t0, $t0, 2		# Multiply by 4 to get full offset in bytes (4 bytes per pixel)
	
	add	$t0, $t0, 0x10010000	# Add total offset to the base address

  TokenTop4Pix:	
	li	$t1, 2			# Starting pixel is the 3rd pixel
     TokenTop4PixLoop:
	beq	$t1, 6, TokenBot4Pix	# While the pixel is pixel index 2-5, else branch to next part
	sll	$t2, $t1, 2		# Multiply index by 4 bytes
	add	$t2, $t0, $t2		# Add offset to base address
	sw	$s6, ($t2)		# Load current player's color into the address
	add	$t1, $t1, 1		# Increment the pixel index
	j	TokenTop4PixLoop	# Go back and print again
     
  TokenBot4Pix:  			
  	li	$t1, 2			# Starting pixel is the 3rd pixel
     TokenBot4PixLoop:
     	beq	$t1, 6, TokenTop6Pix	# While the pixel is pixel index 2-5, else branch to next part
     	sll	$t2, $t1, 2		# Multiply index by 4 bytes
     	add	$t2, $t0, $t2		# Add offset to base address
     	sw	$s6, 1792($t2)		# Load current player's color into the address, offset to bottom of token (7 rows * 256 bytes/row)
     	add	$t1, $t1, 1		# Increment the pixel index
     	j	TokenBot4PixLoop	# Go back and print again
     
  TokenTop6Pix:
    	add	$t0, $t0, 256		# Move base address down a row (256 bytes/row)
    	
  	li	$t1, 1			# Now print starting at 2nd pixel
     TokenTop6PixLoop:
     	beq	$t1, 7, TokenBot6Pix	# While the pixel is pixel index 1-6, else branch to next part
     	sll	$t2, $t1, 2		# Multiply index by 4 bytes
     	add	$t2, $t0, $t2		# Add offset to base address
     	sw	$s6, ($t2)		# Load current player's color into the address
     	add	$t1, $t1, 1		# Increment the pixel index
     	j	TokenTop6PixLoop	# Go back and print again
     	
  TokenBot6Pix:
  	li	$t1, 1			# Now print starting at 2nd pixel
     TokenBot6PixLoop:
     	beq	$t1, 7, TokenMidPix	# While the pixel is pixel index 1-6, else branch to next part
     	sll	$t2, $t1, 2		# Multiply index by 4 bytes
     	add	$t2, $t0, $t2		# Add offset to base address
     	sw	$s6, 1280($t2)		# Load current player's color into the address, offset 5 rows down (5 rows * 256 bytes/row)
     	add	$t1, $t1, 1		# Increment the pixel index
     	j	TokenBot6PixLoop	# Go back and print again
     	
   TokenMidPix:
   	add	$t0, $t0, 256		# Move base address down a row (256 bytes/row)
   	
   	li	$t1, 0			# Let $t1 hold the pixel column, initialized to 0
   	li	$t3, 0			# Let $t3 hold the pixel row, initialized to 0
     TokenMidPixLoop:
     	beq	$t1, 8, TokenMidPixNext	# Print for column index 0-7, else go to cycle next row
     	sll	$t4, $t3, 8		# Multiply the row index by 256 bytes
     	sll	$t2, $t1, 2		# Multiply the col index by 4 bytes
     	add	$t2, $t2, $t4		# Add total row and col bytes to get total offset
     	add	$t2, $t0, $t2		# Add offset to base address
     	sw	$s6, 0($t2)		# Load current player's color into the address
     	add	$t1, $t1, 1		# Increment the pixel index
     	j	TokenMidPixLoop		# Go back and print again
     TokenMidPixNext:
     	beq	$t3, 3, JumpReturn	# Print rows 1-3, if the row is 3, jump return to main
     	li	$t1, 0			# Otherwise, reset the column index
     	add	$t3, $t3, 1		# Increment the row index
     	j	TokenMidPixLoop		# And go back to continue printing
     	


CheckWinCondition:
#============================== Notes ===================================================================

#	$s0 = used globally to keep track of current turn
#	    = 79 for player turn
#	    = 88 for computer turn
#	$s1 = used globally to keep track of selected input column, regardless of
#	    	player or computer turn
#	$s2 = current move's physical address in Gameboard Array
#	$s3 = current move's column index
#	$s4 = current move's row index
#	79 = 79, register holder for player token in ascii value.  Compare to $s0 for current turn
#	88 = 88, register holder for computer token in ascii value.  Compare to $s0 for current turn

#===================== For This Check-Win-Condition Segment =============================================

#	$t0 = counter
#	$t2 = traversing physical address in array
#	$t3 = traversing column index
#	$t4 = traversing row index

#========================================================================================================

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

CheckNegDiag:

	li	$t0, 1				#counter for counting tokens-in-a-row
	add	$t3, $s3, $0			#set traversing column index to the last token
	add	$t4, $s4, $0			#set traversing row index to the last token
	add	$t2, $s2, $0			#set traversing physical address to the last token
	NegDiagLoopLeft:	
	beq	$t3, 0, NegDiagRight		#if the traversing column index is 0, go to next check
	beq	$t4, 6, NegDiagRight		#if the traversing row index is 6, go to next check
	
	add	$t3, $t3, -1			#set traversing column index to one left
	add	$t4, $t4, 1			#set traversing row index to one above
	add	$t2, $t2, 6			#set traversing physical address to left upper diagonal slot
	lb	$t1, ($t2)			#load the token in the traversing checker
	bne	$t1, $s0, NegDiagRight		#if it is not equal to the current player's token, branch to next check
	
	addi	$t0, $t0, 1			#else, tokens-in-a-row++
	beq	$t0, $t9, WinnerFound		#if tokens-in-a-row = win condition, found a winner
	j	NegDiagLoopLeft
	
	NegDiagRight:				#Keeping the current counter for tokens-in-a-row
	add	$t3, $s3, $0			#reset traversing column index to the last token
	add	$t4, $s4, $0			#reset traversing row index to the last token
	add	$t2, $s2, $0			#reset traversing physical address to the last token
	
	NegDiagLoopRight:
	beq	$t3, 6, CheckPosDiag		#if the traversing column index is 6, go to next check
	beq	$t4, 0, CheckPosDiag		#if the traversing row index is 0, go to next check
	
	add	$t3, $t3, 1			#set traversing column index to one right
	add	$t4, $t4, -1			#set traversing row index to one below
	add	$t2, $t2, -6			#set traversing physical address to right lower diagonal slot
	lb	$t1, ($t2)			#load the token in the traversing checker
	bne	$t1, $s0, CheckPosDiag		#if it is not equal to the current player's token, branch to next check
	
	addi	$t0, $t0, 1			#else, tokens-in-a-row++
	beq	$t0, $t9, WinnerFound		#if tokens-in-a-row = win condition, found a winner
	j	NegDiagLoopRight

CheckPosDiag:

	li	$t0, 1				#counter for counting tokens-in-a-row
	add	$t3, $s3, $0			#set traversing column index to the last token
	add	$t4, $s4, $0			#set traversing row index to the last token
	add	$t2, $s2, $0			#set traversing physical address to the last token
	
	PosDiagLoopLeft:	
	beq	$t3, 0, PosDiagRight		#if the traversing column index is 0, go to next check
	beq	$t4, 0, PosDiagRight		#if the traversing row index is 0, go to next check
	
	add	$t3, $t3, -1			#set traversing column index to one left
	add	$t4, $t4, -1			#set traversing row index to one below
	add	$t2, $t2, -8			#set traversing physical address to left lower diagonal slot
	lb	$t1, ($t2)			#load the token in the traversing checker
	bne	$t1, $s0, PosDiagRight		#if it is not equal to the current player's token, branch to next check
	
	addi	$t0, $t0, 1			#else, tokens-in-a-row++
	beq	$t0, $t9, WinnerFound		#if tokens-in-a-row = win condition, found a winner
	j	PosDiagLoopLeft
	
	PosDiagRight:				#Keeping the current counter for tokens-in-a-row
	add	$t3, $s3, $0			#reset traversing column index to the last token
	add	$t4, $s4, $0			#reset traversing row index to the last token
	add	$t2, $s2, $0			#reset traversing physical address to the last token
	
	PosDiagLoopRight:
	beq	$t3, 6, NoWinnerFound		#if the traversing column index is 6, no winner found
	beq	$t4, 6, NoWinnerFound		#if the traversing row index is 6, no winner found
	
	add	$t3, $t3, 1			#set traversing column index to one right
	add	$t4, $t4, 1			#set traversing row index to one above
	add	$t2, $t2, 8			#set traversing physical address to right upper diagonal slot
	lb	$t1, ($t2)			#load the token in the traversing checker
	bne	$t1, $s0, NoWinnerFound		#if it is not equal to the current player's token, branch to next check
	
	addi	$t0, $t0, 1			#else, tokens-in-a-row++
	beq	$t0, $t9, WinnerFound		#if tokens-in-a-row = win condition, found a winner
	j	PosDiagLoopRight
	
	NoWinnerFound:
	jr	$ra			#No winner found, return to game loop
	
WinnerFound:
	jal	BitmapEndGameBar	#Print white announcement bar (Note: $ra to game loop lost)
	beq	$s5, 2, TwoPlayerWinner	#if the game is 2-player mode ($s5 = 2), then go to 2-P Printer
	
	beq	$s0, 79, PlayerWinner
	beq	$s0, 88, ComputerWinner
	j	LogicalError

BitmapPrint:
	# $a0 must be initialized to starting address of array of pixel indices to change
	# $a1 must be initialized to number of word addresses in array of pixel indices
	# $a2 must be intialized with color to store in each pixel
	li	$t2, 0
  BitmapPrintLoop:
  	beq	$t2, $a1, JumpReturn

  	sll	$t3, $t2, 2
  	add	$t4, $t3, $a0
  	lw	$t4, ($t4)
  	sll	$t4, $t4, 2
  	sw	$a2, 0x10010000($t4)  	
  	add	$t2, $t2, 1
	j	BitmapPrintLoop
	

BitmapEndGameBar:
#Print white bar at bitmap row starting at pixel 1472 ending 9 rows down
#Starting address: 0x10010000 + 1472*4 = 0x10011700
	li	$t0, 0
	li	$t1, 0
	li	$t2, 0x10011700
	li	$t6, 0x00C8C8C8
  BMEndGameBarLoop:
	beq	$t1, 64, JumpReturn
	beq	$t0, 9, NextBMBarCol
	
	sll	$t3, $t0, 6
	add	$t3, $t3, $t1
	sll	$t3, $t3, 2
	
	lw	$t4, 0x10011700($t3)
	beq	$t4, 0x003333FF, DimBlue
	beq	$t4, 0x00FFFF00, DimYellow
	beq	$t4, 0x00FF0000, DimRed
	sw	$t6, 0x10011700($t3)	
    ContEndGameBar:	
	add	$t0, $t0, 1
	j	BMEndGameBarLoop
    DimBlue:
    	li	$t5, 0x00FBFBFF
    	sw	$t5, 0x10011700($t3)
    	j	ContEndGameBar
    DimYellow:
        li	$t5, 0x00FFFFC8
    	sw	$t5, 0x10011700($t3)
    	j	ContEndGameBar
    DimRed:	
        li	$t5, 0x00FFC8C8
    	sw	$t5, 0x10011700($t3)
    	j	ContEndGameBar
	
  NextBMBarCol:
	add	$t1, $t1, 1
	li	$t0, 0
	
	li	$v0, 32
	li	$a0, 1
	syscall
	
	j	BMEndGameBarLoop

PlayerWinner:
	la	$a0, BitmapYouWin	# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 62			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated
	jal	BitmapPrint		# Call Bitmap Print sub-routine
		
	li	$v0, 4			#system call code for Print String
	la	$a0, WinMsg 		#load address of win message
	syscall				#print
	
	la	$t4, Music_Victory_NoteCt
	lw	$t4, ($t4)		# $t4 loaded with number of notes
	la	$t0, Music_Victory_Note	# $t0 must be loaded with base address of array of notes
	la	$t1, Music_Victory_Dur	# $t1 must be loaded with base address of array of duration of note
	la	$t2, Music_Victory_Instr# $t2 must be loaded with base address of array of instrument of note
	la	$t3, Music_Victory_Vol	# $t3 must be loaded with base address of array of volume of note
	jal	PlaySound		#play sound
	
	
	j	EndGame
	
ComputerWinner:
	la	$a0, BitmapYouLose	# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 66			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated	
	jal	BitmapPrint		# Call Bitmap Print sub-routine
	
	li	$v0, 4			#system call code for Print String
	la	$a0, LoseMsg 		#load address of win message
	syscall				#print

	la	$t4, Music_Defeat_NoteCt
	lw	$t4, ($t4)		# $t4 loaded with number of notes
	la	$t0, Music_Defeat_Note	# $t0 must be loaded with base address of array of notes
	la	$t1, Music_Defeat_Dur	# $t1 must be loaded with base address of array of duration of note
	la	$t2, Music_Defeat_Instr # $t2 must be loaded with base address of array of instrument of note
	la	$t3, Music_Defeat_Vol	# $t3 must be loaded with base address of array of volume of note
	jal	PlaySound		#play sound
	
	j	EndGame

TwoPlayerWinner:
	beq	$s0, 79, Player1Wins
	beq	$s0, 88, Player2Wins
	j	LogicalError
	
Player1Wins:
	la	$a0, BitmapPlayer	# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 57			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated
	jal	BitmapPrint		# Call Bitmap Print sub-routine
	
	la	$a0, BitmapNo1		# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 8			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated
	jal	BitmapPrint		# Call Bitmap Print sub-routine
	
	la	$a0, BitmapWins	# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 43			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated
	jal	BitmapPrint		# Call Bitmap Print sub-routine
	
	li	$v0, 4			#system call code for Print String
	la	$a0, P1WinMsg		#load address of win message
	syscall				#print
	j	EndGame
	
Player2Wins:	
	la	$a0, BitmapPlayer	# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 57			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated
	jal	BitmapPrint		# Call Bitmap Print sub-routine
	
	la	$a0, BitmapNo2		# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 10			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated
	jal	BitmapPrint		# Call Bitmap Print sub-routine
	
	la	$a0, BitmapWins	# Load $a0 with address of array of pixel indices for pixels to print statement
	li	$a1, 43			# Load $a1 with number of pixels to change (length of pixel index array)
	li	$a2, 0x00000000		# Load $a2 with 24-RGB color for each pixel updated
	jal	BitmapPrint		# Call Bitmap Print sub-routine
	
	li	$v0, 4			#system call code for Print String
	la	$a0, P2WinMsg 		#load address of win message
	syscall				#print
	j	EndGame
	
PlaySound:
	# $t4 must be loaded with number of notes
	# $t0 must be loaded with base address of array of notes
	# $t1 must be loaded with base address of array of duration of note
	# $t2 must be loaded with base address of array of instrument of note
	# $t3 must be loaded with base address of array of volume of note
	li	$t5, 0
	li	$v0, 33
	
  SoundLoop:
  	beq	$t5, $t4, JumpReturn
  
	sll	$t6, $t5, 2
	add	$a0, $t0, $t6
	add	$a1, $t1, $t6
	add	$a2, $t2, $t6
	add	$a3, $t3, $t6
	
	lw	$a0, ($a0)
	lw	$a1, ($a1)
	lw	$a2, ($a2)
	lw	$a3, ($a3)
	
	syscall 
	
	add	$t5, $t5, 1
	j	SoundLoop 
	
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
	la	$a0, InvalidMsg  	#load address of invalid message
	syscall				#print invalid message
	j	EndGameLoop

EndProgram:	
	li      $v0, 10              	# terminate program run and
  	syscall                      	# Exit
	
LogicalError:
	li	$v0, 4			#system call code for Print String
	la	$a0,InvalComMovMsg 	#load address of error prompt
	syscall				#print error prompt	
