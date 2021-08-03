    processor   16F84A			    ; turn on listing output
    #include    <p16f84a.inc>		    ; include file for register names

resVect		code	    0x00	    ; upcode
    goto	int
    
int					    ; initialisation
    ; what in tarnation start (idk why RA1 is always set when proteus starts)
    bcf		STATUS,	    RP0		    ; access bank 0
    bcf		PORTA,	    RA0		    ; clear RA0
    ; what in tarnation end
    bsf	        STATUS,	    RP0		    ; access register bank 0
    movlw	b'00000000'		    ; move tri-state values to w
    movwf	TRISA			    ; set all port b pins as output
    movlw	b'1111111'		    ; move tri-state values to w
    movwf	TRISB			    ; set all port b pins as input
    goto	main
    
main
    bcf		STATUS,	    RP0		    ; access bank 0
    btfsc	PORTB,	    RB0		    ; skip next if port RB0 is clear
    call	holdLed
    btfss	PORTB,	    RB0		    ; skip next if port RB0 is set
    bcf		PORTA,	    RA0		    ; clear RA0
    goto	main
   
holdLed
    bsf		PORTA,	    RA0		    ; set RA0
    movlw	b'01000111'		    ; move 255 to w
    movwf	0x0c			    ; set countdown starting point
    movlw	b'01000110'		    ; move 255 to w
    movwf	0x0d			    ; set secondary starting point
    call	delay
    
delay
	decfsz	    0x0c,	    1	    ; nested 0C decrement loop
	goto	    delay
    
    decfsz	0x0d,	    1		    ; 0D decrement loop
    goto delay
    
end