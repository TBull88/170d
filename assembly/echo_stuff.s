# assemble with as echo_stuff.s -o echo_stuff.o
# link with ld -pie -z noexecstack -e _start -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o echo_stuff echo_stuff.o -lc

.intel_syntax noprefix
.section .text
.global _start

_start:
    # Wite prompt to STDOUT
    mov rax, 0x1    # write() syscall
    mov rdi, rax    # move 1 from rax into rdi for stdout
    lea rsi, [rip + message]    # load addr of message to rsi reg
    mov rdx, OFFSET msg_len
    syscall

    # Save whatever is written to buffer (STDIN)
    xor rax, rax    # read() syscall
    mov rdi, rax    # move 0 from rax into rdi for stdin
    lea rsi, [rip + buff]   # load addr of buff to rsi
    mov rdx, 4096
    syscall

    # Write buffer to STDOUT
    mov rax, 0x1
    mov rdi, rax
    lea rsi, [rip + buff]
    mov rdx, 4096
    syscall

    # Exit program
    mov rax, 60
    xor rdi, rdi    # Set return code to 0
    syscall

.section .bss   #bss is uninitialized
.lcomm buff, 4096   # reserve 4096 bytes in the bss section

.section .rodata
message: .ascii "Enter something => "
.set msg_len, . - message
