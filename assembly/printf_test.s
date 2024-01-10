.intel_syntax noprefix
.section .text
.global _start
.set INT_1,     00
.set INT_2,     01
.set INT_3,     02

_start:
print_1:
    // printf("This is the first string.\n");
    lea     rdi, [rip + STRING1]
    xor     rax, rax
    call    printf

print_2:
    // printf("This is string number %d!\n", INT_3)
    lea     rdi, [rip + STRING2]
    mov     rax, 0x1
    mov     rsi, INT_3
    call    printf

print_3:
    // printf("This is the last string: %d %d %d (%p)\n", INT_1, INT_2, INT_3, &STRING3)
    lea     rdi, [rip + STRING3]
    mov     rax, 0x4
    mov     rsi, INT_1
    mov     rdx, INT_2
    mov     rcx, INT_3
    lea     r8, [rip + STRING3]
    call    printf

exit:
    // exit(0);
    mov     eax, 60
    xor     rdi, rdi
    syscall

.section .rodata
    STRING1: .asciz "This is the first string.\n"
    .set STR1_LEN, . - STRING1

    STRING2: .asciz "This is string number %d!\n"
    .set STR2_LEN, . - STRING2

    STRING3: .asciz "This is the last string: %d %d %d (%p)\n"
    .set STR1_LEN, . - STRING3
    