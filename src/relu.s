.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1  
    blt a1, t0, error   #if a1 < 1 means there's no elements in array
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    beqz a1, done    #a1 : loop count   
    lw t2, 0(a0)
    bge t2, t1, loop_end     # if element > 0
    sw t1, 0(a0)        #if element < 0, store 0 to array

    
loop_end:
    addi a0, a0, 4  # next element
    addi a1, a1, -1 # loop coont -1
    j loop_start
    
error:
    li a0, 36          
    j exit         

done:
    jr ra