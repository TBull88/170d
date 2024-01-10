# assembel with as fib.s -o fib.o
#link with ld -pie -z noexecstack -e _start -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o fib fib.o -lc

.intel_syntax noprefix
.section .text
.global _start

_start:
    # Set variables to start fibonacci sequence
    xor r13, r13    # move 0 into r13 register; r13 = 0 r14 = 0
    mov r14, 1      # move 1 into r14 register; r13 = 0 r14 = 1
    xor r12, r12    # move 0 into r12 register to use as counter

FIB_LOOP:
    xchg r13, r14   # r13 = 1 r14 = 0
    add r13, r14    # r13 = 1 r14 = 0

    # Compare to ensure zero is printed as result of term 0
    cmp r12, 0
    je PRINT_FIRST

    jmp PRINT_TERM

LOOP_RET:
    inc r12     # increment r12 register by 1
    cmp r12, 92     # Hard code number of iterations
    
    # If r12 = 4, exit 
    je EXIT

    # Else, loop again
    jmp FIB_LOOP

PRINT_FIRST:
    # printf("Term %d = %d\n", r12, r14)
    lea rdi, [rip + term]
    mov rsi, r12
    mov rdx, r14
    xor rax, rax
    call printf
    jmp LOOP_RET

PRINT_TERM:
    # printf("Term %d = %d\n", r12, r13)
    lea rdi, [rip + term]
    mov rsi, r12
    mov rdx, r13
    xor rax, rax
    call printf
    jmp LOOP_RET

EXIT: 
    mov rax, 60
    xor rdi, rdi
    syscall

.section .rodata
    term: .asciz "Term %ld = %ld\n"
    .set term_len, . - term