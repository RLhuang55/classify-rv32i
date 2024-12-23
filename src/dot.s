.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t5, 1              
    blt a2, t5, error_terminate  
    blt a3, t5, error_terminate   
    blt a4, t5, error_terminate  
    slli a3, a3, 2
    slli a4, a4, 2
    li t0, 0            
    li t1, 0            

loop_start:
    beq t1, a2, loop_end
    lw t2, 0(a0)       
    lw t3, 0(a1)        
    li t4, 0           


    mul_loop:
        beqz t3, mul_end
        andi t6, t3, 1      
        beqz t6, skip_add
        add t4, t4, t2      
    skip_add:
        srli t3, t3, 1      
        slli t2, t2, 1       
        j mul_loop

    mul_end:
        add t0, t0, t4      
        add a0, a0, a3       
        add a1, a1, a4      
        addi t1, t1, 1       
        j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t5, set_error_36  
    li a0, 37
    j exit           

set_error_36:
    li a0, 36
    j exit