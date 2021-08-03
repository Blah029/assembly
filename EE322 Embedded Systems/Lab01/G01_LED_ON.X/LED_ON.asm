processor   16F84A		    ; turn on listing output
#include    <p16f84a.inc>	    ; inlcude file for register names
    
res_vect    code	0x00	    ; assign reset vector
    goto    main

main
    bsf	    STATUS,	5	    ; select bank 1
    movlw   b'00000000'		    ; move tri-state values to w
    movwf   TRISB		    ; set all port b pins as output
    bcf	    STATUS,	5	    ; select bank 0
    movlw   b'11111111'		    ; move pin on/off state to w
    movwf   PORTB		    ; turn on all port b pins
    goto    $			    ; loop

end
