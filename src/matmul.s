.globl matmul

.text
matmul:
    # Error checks
    li t0 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
    li s0, 0 # outer loop counter
    li s1, 0 # inner loop counter
    mv s2, a6 # incrementing result matrix pointer
    mv s3, a0 # incrementing matrix A pointer, increments durring outer loop
    mv s4, a3 # incrementing matrix B pointer, increments during inner loop 
    
outer_loop_start:
    #s0 is going to be the loop counter for the rows in A
    li s1, 0
    mv s4, a3
    blt s0, a1, inner_loop_start

    j outer_loop_end
    
inner_loop_start:
# HELPER FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use = number of columns of A, or number of rows of B
#   a3 (int)  is the stride of arr0 = for A, stride = 1
#   a4 (int)  is the stride of arr1 = for B, stride = len(rows) - 1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
    beq s1, a5, inner_loop_end

    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    
    mv a0, s3 # setting pointer for matrix A into the correct argument value
    mv a1, s4 # setting pointer for Matrix B into the correct argument value
    mv a2, a2 # setting the number of elements to use to the columns of A
    li a3, 1 # stride for matrix A
    mv a4, a5 # stride for matrix B
    
    jal ra, dot
    
    mv t0, a0 # storing result of the dot product into t0
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    addi sp, sp, 28
    
    sw t0, 0(s2)
    addi s2, s2, 4 # Incrememtning pointer for result matrix
    
    li t1, 4
    add s4, s4, t1 # incrememtning the column on Matrix B
    
    addi s1, s1, 1
    j inner_loop_start
    
inner_loop_end:
    # Increment outer loop counter i
    addi s0, s0, 1

    # Update matrix A pointer to the next row
    # Replace 'mul t0, s0, a2' with RV32I instructions
    li t0, 0          # Initialize t0 = 0 (result)
    mv t1, a2         # t1 = a2 (multiplier)
    mv t2, s0         # t2 = s0 (multiplicand)

mult_loop:
    beq t1, x0, mult_end
    add t0, t0, t2    # t0 += s0
    addi t1, t1, -1   # t1 -= 1
    j mult_loop

mult_end:
    slli t0, t0, 2    # t0 = t0 * 4 (bytes per element)
    add t1, a0, t0    # t1 = A + i * m * 4
    mv s3, t1         # s3 = pointer to A[i][0]

    j outer_loop_start

outer_loop_end:
    # =========================
    # Function Epilogue: Restore registers and return
    # =========================
    lw ra, 0(sp)               # Restore return address
    lw s0, 4(sp)               # Restore s0
    lw s1, 8(sp)               # Restore s1
    lw s2, 12(sp)              # Restore s2
    lw s3, 16(sp)              # Restore s3
    lw s4, 20(sp)              # Restore s4
    lw s5, 24(sp)              # Restore s5
    addi sp, sp, 28            # Release stack space
    jr ra                      # Return to caller

error:
    li a0, 38
    jal exit

