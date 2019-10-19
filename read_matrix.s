.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
addi sp, sp, -8     #save a1,a2
sw a1, 0(sp)
sw a2 4(sp)

add a1, x0, a0   #setup call for fopen
add a2, x0, x0

addi sp, sp, -4
sw ra,0(sp)
jal fopen
lw ra,0(sp)
addi sp, sp, 4

addi, t4, x0, -1
beq a0, t4, eof_or_error    #make sure file opened

addi sp, sp, -4   #save fopen output
sw a0, 0(sp)

addi, a0, x0, 8    #set up call to malloc 2 4 byte numbers

addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

add a2, a0, x0  #set a2 to the pointer to malloced output array
lw a1, 0(sp)    #load fopen output to a1
addi a3, x0, 8  #a3 means read 8 bytes

addi sp, sp, -4
sw ra,0(sp)
jal fread
lw ra,0(sp)
addi sp, sp, 4

addi, t4, x0, -1
beq a0, t4, eof_or_error

lw t0 0(a2)
lw t1 4(a2) #set t0/t1 to row column vals

lw t2 4(sp)
lw t3 8(sp) #get a1/a2 from stack

sw t0, 0(t2)
sw t1, 0(t3) #store row/col in the a1/a2 array

mul t0, t0, t1 #multiply t0 and t1
addi sp, sp, -4 #save rowxcolumn
sw t0, 0(sp)
addi t4, x0, 4
mul t0, t0, t4
add, a0, x0, t0 #save number of bytes into a0 for malloc

addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4 #save pointer to malloc
sw a0, 0(sp)

add a2, a0, x0  #set a2 to the pointer to malloced output array
lw a1, 8(sp)    #load fopen output to a1

lw a3, 4(sp)    #set a3 to rowxcolumns bytes
addi t4, x0, 4
mul a3, a3, t4

addi sp, sp, -4
sw ra,0(sp)
jal fread
lw ra,0(sp)
addi sp, sp, 4

bne a0, a3 eof_or_error #check number of bytes read = rowxcolumn

lw a0, 0(sp)

addi sp, sp, 12

lw a1, 0(sp)
lw a2 4(sp)

addi sp, sp, 8

addi t4, x0, 4
mul t0, t0, t4

    # Epilogue


    ret

eof_or_error:
    li a1 1
    jal exit2
    
