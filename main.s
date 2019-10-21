.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
addi t0, x0, 5
bne t0, a0, wrong_args
lw t0, 16(a1)



	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
addi, sp, sp, -8
sw a0, 0(sp)
sw a1 4(sp) #save a0/a1 in preparation for malloc call

addi a0, x0, 4 #set a0 to 1 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw, a0, 0(sp) #store 1 byte buffer to stack

addi a0, x0, 4 #set a0 to 1 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw, a0, 0(sp) #store 1 byte buffer to stack

#now you have to one byte buffers for m0 ints

lw a1, 0(sp) #load 4 byte buffers into a1/a2 load file path for m0 into a0
lw a2, 4(sp)

lw t0, 12(sp)
lw a0, 4(t0) #load m0/index1

addi sp, sp, -4 #call read matrix
sw ra,0(sp)
jal read_matrix
lw ra,0(sp)
addi sp, sp, 4

addi t0, x0, 1
beq t0, a1, wrong_args

add s0, a0, x0 #save matrix m0 to s0
add s1, a1, x0 #save rows of m0 to s1
add s2, a2, x0 #save columns of m0 to s2

addi sp, sp, 8 #forget 1 byte buffers

lw a0, 0(sp)
lw a1 4(sp) #reset a0/a1
addi, sp, sp, 8 #reset stack pointer

    # Load pretrained m1
addi, sp, sp, -8
sw a0, 0(sp)
sw a1 4(sp) #save a0/a1 in preparation for malloc call

addi a0, x0, 4 #set a0 to 1 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw, a0, 0(sp) #store 1 byte buffer to stack

addi a0, x0, 4 #set a0 to 1 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw, a0, 0(sp) #store 1 byte buffer to stack

#now you have to one byte buffers for m0 ints

lw a1, 0(sp) #load 1 byte buffers into a1/a2 load file path for m1 into a0
lw a2 4(sp)

lw t0 12(sp)
lw a0, 8(t0) #load m1/index2

addi sp, sp, -4 #call read matrix
sw ra,0(sp)
jal read_matrix
lw ra,0(sp)
addi sp, sp, 4

addi t0, x0, 1
beq t0, a1, wrong_args

add s3, a0, x0 #save matrix m1 to s3
add s4, a1, x0 #save rows of m1 to s4
add s5, a2, x0 #save columns of m1 to s5

addi sp, sp, 8 #forget 1 byte buffers

lw a0, 0(sp)
lw a1 4(sp) #reset a0/a1
addi, sp, sp, 8 #reset stack pointer

    # Load input matrix

addi, sp, sp, -8
sw a0, 0(sp)
sw a1 4(sp) #save a0/a1 in preparation for malloc call

addi a0, x0, 4 #set a0 to 1 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw, a0, 0(sp) #store 1 byte buffer to stack

addi a0, x0, 4 #set a0 to 1 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw, a0, 0(sp) #store 1 byte buffer to stack

#now you have to one byte buffers for m0 ints

lw a1, 0(sp) #load 1 byte buffers into a1/a2 load file path for m0 into a0
lw a2 4(sp)

lw t0 12(sp) #load a1 original into t0
lw a0, 12(t0) #load input/index 3 into a0

addi sp, sp, -4 #call read matrix
sw ra,0(sp)
jal read_matrix
lw ra,0(sp)
addi sp, sp, 4

addi t0, x0, 1
beq t0, a1, wrong_args

add s6, a0, x0 #save matrix input to s6
add s7, a1, x0 #save rows of input to s7
add s8, a2, x0 #save columns of input to s8

addi sp, sp, 8 #forget 1 byte buffers

lw a0, 0(sp)
lw a1 4(sp) #reset a0/a1
addi, sp, sp, 8 #reset stack pointer

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

addi, sp, sp, -8
sw a0, 0(sp)
sw a1 4(sp) #save a0/a1 in preparation for malloc call
#1
lw t0, 0(s1) #set t0 to m0 rows
lw t1, 0(s8) #set t1 to input columns
mul t0, t1, t0 #set t0 to rowsxcol
addi t1, x0, 4
mul t0, t0, t1

add a0, x0, t0 #set a0 to t0 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

add a6, a0, x0 #set output to malloced buffer
add a0, s0, x0 #set a0 to m0
lw a1, 0(s1) #set a1 to m0 rows
lw a2, 0(s2) #set a2 to m0 columns

add a3, s6, x0 #set a3 to input
lw a4, 0(s7) #set a4 to input rows
lw a5, 0(s8) #set a5 to input columns

addi sp, sp, -4 #call matmul, a6 is the result
sw ra,0(sp)
jal matmul
lw ra,0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw a0, 0(sp) #store relu'd matrix

#2
lw t0, 0(s1) #set t0 to m0 rows
lw t1, 0(s8) #set t1 to input columns
mul t0, t0, t1 #get dimensions of new matrix
add a1, t0, x0 #set a1 to num of ints
add a0, a6, x0 #set a0 to product of m0*input

addi sp, sp, -4 #call relu
sw ra,0(sp)
jal relu
lw ra,0(sp)
addi sp, sp, 4

#3

lw t0, 0(s4) #sets t0 to m1 rows
lw t1, 0(s8) #set t1 to input columns
mul t0, t0, t1 #sets t0 to rowsxcol
addi, t1, x0, 4
mul t0, t0, t1


add a0, x0, t0 #set a0 to t0 and call malloc
addi sp, sp, -4
sw ra,0(sp)
jal malloc
lw ra,0(sp)
addi sp, sp, 4

add a6, a0, x0 #sets a6 to malloced output
add a0, s3, x0 #set a0 to m1
lw a1, 0(s4) #set a1 to m1 rows
lw a2, 0(s5) #set a2 to m1 columns

lw a3, 0(sp) #set a3 to relu(m0*input)
addi sp, sp, 4 #clear from stack
lw a4, 0(s1) #set a4 to m0 rows
lw a5, 0(s8) #set a5 to input columns

addi sp, sp, -4 #call matmul, a6 is the result
sw ra,0(sp)
jal matmul
lw ra,0(sp)
addi sp, sp, 4

lw a0, 0(sp)
lw a1 4(sp) #reset a0/a1
addi, sp, sp, 8 #reset stack pointer

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

lw a0 16(a1) # Load pointer to output filename
add a1, a6, x0 #set a1 to a6 calculated before
lw a2, 0(s4) #set a4 to m1 rows
lw a3, 0(s8) #set a5 to input columns

addi sp, sp, -4
sw a6, 0(sp)

addi sp, sp, -4 #call write
sw ra,0(sp)
jal write_matrix
lw ra,0(sp)
addi sp, sp, 4

addi t0, x0, 1
beq t0, a1, wrong_args

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

lw a0, 0(sp) #set a0 to a6
addi sp, sp, 4
lw t0, 0(s4) #set a4 to m1 rows
lw t1, 0(s8) #set a5 to input columns
mul t0, t0, t1
add a1, t0, x0 #set a1 to num

addi sp, sp, -4 #call argmax
sw ra,0(sp)
jal argmax
lw ra,0(sp)
addi sp, sp, 4

    # Print classification

mv a1 a0
jal ra print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char
    jal exit

#exit code 3
wrong_args:
li a1 3
jal exit2
