.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
bne a2, a4, mismatched_dimensions

start:    # Prologue
addi sp, sp, -52
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)
sw s3, 16(sp)
sw s4,20(sp)
sw s5, 24(sp)
sw s6, 28(sp)
sw s7, 32(sp)
sw s8, 36(sp)
sw s9, 40(sp)
sw s10, 44(sp)
sw s11, 48(sp)

add s9, x0, x0 #outer counter
add s11, x0, x0 #innter counter
add s10, a6, x0 #hold a6
add s0, ra, x0
add s1, a0, x0
add s2, a1, x0
add s3, a2, x0
add s4, a3, x0
add s5, a4, x0
add s6, a5, x0
add s7, a5, x0
add s8, a6, x0

outer_loop_start:

addi t0, x0, 4
mul t0, s9, t0
mul t0, s3, t0
add a0, s1, t0
addi a3, x0, 1
add a2, s3, x0

inner_loop_start:

add a4, s6, x0
remu a1, s11, s6
addi t0, x0, 4
mul a1, t0, a1
add a1, a1, s4
jal ra dot
addi s11, s11, 1
sw a0, 0(s8)
addi s8, s8, 4

addi t0, x0, 4
mul t0, s9, t0
mul t0, s3, t0
add a0, s1, t0
addi a3, x0, 1
add a2, s3, x0

bne s11, s6, inner_loop_start

inner_loop_end:

add s11, x0, x0
addi s9, s9, 1

outer_loop_end:

bne s9, s2, outer_loop_start


    # Epilogue
 add a0, x0, s10
lw ra, 0(sp)
lw s0, 4(sp)
lw s1, 8(sp)
lw s2, 12(sp)
lw s3, 16(sp)
lw s4,20(sp)
lw s5, 24(sp)
lw s6, 28(sp)
lw s7, 32(sp)
lw s8, 36(sp)
lw s9, 40(sp)
lw s10, 44(sp)
lw s11, 48(sp)
addi sp, sp, 52
ret


mismatched_dimensions:
    li a1 2
    jal exit2
