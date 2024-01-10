# assembel with as fib.s -o fib.o
#link with ld -pie -z noexecstack -e _start -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o fib fib.o -lc

.intel_syntax noprefix
.section .text
.global _start

_start:
    # Set up argc and argv
    mov rbx, QWORD PTR[rsp]     # argc
    lea r15, [rsp + 16]    # save rsp
    # add r15, 16      # align to char * argv[]

    cmp rbx, 2
    jl print_usage

    mov rdi, [r15]
    xor rsi, rsi
    mov edx, 10
    call strtol@plt

    mov rbx, rax    # save return value of strtol

    # Set variables to start fibonacci sequence
    mov r13, 0    # move 0 into r13 register; r13 = 0 r14 = 0
    mov r14, 1      # move 1 into r14 register; r13 = 0 r14 = 1
    xor r12, r12    # move 0 into r12 register to use as counter

fib_loop:
    xadd r13, r14
    jmp print_term

print_term:
    # printf("Term %d = %d\n", r12, r13)
    lea rdi, [rip + term]
    mov rsi, r12
    mov rdx, r14
    xor rax, rax
    call printf


    cmp r12, rbx
    je exit
    inc r12
    jmp fib_loop

print_usage:
    # printf("fib usage: ./fib2.0 <arg>")
    lea rdi, [rip + usage]
    xor rax, rax
    call printf

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

.section .rodata
    term: .asciz "Term %ld = %ld\n"
    .set term_len, . - term
    usage: .asciz "Missing required arg:\n\tfib usage: ./fib2 <Nth term>\n"
