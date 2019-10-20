.import ../write_matrix.s
.import ../utils.s

.data
m0: .word 2, 1, 6 # MAKE CHANGES HERE
file_path: .asciiz "test_output.bin"

.text
main:
    # Write the matrix to a file
la a0, file_path
la a1, m0
addi, a2, x0, 3
addi, a3, x0, 1
jal ra, write_matrix
    # Exit the program
    addi a0 x0 10
    ecall
