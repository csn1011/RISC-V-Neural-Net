.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    # Prologue
add t2, x0, x0

loop_start:
lw, t0, 0(a0)
addi t4, x0, 4
mul t4, t4, a3
add a0, a0, t4
lw t1, 0(a1)
addi t4, x0, 4
mul t4, t4, a4
add a1, a1, t4
mul t3, t0, t1
add t2, t3, t2
addi a2, a2, -1

loop_end:
bne a2, x0, loop_start
add a0, t2, x0

    # Epilogue

    
    ret
