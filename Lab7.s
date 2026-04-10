.section .data
PortA .byte 0x701   # Port A and port B are flippe
PortB .byte 0x700

LED .byte 0x640 # address of first LED

CharS .byte 0b01101101
CharH .byte 0b01110110
CharE .byte 0b01111001

.section .text
.globl _start
_start:
    mov $0b10000000,%al #set bit command byte A
                        # Group B Mode 0,
                        # Port B output, Port C output
                        # Group A Mode 0,
                        # Port A output, Port C output
    mov $0x703,%dx      # Program port xxx of device
    out %al,%dx         # display, I/O address 0x700
    mov LED, %si        # holds the location of the first LED
    mov $7, %bx         # max amount of cycles 
    mov $0, %cx         # holds the counter - starts at three as three led need to display to start
    jmp loopr

loopr:
    mov PortA, %dx        # address of port A 
    mov [%si + %cx], %al  # sends the leds that need to be lit
    out %al, %dx          # lights up leds    
    dec %dx               # moves to port B
    mov charE, %al        # sends 'E' to the LED
    out %al, %dx          # displays led
    inc %dx               # moves %dx to port A
    inc %cx               # incraments counter
    mov [%si + %cx], %al  # lights up next LED
    out %al, %dx          # displays LED
    dec %dx               # moves to port B 
    mov charH, %al        # sends 'H' to the LED
    out %al, %dx          # displays 'H'
    inc %dx               # moves back to Port A
    inc %cx               
    mov [%si + %cx], %al  # moves to the next LED
    out %al, %dx          # makes LED light up
    dec %dx               # moves back to port B
    mov charS, %al        # sends 'S' to LED
    out %al, %dx          # displays 'S'
    dec %cx               # deincraments counter once to be one more than the beginning
    cmp %cx, %bx          # checks to see if max count has been reached
    jl loopr              # continues the loop to the right
    jmp loopl             # will start loop to the left once the end is reached

loopl:
    mov PortA, %dx        # address of port A 
    mov [%si + %cx], %al  # sends the leds that need to be lit
    out %al, %dx          # lights up leds    
    dec %dx               # moves to port B
    mov charS, %al        # sends 'E' to the LED
    out %al, %dx          # displays led
    inc %dx               # moves %dx to port A
    dec %cx               # increments counter
    mov [%si + %cx], %al  # lights up next LED
    out %al, %dx          # displays LED
    dec %dx               # moves to port B 
    mov charH, %al        # sends 'H' to the LED
    out %al, %dx          # displays 'H'
    inc %dx               # moves back to Port A
    dec %cx               
    mov [%si + %cx], %al  # moves to the next LED
    out %al, %dx          # makes LED light up
    dec %dx               # moves back to port B
    mov charE, %al        # sends 'S' to LED
    out %al, %dx          # displays 'S'
    inc %cx               # deincrements counter once to be one more than the beginning
    cmp %cx, $0           # checks to see if the counter is back to zero
    jg loopl              # continues the loop moving the LEDs to the left
    jmp loopr             # if counter is 0 will start moving the LEDs to the right
    


