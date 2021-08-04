processor		16F84A					; turn on listing output
#include		<p16f84a.inc>		    ; include file for register names

resVect			code	    0x00	    ; upcode
    goto		init
    
intVect			code	    0x04	    ; interrupt service routine
    ; insert code
    retfie
    
init									; initialisation
	bcf			STATUS,		RP0			; access bank 0
	; i don't know don't ask start
	movlw		b'00000000'				; port B pin states
	movwf		PORTB					; turn off all port B pins
	; i don't know don't ask end
    pattern1	equ			0x0c	    ; allocate address for pattern 1
    pattern2	equ			0x0d	    ; allocate address for pattern 2
	patternOut	equ			0x0e		; allocate address for output
	movlw		b'00000010'				; pattern 1
	movwf		pattern1				; store pattern 1
	movlw		b'00010000'				; pattern 2
	movwf		pattern2				; store pattern 2
	bsf			STATUS,		RP0			; access bank 1
	movlw		b'00000000'				; port B tri state
	movwf		TRISB					; set all port B pins as output
    goto		main
    
main									; main code
    call		compare
    goto		main
    
compare
	bcf			STATUS,		RP0			; access bank 0
	; testing values start
	;movlw		b'00010000'				; pattern 1
	;movwf		pattern1				; write to pattern1
	;movlw		b'00100000'				; pattern 2
	;movwf		pattern2				; write to pattern2
	; testing values end
	movf		pattern1,	0			; read pattern1
	subwf		pattern2,	0			; substract pattern1 from pattern2 and store result in w
	
		btfsc		STATUS,		Z			; skip next if arithmetic result is not zero (Z is clear)
		goto		equal
	
		btfss		STATUS,		C			; skip next if not borrow from most significant bit (C is set)
		goto		oneGreater
	
		goto		twoGreater
		endOfIfElse
	
	call		display
	return
	
equal
	movlw		b'00000011'				; output when equal
	movwf		patternOut				; store output
	goto		endOfIfElse
	
oneGreater
	movlw		b'00000010'				; output when pattern1 is greater
	movwf		patternOut				; store output
	goto		endOfIfElse
	
twoGreater
	movlw		b'00000001'				; output when pattern2 is greater
	movwf		patternOut				; store output
	goto		endOfIfElse
	
display
	movf		pattern1,	0			; read pattern1
	movwf		PORTB					; output pattern1 to port B pins
	call		delay
	movf		pattern2,	0			; read pattern2
	movwf		PORTB					; output pattern2 to port B pins
	call		delay
	return
	
delay
	movlw		b'01000111'				; coundown
    movwf		0x0f					; set countdown starting point
    movlw		b'01000110'				; secondary countdown
    movwf		0x10					; set secondary starting point
    movlw		b'00000010'				; tertiary countdown
    movwf		0x11					; set tertiary starting point
	
	delayLoop
	
			decfsz		0x0f,	    1   ; nested 0Ch decrement loop
			goto		delayLoop
    
	    decfsz	    0x10,	    1	; nested 10h decrement loop
		goto	    delayLoop
	
	decfsz	    0x11,	    1	    ; 11h decrement loop
	goto	    delayLoop
	
	return

end
