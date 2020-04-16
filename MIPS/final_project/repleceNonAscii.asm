#================= DATA SECTION ============================
        	.data
# Buffers
inFileNameBuff:	.space		64		# storing name of input file
outFileNameBuff:	.space		64		# storing name of input file
inputBuff: 	.space		512		# stores contents of processed file
outputBuff: 	.space		512		# stores contents of processed file

# Text Messages
startMsg:	.asciiz		"===> Welcome to program replacing all non-ASCII characters with escape sequences.\n"
inputMsg:	.asciiz		"\nPlease input new file name on which u want to execute the program (or nothing if you want to exit): "
inputMsgOut:	.asciiz		"\nPlease input new file name in which u want to save the program results (or nothing if you want to exit): "
restartMsg:	.asciiz		"\nType 0 to terminate the program, or anything else to restart it once again: "
fileErrorMsg:	.asciiz		"\nThere was an error with opening the file. Please make sure You input proper filename"

#================= TEXT SECTION ============================
        .text
main:
# =====>  Register usage convention used in this program:
#	a0-a3	Arguments of syscalls and functions
#	t0-t4	Temporary values needed only for given scope, used in subroutines
#	t5-t7	Temporary registers needed for a larger scope,	should not be used in subroutines
#	s0-s4	Save register holding same (!with same meaning not exactly the same) value through whole execution of program:
# 	s0:	Stores filedescriptor of file program is reading from
# 	s1:	Stores filedescriptor of file program is writing to
#	s2;	Stores length of input bufer
#	s3;	Stores length of output bufer
#	s4:	Flag holding ascii value of " symbol or ' symbol (depending in whihc we are in) or 0 if we are not in any string/char sequence
# 	other registers are not used

# Program Start Message
	la 	$a0,	startMsg
	li	$v0,	4
	syscall
	b	nextIter
	
###########################################################
############### INPUT FILE OPENING ########################
###########################################################

# handling error while opening input file
inFileError:
	la 	$a0,	fileErrorMsg
	li	$v0,	4
	syscall
nextIter:

# File name request message
	la 	$a0,	inputMsg
	li	$v0,	4
	syscall
	
# File name input request
	la 	$a0,	inFileNameBuff
	li 	$a1,	64
	li	$v0,	8
	syscall

# Checking if user wants to terminate the program (if he entered only new line)
	la 	$a0,	inFileNameBuff
	lb	$t0,	($a0)
	ble	$t0,	10,	terminate

# replacing new line with null terimator in file name (so it can be used later while opeining file)
	jal	nwlReplace
	

# Opening input file ================================
	# Open (for reading) a inFileName program
	la   	$a0, 	inFileNameBuff		# input file name
	li   	$a1, 	0			# Open for reading (flags are 0: read, 1: write)
	li   	$a2, 	0			# mode is ignored
	li  	$v0, 	13			# system call for open file
	syscall					# open a file (file descriptor returned in $v0)
# Fiile Opened =======================================
	move 	$s0,	$v0			# save the file descriptor
# Error check
	blt	$s0,	0,	inFileError	# if there was an error opening the file, routine is repeated
	b 	outputRead
###########################################################
############### OUTPUT FILE OPENING #######################
###########################################################
	
outFileError:
	la 	$a0,	fileErrorMsg
	li	$v0,	4
	syscall
outputRead:
# OUTPUT FILE
# File name request message
	la 	$a0,	inputMsgOut
	li	$v0,	4
	syscall
	
# File name input request
	la 	$a0,	outFileNameBuff
	li 	$a1,	64
	li	$v0,	8
	syscall
	
# replacing new line with null terimator
	jal	nwlReplace

# Opening output file ================================
# Open (for writing) a main.c program
	la   	$a0, 	outFileNameBuff		# output file name
	li   	$a1, 	1			# Open for reading (flags are 0: read, 1: write)
	li   	$a2, 	0			# mode is ignored
	li  	$v0, 	13			# system call for open file
	syscall					# open a file (file descriptor returned in $v0)
# Fiile Opened =======================================
	move 	$s1,	$v0			# save the file descriptor
	blt	$s1,	0,	outFileError	# if there was an error opening the file, routine is repeated

###########################################################
################## FILE PROCESSING SECTION ################
###########################################################

# ===> Reading input file to the buffer =================
# Zeroing important registers:
  	li	$s2,	0			# holds the current position in input buffer
  	li	$s3,	0			# holds the current position in output buffer
  	li	$s4,	0			# flag checking if we are in middle of string or character constant (holding ascii value of " or ' respectivly)
read:
	jal	getc				# reading single char from buffer
	move	$t7,	$v0			# saving symbol coding in t7 since t0 may be used in subroutines
	
	beq	$t7,	0,	endRead		# end of file, ending processing
	beqz	$s4,	skip			# we are not in string nor in char sequence so wwe are not checking for non ascii char
	bge	$t7,	128, 	nonAscii	# we are in string or char sequence, so if given char has code bigger than 127 we process it
skip:
	move	$a0,	$t7			# saving current char to output
	jal	putc
	
# Handling different " ' combinations:
	beq	$t7,	'"',	switchFlag
	bne	$t7,	'\'',	read		# if current caracter is not " nor ' we go to next iteration (with next char)
	
switchFlag:
	bnez	$s4,	flagReset		# if we are already in string or char we might need to reset the flag
	move	$s4,	$t0			# if not we mark in which we are by seting flag to its coding
	j	read

flagReset:
	bne	$t7,	$s4,	read		# if we have ' symbol in " " or " in ' ' we skip
	li	$s4,	0			# otherwise we reset the flag
	j	read

# ===> Handling non Ascii symbol (with code bigger than 127)
nonAscii:
# adding \x prefix to output buff
	li	$a0,	'\\'
	jal 	putc
	li	$a0,	'x'
	jal 	putc
	
# converting number to hexadecimal and saving it to output buff
	move	$a0,	$t7
	jal	decToHex
	move	$a0,	$v0
	move	$t2,	$v1		
	jal	putc				# putting calculated hex to output buff
	move	$a0,	$t2
	jal	putc
	
	beq	$s4,	'\'',	read		# skipping "" postifx if we are in character sequence
# adding "" postfix to output buff
	li	$a0,	'"'
	jal 	putc
	li	$a0,	'"'
	jal 	putc
	
	j 	read
	
endRead:
# end of input file, ending loop
# saving rest of ouptut buffer to file (flash)
	move	$a0,	$s1
	la	$a1,	outputBuff
	move	$a2,	$s3
	li	$v0,	15
	syscall


###########################################################
################## FILE CLOSING SECTION ###################
###########################################################

# Closing the input file
	li	$v0,	16       # system call for close file
  	move	$a0,	$s0      # file descriptor to close
  	syscall            # close file
  	
 # Closing the output  file
	li	$v0,	16       # system call for close file
  	move	$a0,	$s1      # file descriptor to close
  	syscall            # close file
  	

###########################################################
################## PROGRAM END  SECTION ###################
###########################################################

# displaying restart question msg
	la 	$a0,	restartMsg
	li	$v0,	4
	syscall
	
# user choice input
	la 	$a0,	inFileNameBuff
	li 	$a1,	64
	li	$v0,	8
	syscall
	
# Checking if user wants to terminate the program
	la 	$a0,	inFileNameBuff
	lb	$t0,	($a0)
	bne	$t0,	48,	nextIter

terminate:
# TERMINATING PROGRAM
  	li $v0, 10
	syscall
	
#########################################################################
#########################################################################
  
      
###########################################################
################## FUNCTIONS SECTION ######################
###########################################################
# =====> getc function
# desc: 	Function that takes 512 symbol from input file to the input buffer then returns each symbol one by one and if end of buffer is reached it
#		takes next 512 symboles from file (if there are any) or if buffer is less than 512 (end of file was reached) it puts null terminator at the end of it
# arguments:
# $a0:		not used
# $a1:		not used
# $a2, $a3:	not used
# returns:
# $v0:		single character
# $v1:		not used
getc:
	beqz	$s2,	load
	bne	$s2,	512,	skipLoad
	li	$s2,	0
load:
	li	$v0,	14
	move	$a0,	$s0
	la	$a1,	inputBuff
	li	$a2,	512
	syscall
	
	beq	$v0,	512,	skipLoad	# if we read 512 symbols we skip adding end of file null terminator in buffer
	la	$a1,	inputBuff
	addu	$a1,	$a1,	$v0
	li	$t0,	0
	sb	$t0,	($a1)
	
skipLoad:
	la	$a0,	inputBuff
	addu	$a0,	$a0,	$s2
	addu	$s2,	$s2,	1
	lbu	$v0,	($a0)
	jr 	$ra
# =====> end of function

############################################################

# =====> putc function
# arguments:
# $a0: 		character
# $a1:		buffer
# $a2, $a3:	not used
# returns:
# $v0, $v1:	notused
putc:
	move	$t0,	$a0
	la	$a1,	outputBuff
	ble	$s3,	511,	saveCharPutc
	
	li	$v0,	15	# system call for write to file
	move	$a0,	$s1
	li	$a2,	512	# hardcoded buffer length
	syscall			# write to file
	li	$s3,	0
	
saveCharPutc:
	addu	$a1,	$a1,	$s3
	sb	$t0,	($a1)
	addu	$s3,	$s3,	1
	jr	$ra

# =====> end of function

############################################################

# =====> dec to hex function
# arguments:
# $a0: 		input number
# $a1,$a2, $a3:	not used
# returns:
# $v0:		first part of hex escape sequence
# $v1:		second part of escape sequence
decToHex:
	li	$t0,	15
	and	$t1,	$a0,	$t0
	srl	$t2,	$a0,	4
	
	addu	$t1,	$t1,	48
  	ble	$t1,	57,	notLetter
	addu	$t1,	$t1,	7
notLetter:
	addu	$t2,	$t2,	48
	ble	$t2,	57,	notLetterSecond
	addu	$t2,	$t2,	7
notLetterSecond:
  	move	$v0,	$t2
  	move	$v1,	$t1
	jr 	$ra
# =====> end of function

############################################################

# =====> new line replace function
# Function that replaces new line ending the string with null terminator
# arguments:
# $a0: 		input bufer adress
# $a1,$a2, $a3:	not used
# returns:
# $v0, $v1:	not used
nwlReplace:
nwlReplaceNext:
	addu	$a0,	$a0,	1
	lb	$t0,	($a0)
	bgt	$t0,	10,	nwlReplaceNext
	li	$t0,	0
	sb	$t0,	($a0)
	jr	$ra
# =====> end of function
