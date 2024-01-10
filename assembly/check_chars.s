# assemble with as echo_stuff.s -o echo_stuff.o
# link with ld -pie -z noexecstack -e _start -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o echo_stuff echo_stuff.o -lc

.intel_syntax noprefix
.section .text
.global _start

_start:
    # Open file
    mov eax, 2    # open() syscall
    lea rdi, [rip + filename]   # must use for pie (loads addr of filename into rdi)
    mov esi, 0    # 0 is read only
    mov edx, 0644
    syscall

    # Check return of open()
    mov edi, 10    # set arbitrary return code (10) to test if open fails
    test rax, rax   # check rax has the fd. Test to see if neg
    js EXIT 

    # save file pointer to callee saved register
    mov r12d, eax   # fd will fit into 32 bits

READ_FILE:  # Loop to read file one char at a time
    # Read file
    xor rax, rax    # read() syscall
    mov edi, r12d    # copy fd into rdi
    mov rdx, 1      # read 1 char at a time
    lea rsi, [rip + buff]   # load addr of buff to rsi
    syscall

    # Check return of read()
    mov edi, 20    # set arbitrary return code (20) to test if read fails or EOF
    test rax, rax
    jle EXIT

    mov r13d, buff  # Copy contents of buff into r13d reg

    # Compare char to ascii values
    # Num = 0x30 - 0x39
    # Lower Case = 0x61 - 0x7A
    # Upper Case = 0x41 - 0x5A

    # Check if char is digit
    sub r13d, 0x30
    jl INVALID
    sub r13d, 0x38
    jl IS_NUM

    # Check if char is uppercase
    sub r13d, 0x3a
    jl INVALID
    sub r13d, 0x40
    jl IS_UPPER


    # Write buffer to STDOUT
    # write(buffer, size, 0);
    #mov edx, eax
    #mov eax, 0x1
    #mov edi, eax
    #lea rsi, [rip + buff]
    #mov rdx, 1
    #syscall

    #jmp READ_FILE
PRINT_CHAR:
    

INVALID:
    mov rax, 0x1    # write() syscall
    mov rdi, rax    # move 1 from rax into rdi for stdout
    lea rsi, [rip + invalid_message]    # load addr of message to rsi reg
    mov rdx, OFFSET inv_msg_len
    syscall

    jmp READ_FILE

IS_NUM:
    mov rax, 0x1    # write() syscall
    mov rdi, rax    # move 1 from rax into rdi for stdout
    lea rsi, [rip + num_message]    # load addr of message to rsi reg
    mov rdx, OFFSET num_msg_len
    syscall

    jmp READ_FILE

IS_UPPER:
    mov rax, 0x1    # write() syscall
    mov rdi, rax    # move 1 from rax into rdi for stdout
    lea rsi, [rip + upper_message]    # load addr of message to rsi reg
    mov rdx, OFFSET upper_msg_len
    syscall

    jmp READ_FILE

    xor rdi, rdi    # Set return code to 0

# Exit Program
EXIT:
    mov rax, 60
    syscall

.section .bss   # bss is uninitialized
.lcomm buff, 1  # reserve 1 byte in the bss section to read one char at a time

.section .rodata
filename: .asciz "./test_file.dat"
invalid_message: .ascii " is not a valid cahracter\n"
num_message: .ascii " is a valid num\n"
upper_message: .ascii " is a valid UPPER\n"
.set inv_msg_len, . - invalid_message
.set num_msg_len, . - num_message
.set upper_msg_len, . - upper_message
