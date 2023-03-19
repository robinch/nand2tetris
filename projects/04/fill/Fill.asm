// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// 8k = 8192

// General idea
// In a infinite loop
// Check if all KBD bits are 0
// if true set them all to 0
// else set all values in the SCREEN addresses to 1

// Pseudo code

// LOOP:
// 	if (KBD == 0) goto FILL_WHITE
// 	color = -1 // 1111111111111111
// 	goto FILL
// FILL_WHITE:
// 	color = 0 // 0000000000000000
// FILL:
// 	current = &SCREEN
// 	end = 8192 + &SCREEN
// FILL_LOOP
// 	if (current == end) goto LOOP
// 	*current = color
// current = current + 1
// 	goto FILL_LOOP

// Implementation

(LOOP)
	// if (KBD == 0) goto FILL_WHITE
	@KBD
	D=M
	@FILL_WHITE
	D;JEQ
	// set color black
	@color
	M=-1
	// goto fill
	@FILL
	0;JMP
(FILL_WHITE)	
	// set color to white
	@color
	M=0
(FILL)
	// current = &SCREEN
	@SCREEN
	D=A
	@current
	M=D
	// end = &SCREEN + 8192
	@SCREEN
	D=A
	@end
	M=D
	@8192
	D=A
	@end
	M=M+D
(FILL_LOOP)
	// if (curent == end) goto LOOP
	@current
	D=M
	@end
	D=D-M
	@LOOP
	D;JEQ
	// 	*current = color
	@color
	D=M
	@current
	A=M
	M=D
	// current = current + 1
	@current
	M=M+1
	// goto FILL_LOOP
	@FILL_LOOP
	0;JMP

	

	
	


