.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
addi sp, sp, -16 #save a0, a1, a2, a3
sw a0, 0(sp)
sw a1, 4(sp)
sw a2, 8(sp)
sw a3, 12(sp)

addi, a0, x0, 8    #set up call to malloc 2 4 byte numbers

addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

lw a2, 8(sp)
lw a3, 12(sp)

addi sp, sp, -4
sw a0 0(sp)

sw a2, 0(a0)
sw a3, 4(a0)

lw a0, 4(sp)
lw a1, 8(sp)

add a1, a0, x0 #set a1 to filename
addi a2, x0, 1 #set permission to write

addi sp, sp, -4 #save ra call fopen
sw ra,0(sp)
jal fopen
lw ra,0(sp)
addi sp, sp, 4

addi, t4, x0, -1
beq a0, t4, eof_or_error    #make sure file opened

addi sp, sp, -4   #save fopen output
sw a0, 0(sp)

lw a1 0(sp) #load fopen output to a1
lw a2 4(sp) #load malloced buffer to a2
addi a3, x0, 2 #set number of elems to 2
addi a4, x0, 4 #set bytes to 4

addi sp, sp, -4 #save ra call fopen
sw ra,0(sp)
jal fwrite
lw ra,0(sp)
addi sp, sp, 4

#on to actual matrix





lw t0, 16(sp)
lw t1, 20(sp)
mul t0, t1, t0 #set t0 to rows*columns
addi t0, t0, 2 #set t0 to rows*columns+2

lw a1 0(sp) #load fopen output to a1
lw a2 12(sp) #load write buffer to a2
add a3, x0, t0 #set number of elems to t0
addi a4, x0, 4 #set bytes to 4

addi sp, sp, -4 #save ra call fopen
sw ra,0(sp)
jal fwrite
lw ra,0(sp)
addi sp, sp, 4

lw t0, 16(sp)
lw t1, 20(sp)
mul t0, t1, t0 #set t0 to rows*columns
addi t0, t0, 2 #set t0 to rows*columns+2

bne a0, t0, eof_or_error    #make sure correct number written

lw a1 0(sp) #load fopen output to a1
addi sp, sp, -4 #save ra call fclose
sw ra,0(sp)
jal fclose
lw ra,0(sp)
addi sp, sp, 4

addi, t4, x0, -1
beq a0, t4, eof_or_error    #make sure file closed


addi sp, sp, 24

    # Epilogue


    ret

eof_or_error:
    li a1 1
    jal exit2
    
