.ORIG x3000


; Initialization and Data Section
AND R0, R0, #0
AND R1, R1, #0

AND R2, R2, #0

AND R3, R3, #0

AND R4, R4, #0

AND R5, R5, #0

AND R6, R6, #0

AND R7, R7, #0

AND R6, R6, #0 ; Use R6 as the frame pointer

LD R3, FILE_POINTER ; Load the file pointer

LD R2, ZERO ; Initialize counter to 0

; ASCII conversion subroutine (converts a number to its ASCII representation)

ASCII_CONVERT:

    ; Save R0 and R1 on the stack

    JSR PUSH

    ADD R1, R0, #0 ; Copy the number to R1


    ; Handle tens place

    AND R0, R0, #0

    ADD R0, R1, #-10

    BRn PRINT_ONES ; If less than 10, skip tens place

    ; Convert tens digit to ASCII
    ADD R0, R0, #10

    ADD R1, R1, #-10 ; Subtract 10 to get the tens digit

    LD R7, ASCII_BASE  ; Load ASCII base value
    ADD R1, R1, R7 ; Convert tens digit to ASCII

    TRAP x21 ; Print the tens digit

PRINT_ONES:

    ADD R0, R1, R7 ; Convert ones digit to ASCII

    TRAP x21 ; Print the ones digit

    ; Restore R0 and R1 from the stack

    JSR POP

    RET

; Push subroutine (save state)

PUSH:

    ADD R6, R6, #-1

    STR R0, R6, #0

    ADD R6, R6, #-1

    STR R1, R6, #0

    RET

; Pop subroutine (restore state)

POP:

    LDR R1, R6, #0

    ADD R6, R6, #1

    LDR R0, R6, #0

    ADD R6, R6, #1

    RET

; Count the number of items

Count_Items:

    LDR R0, R3, #0 ; Load the next file item into R0 using the file pointer in R3

    BRz END_COUNT  ; If R0 is 0, go to END_COUNT

    ADD R3, R3, #1 ; Increment the file pointer

    ADD R2, R2, #1 ; Increment the counter

    BRnzp Count_Items ; Repeat LOOP

END_COUNT:

    ADD R4, R2, #0 ; Store the total number of items in R4 (outer loop counter)

    BRz SORTED     ; If R4 is 0, go to SORTED (empty file)

    ADD R4, R4, #-1 ; Set R4 to loop n-1 times

; Outer loop of bubble sort

Outerloop:

    BRz SORTED     ; If R4 is zero, go to SORTED (looping complete, exit)

    ADD R5, R4, #0 ; Copy the value of R4 to R5 (initialize inner loop counter to outer)

    LD R3, FILE_POINTER ; Load the file pointer to the beginning of the file

Innerloop:

    LDR R0, R3, #0 ; Load the item at the current file pointer into R0

    LDR R1, R3, #1 ; Load the next item into R1

    NOT R6, R0     ; Calculate the difference between the next item and the current item

    ADD R6, R6, #1

    ADD R6, R6, R1

    BRzp SWAPPED   ; If the difference is negative or zero (in order), go to SWAPPED (don't swap)

    ; Swap the items
    STR R1, R3, #0 ; Store R1 (next item) in the current position

    STR R0, R3, #1 ; Store R0 (current item) in the next position

SWAPPED:

    ADD R3, R3, #1 ; Increment the file pointer

    ADD R5, R5, #-1 ; Decrement the inner loop counter

    BRp Innerloop  ; If the inner loop counter is positive, repeat INNERLOOP


    ADD R4, R4, #-1 ; Decrement the outer loop counter

    BR Outerloop   ; Repeat OUTERLOOP

SORTED:

    LD R3, FILE_POINTER ; Reset the file pointer

    ADD R2, R2, #0 ; Reset counter for display

    BR Display_Sorted

; Display sorted values in ascending order

Display_Sorted:

    LDR R0, R3, #0 ; Load the next item

    BRz END_DISPLAY ; If R0 is 0, end display

    JSR ASCII_CONVERT ; Convert to ASCII

    TRAP x21 ; Output character

    LD R7, SPACE       ; Load space character

    ADD R3, R3, #1 ; Increment file pointer

    ADD R2, R2, #-1 ; Decrement counter

    BR Display_Sorted ; Repeat

END_DISPLAY:

    LD R7, NEWLINE     ; Load newline character

    TRAP x21           ; Print newline for clarity
    HALT ; End of program

; Data Section

FILE_POINTER .FILL x2000
ZERO .FILL #0
ASCII_BASE .FILL x30  ; Base ASCII value for digit conversion
SPACE .FILL x20       ; ASCII space character

NEWLINE .FILL x0A     ; ASCII newline character

; File data
.FILL x0B ; 11
.FILL x08 ; 8
.FILL x02 ; 2
.FILL x11 ; 17
.FILL x06 ; 6
.FILL x04 ; 4
.FILL x03 ; 3

.FILL x15 ; 21

.FILL x00 ; End of data


.END
