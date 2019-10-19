.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
    la a0, file_path
    addi a1, x0, 3
    addi a2, x0, 3

    jal ra, read_matrix

    # Print out elements of matrix
    addi a1, x0, 3
    addi a2, x0, 3
    jal ra, print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall
