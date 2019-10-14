.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
add t0, x0, x0
lw t1, 0(a0)
addi a0, a0, 4
addi a1, a1, -1
add t3, x0, x0

loop_start:
lw t2, 0(a0)
blt t1, t2, loop_continue
addi a0, a0, 4
addi a1, a1, -1
addi t3, t3, 1
j loop_end




loop_continue:
add t1, x0, t2
addi t3, t3, 1
add t0, x0, t3
addi a0, a0, 4
addi a1, a1, -1
loop_end:
bne a1, x0, loop_start
add a0, t0, x0
    # Epilogue


    ret
