.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue


loop_start:
lw t1, 0(a0)
blt t1, x0, loop_continue
addi a0, a0, 4
addi a1, a1, -1
j loop_end





loop_continue:
sw x0, 0(a0)
addi a0, a0, 4
addi a1, a1, -1

loop_end:
bnez a1, loop_start

    # Epilogue

    
	ret
