# Assignment 2: Classify

## Part A: Mathematical Functions
### Task1: ReLU

``` assembly = 
loop_start:
    beqz a1, done    #a1 : loop count   
    lw t2, 0(a0)
    bge t2, t1, loop_end     # if element > 0
    sw t1, 0(a0)        #if element < 0, store 0 to array
loop_end:
    addi a0, a0, 4  # next element
    addi a1, a1, -1 # loop coont -1
    j loop_start
done:
    jr ra
```
To ensure that all negative values in the array are set to zero, effectively applying the ReLU activation function.

1. **Validation Check**:
   - The function first checks if the number of elements (`a1`) is at least 1.
   - If the array is empty (`a1 < 1`), it jumps to an error handler that terminates the program with code 36.

2. **Processing Loop**:
   - The function enters a loop that iterates over each element of the array.
   - For each element:
     - It loads the current element from memory (`lw t2, 0(a0)`).
     - It compares the element to zero (`bge t2, t1, loop_end`).
     - If the element is negative (`t2 < 0`), it replaces the element with zero (`sw t1, 0(a0)`).
     - If the element is non-negative, it leaves it unchanged.
   - After processing an element, it moves to the next element by incrementing the pointer (`addi a0, a0, 4`) and decrementing the loop counter (`addi a1, a1, -1`).

3. **Completion**:
   - Once all elements have been processed (`a1` reaches zero), the function exits and returns control to the caller (`jr ra`).

### Task2: ArgMax
``` assembly = 
loop_start:
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
```
To scans an integer array to find the index of the first occurrence of the maximum value.

1. **Validation Check**:
   - The function first verifies that the array contains at least one element. If the array is empty (i.e., the number of elements is less than one), it triggers an error handler that terminates the program with an exit code of 36.

2. **Initialization**:
   - It loads the first element of the array and initializes two registers: one to keep track of the current maximum value and another to store the index of this maximum value. The index counter starts at zero.

3. **Processing Loop**:
   - The function enters a loop that iterates through each element of the array. For each element, it performs the following steps:
     - Decrements the loop counter to keep track of the remaining elements.
     - Loads the next element from the array and compares it with the current maximum value.
     - If the new element is greater than the current maximum, it updates the maximum value and records the current index.
     - If the new element is equal to the current maximum, it does not update the index, ensuring that the first occurrence is retained.
     - Moves the pointer to the next element and increments the index counter to continue the iteration.

4. **Completion**:
   - After processing all elements, the function moves the index of the first maximum value into the return register and exits, returning control to the caller.

5. **Error Handling**:
   - If the initial validation fails (i.e., the array is empty), the function sets the exit code to 36 and terminates the program.

### Task3.1: Dot Product
To calculate the strided dot product of two integer arrays. 

1. **Purpose**:
   - **Dot Product Calculation**: Computes the sum of the products of corresponding elements from two arrays, considering specified strides (skip distances). Specifically, it calculates the sum of `arr0[i * stride0] * arr1[i * stride1]` for each element `i` from `0` to `(element_count - 1)`.

2. **Arguments**:
   - **First Array Pointer (`a0`)**: Points to the first input integer array.
   - **Second Array Pointer (`a1`)**: Points to the second input integer array.
   - **Element Count (`a2`)**: Specifies the number of elements to process.
   - **Stride for First Array (`a3`)**: Defines the skip distance between elements in the first array.
   - **Stride for Second Array (`a4`)**: Defines the skip distance between elements in the second array.

3. **Validation Checks**:
   - **Element Count**: Ensures that the number of elements to process is at least one. If not, the program terminates with an exit code `36`.
   - **Strides**: Verifies that both stride values are positive (i.e., greater than or equal to one). If either stride is invalid, the program terminates with an exit code `37`.

4. **Processing Loop**:
   - **Initialization**: Sets up registers to accumulate the dot product result and to track the current index.
   - **Iteration**: For each element up to the specified count:
     - **Element Access**: Accesses the current elements from both arrays using the provided strides.
     - **Multiplication and Accumulation**: Multiplies the corresponding elements and adds the product to the running total.
     - **Pointer Advancement**: Moves the pointers of both arrays forward based on their respective strides to access the next set of elements.
     - **Index Tracking**: Increments the loop counter to proceed to the next element.

5. **Completion**:
   - **Result Storage**: After processing all elements, the accumulated dot product sum is moved into the return register (`a0`).
   - **Return Control**: The function exits, returning control to the caller with the result.

6. **Error Handling**:
   - **Invalid Element Count**: If the number of elements is less than one, the function sets the exit code to `36` and terminates.
   - **Invalid Strides**: If any of the stride values are less than one, the function sets the exit code to `37` and terminates.

``` assembly = 
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
```
### Task3.2: Matrix Multiplication
To perform matrix multiplication between two integer matrices, **Matrix A** and **Matrix B**, and stores the result in a **Result Matrix**. Here's a concise overview of its functionality:

1. **Validation Checks**:
   - **Element Counts**: Ensures that the number of rows in Matrix A (`a1`) and the number of columns in Matrix B (`a2`) are at least one.
   - **Stride Values**: Verifies that the stride values for both matrices (`a4` and `a5`) are positive.
   - **Dimension Compatibility**: Confirms that the number of columns in Matrix A matches the number of rows in Matrix B (`a2` equals `a4`), which is a prerequisite for matrix multiplication.
   - **Error Handling**: If any of these validations fail, the function terminates the program with appropriate exit codes.

2. **Prologue**:
   - **Stack Management**: Allocates space on the stack to save the return address and callee-saved registers (`s0` to `s5`), ensuring that the function can safely modify these registers without affecting the caller.
   - **Initialization**: Sets up loop counters and pointers:
     - `s0`: Outer loop counter for iterating through the rows of Matrix A.
     - `s1`: Inner loop counter for iterating through the columns of Matrix B.
     - `s2`: Pointer to the current position in the Result Matrix where the computed value will be stored.
     - `s3` and `s4`: Pointers to the current rows in Matrix A and Matrix B, respectively.

3. **Outer Loop (Iterating Through Rows of Matrix A)**:
   - For each row in Matrix A (`s0`), the function initializes the inner loop to iterate through each column of Matrix B.
   - It updates the pointer to Matrix A to point to the next row after completing each outer loop iteration.

4. **Inner Loop (Iterating Through Columns of Matrix B)**:
   - For each column in Matrix B (`s1`), the function performs the following:
     - **Saving State**: Stores the current state of arguments on the stack to preserve them across the function call.
     - **Preparing Arguments for Dot Product**:
       - Sets the pointers to the current row of Matrix A and the current column of Matrix B.
       - Specifies the number of elements to process (i.e., the number of columns in Matrix A or rows in Matrix B).
       - Sets the stride values for both arrays.
     - **Calling the `dot` Function**: Computes the dot product of the current row of Matrix A and the current column of Matrix B.
     - **Storing the Result**: Saves the computed dot product into the Result Matrix at the appropriate position.
     - **Updating Pointers and Counters**: Moves the pointers to the next elements in Matrix B and increments the inner loop counter.

5. **Updating Matrix A Pointer**:
   - After completing the inner loop for a row, the function calculates the pointer to the next row in Matrix A by multiplying the current row index with the number of columns and adjusting for byte addressing.

6. **Epilogue**:
   - **Restoring State**: Retrieves the saved return address and callee-saved registers from the stack.
   - **Stack Cleanup**: Reclaims the stack space allocated during the prologue.
   - **Return Control**: Exits the function, returning control to the caller with the Result Matrix populated with the multiplication results.

7. **Error Handling**:
   - If any validation fails at the beginning, the function sets an appropriate exit code and terminates the program to prevent undefined behavior.
``` assembly = 
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

```
## Part B: File Operation and Main

### Task1: Read Matrix

```assembly = 
li s1,0
read_loop_start:
    beqz t1 read_loop_end
    add s1, s1 ,t2
    addi t1, t1, -1
    j read_loop_start
    
read_loop_end:
    slli t3, s1, 2
```
### Task2: Write Matrix
```    assembly = 
li s4, 0
mul_loop:
    beqz s2, loop_end
    add s4, s4, s3
    addi s2, s2, -1
    j mul_loop
```
