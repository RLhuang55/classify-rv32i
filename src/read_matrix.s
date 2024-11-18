.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Binary Matrix File Reader
#
# Loads matrix data from a binary file into dynamically allocated memory.
# Matrix dimensions are read from file header and stored at provided addresses.
#
# Binary File Format.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Binary Matrix File Reader
#
# Loads matrix data from a binary file into dynamically allocated memory.
# Matrix dimensions are read from file header and stored at provided addresses.
#
# Binary File Format:
#   Header (8 bytes):
#     - Bytes 0-3: Number of rows (int32)
#     - Bytes 4-7: Number of columns (int32)
#   Data:
#     - Subsequent 4-byte blocks: Matrix elements
#     - Stored in row-major order: [row0|row1|row2|...]
#
# Arguments:
#   Input:
#     a0: Pointer to filename string
#     a1: Address to write row count
#     a2: Address to write column count
#
#   Output:
#     a0: Base address of loaded matrix
#
# Error Handling:
#   Program terminates with:
#   - Code 26: Dynamic memory allocation failed
#   - Code 27: File access error (open/EOF)
#   - Code 28: File closure error
#   - Code 29: Data read error
#
# Memory Note:
#   Caller is responsible for freeing returned matrix pointer
# ==============================================================================

#|-----------------| <- sp
#|      ra         | <- 0(sp)
#|      s0         | <- 4(sp)
#|      s1         | <- 8(sp)
#|      s2         | <- 12(sp)
#|      s3         | <- 16(sp)
#|      s4         | <- 20(sp)
#| columns (t1)    | <- 28(sp)
#| rows (t2)       | <- 32(sp)
#|-----------------|

read_matrix:
    
    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s3, a1         # save and copy rows
    mv s4, a2         # save and copy cols

    li a1, 0

    jal fopen

    li t0, -1
    beq a0, t0, fopen_error   # fopen didn't work

    mv s0, a0        # file

    # read rows n columns
    mv a0, s0
    addi a1, sp, 28  # a1 is a buffer

    li a2, 8         # look at 2 numbers

    jal fread

    li t0, 8
    bne a0, t0, fread_error

    lw t1, 28(sp)    # opening to save num rows
    lw t2, 32(sp)    # opening to save num cols

    sw t1, 0(s3)     # saves num rows
    sw t2, 0(s4)     # saves num cols

    # mul s1, t1, t2   # s1 is number of elements
    # FIXME: Replace 'mul' with your own implementation
	addi sp, sp, -16
	sw ra, 0(sp)
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	jal ra, mul_func
	lw ra, 0(sp)
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	addi sp, sp, 16

    slli t3, s1, 2
    sw t3, 24(sp)    # size in bytes

    lw a0, 24(sp)    # a0 = size in bytes

    jal malloc

    beq a0, x0, malloc_error

    # set up file, buffer and bytes to read
    mv s2, a0        # matrix
    mv a0, s0
    mv a1, s2
    lw a2, 24(sp)

    jal fread

    lw t3, 24(sp)
    bne a0, t3, fread_error

    mv a0, s0

    jal fclose

    li t0, -1

    beq a0, t0, fclose_error

    mv a0, s2

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 40

    jr ra

malloc_error:
    li a0, 26
    j error_exit

fopen_error:
    li a0, 27
    j error_exit

fread_error:
    li a0, 29
    j error_exit

fclose_error:
    li a0, 28
    j error_exit

error_exit:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 40
    j exit

mul_func:
	# Prologue
	addi sp, sp, -4
	sw s0, 0(sp)
	li s0, 0  # tmp
	li t0, 0  # counter
	bge t0, t1, mul_loop_end 

	mul_loop:
		add s0, s0, t2
		addi t0, t0, 1
		blt t0, t1, mul_loop

	mul_loop_end: 
		# store resullt
		mv s1, s0
		lw s0, 0(sp)
		addi sp, sp, 4
		ret:
#   Header (8 bytes):
#     - Bytes 0-3: Number of rows (int32)
#     - Bytes 4-7: Number of columns (int32)
#   Data:
#     - Subsequent 4-byte blocks: Matrix elements
#     - Stored in row-major order: [row0|row1|row2|...]
#
# Arguments:
#   Input:
#     a0: Pointer to filename string
#     a1: Address to write row count
#     a2: Address to write column count
#
#   Output:
#     a0: Base address of loaded matrix
#
# Error Handling:
#   Program terminates with:
#   - Code 26: Dynamic memory allocation failed
#   - Code 27: File access error (open/EOF)
#   - Code 28: File closure error
#   - Code 29: Data read error
#
# Memory Note:
#   Caller is responsible for freeing returned matrix pointer
# ==============================================================================
read_matrix:
    
    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s3, a1         # save and copy rows
    mv s4, a2         # save and copy cols

    li a1, 0

    jal fopen

    li t0, -1
    beq a0, t0, fopen_error   # fopen didn't work

    mv s0, a0        # file

    # read rows n columns
    mv a0, s0
    addi a1, sp, 28  # a1 is a buffer

    li a2, 8         # look at 2 numbers

    jal fread

    li t0, 8
    bne a0, t0, fread_error

    lw t1, 28(sp)    # opening to save num rows
    lw t2, 32(sp)    # opening to save num cols

    sw t1, 0(s3)     # saves num rows
    sw t2, 0(s4)     # saves num cols

    # mul s1, t1, t2   # s1 is number of elements
    # FIXME: Replace 'mul' with your own implementation
    addi sp, sp, -32
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw t0, 12(sp)
    sw t1, 16(sp)
    sw t2, 20(sp)
    sw t3, 24(sp)
    sw t4, 28(sp)
    mv a0, t1
    mv a1, t2
    jal ra, func_mul
    mv s1, a0
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw t0, 12(sp)
    lw t1, 16(sp)
    lw t2, 20(sp)
    lw t3, 24(sp)
    lw t4, 28(sp)
    addi sp, sp, 32

    slli t3, s1, 2
    sw t3, 24(sp)    # size in bytes

    lw a0, 24(sp)    # a0 = size in bytes

    jal malloc

    beq a0, x0, malloc_error

    # set up file, buffer and bytes to read
    mv s2, a0        # matrix
    mv a0, s0
    mv a1, s2
    lw a2, 24(sp)

    jal fread

    lw t3, 24(sp)
    bne a0, t3, fread_error

    mv a0, s0

    jal fclose

    li t0, -1

    beq a0, t0, fclose_error

    mv a0, s2

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 40

    jr ra


    
malloc_error:
    li a0, 26
    j error_exit

fopen_error:
    li a0, 27
    j error_exit

fread_error:
    li a0, 29
    j error_exit

fclose_error:
    li a0, 28
    j error_exit

error_exit:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 40
    j exit

func_two_sort:
    ####
    # a0 : Addr(array)
    ####
    
    lw t0, 0(a0)
    lw t1, 4(a0)
    
    bgeu t1, t0, endSwap

swap:
    sw t1, 0(a0)
    sw t0, 4(a0)

endSwap:
    ret
    
func_mul:
    ####
    # a0 : Multiplicand / return value
    # a1 : Multiplier
    # s0 : result
    ####
    
    # Calle saved
    addi sp, sp, -4
    sw s0, 0(sp)
    
    # Set result = 0
    li s0, 0
    
    # t0 = abs(Multiplicand)
    srai t3, a0, 31
    xor t0, a0, t3
    sub t0, t0, t3
    
    # t1 = abs(Multplier)
    srai t4, a1, 31
    xor t1, a1, t4
    sub t1, t1, t4
    
    # t2 = (is_result_positive) ? 0 : -1
    xor t2, t3, t4
    
    ## sort t0, t1
    # Caller saved
    addi sp, sp, -16
    sw ra, 12(sp)
    sw t2, 8(sp)
    sw t1, 4(sp)
    sw t0, 0(sp)
    
    # Pass the parameters
    addi a0, sp, 0
    
    # Jump to func_two_sort
    jal ra, func_two_sort
    ###
    
    # t0 < t1
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    
    # Consecutive addition to implement multiplication
    li t3, 0
    bgeu t3, t0, endMulLoop
    
mulLoop:
    add s0, s0, t1
    addi t3, t3, 1
    bltu t3, t0, mulLoop
    
endMulLoop:
    # s0 is abs(Multiplicand * Multiplier) now
    # According t2 to keep s0 positive or turn s0 to negative
    xor s0, s0, t2
    sub s0, s0, t2
    
    # Store return value in a0
    mv a0, s0
    
    # Retrieve ra & Calle saved
    lw ra, 12(sp)
    lw s0, 16(sp)
    addi sp, sp, 20
    
    ret
