.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error    #if element num < 1

    lw t0, 0(a0)    #now val

    li t1, 0    #max index
    li t2, 1    #now index
loop_start:
    # TODO: Add your own implementation
    addi a1, a1, -1
    beqz a1, done   #if loop coutn = 0 
    lw t3, 4(a0)    #next val
    bge t3, t0, update #if next val >= now val
    j skip  #no bigger than : continue
update:
    beq t3, t0, skip    #if next val = now val : keep now val index
    mv t0, t3   # update max val
    mv t1, t2   # update max inddex
    
skip:
    addi a0, a0, 4  #next element
    addi t2, t2, 1  #index++
    j loop_start    
done:
    mv a0, t1
    jr ra
handle_error:
    li a0, 36
    j exit
