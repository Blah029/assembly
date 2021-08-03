processor   16F84A		    ; turn on listing output
#include    <p16f84a.inc>	    ; inlcude file for register names
    
res_vect    code	0x00	    ; assign reset vector
    goto    start
    
start
    bsf	    STATUS,	5	    ; select bank 1
    movlw   b'00000000'		    ; move tri-state values to w
    movwf   TRISB		    ; set all port b pins as output

main
    bcf	    STATUS,	5	    ; select bank 0
    movlw   b'11111111'		    ; move pin on state to w
    movwf   PORTB		    ; turn on all port b pins
    call    delay		    ; call delay subroutine
    movlw   b'00000000'		    ; move pin off state to w
    movwf   PORTB		    ; turn off all port b pins
    call    delay		    ; call delay subroutine
    goto    main		    ; loop

delay				    ; delay for 255x255 cycles
    loop1
	decfsz	0x0c,	1	    ; decrement 0ch by 1 and keep new value
	goto    loop1		    ; keep decrementing och until 0
    
    decfsz  0x0d,	1	    ; decrement odh by 1 and keep new value
    goto    loop1		    ; keep decrementing odh until 0
    return			    ; return to main routine

end
