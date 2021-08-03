processor	16F84A			    ; turn on listing output
#include	<p16f84a.inc>		    ; include file for register names

resVect		code	    0x00	    ; upcode
    goto	init
    
intVect		code	    0x04	    ; interrupt service routine
    btfsc	INTCON,	    INTF	    ; check of RB0 interrupt flag
    call	RB0_isr
    retfie
    
init					    ; initialisation
    ; what in tarnation start (idk why RA1 is always set when proteus starts)
    bcf		STATUS,	    RP0		    ; access bank 0
    bcf		PORTA,	    RA0		    ; clear RA0
    ; what in tarnation end
    bsf		STATUS,	    RP0		    ; access bank 1
    bsf		INTCON,	    GIE		    ; enable all unmasked interrupts
    bsf		INTCON,	    INTE	    ; enable(unmask?) external interrupts
    bsf		OPTION_REG, INTEDG	    ; set RB0 as rising edge interrupt
    movlw	b'00000000'		    ; move tri-state values to w
    movwf	TRISA			    ; set all port b pins as output
    movlw	b'1111111'		    ; move tri-state values to w
    movwf	TRISB			    ; set all port b pins as input
    ;call	testing
    goto	main
    
main					    ; main code
    goto	main
   
RB0_isr
    bcf		STATUS,	    RP0		    ; access bank 0
    bcf		INTCON,	    INTF	    ; clear RB0 interrup flag
    bsf		PORTA,	    RA0		    ; set RA0
    movlw	b'01000111'		    ; move 255 to w
    movwf	0x0c			    ; set countdown starting point
    movlw	b'01000110'		    ; move 255 to w
    movwf	0x0d			    ; set secondary starting point
    movlw	b'00000010'		    ; move 255 to w
    movwf	0x0e			    ;set tertiary starting point
    
    delay
	
		decfsz		0x0c,	    1   ; nested 0C decrement loop
		goto		delay
    
	    decfsz	    0x0d,	    1	; nested 0D decrement loop
	    goto	    delay
	
	decfsz	    0x0e,	    1	    ; 0E decrement loop
	goto	    delay
    
    bcf		PORTA,	    RA0		    ; clear RA0
    return
    
testing
    bcf		STATUS,	    RP0		    ; access bank 0
    bsf		INTCON,	    INTF	    ; set RB0
    return
    
end