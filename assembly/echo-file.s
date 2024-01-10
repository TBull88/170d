# assemble with as echo_stuff.s -o echo_stuff.o
# link with ld -pie -z noexecstack -e _start -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o echo_stuff echo_stuff.o -lc

.intel_syntax noprefix
.section .text
.global _start

_start:

    #Open file
    mov eax, 2	# open() syscall
	# mov rdi, filename	# put filename addr in rdi (Only works when comiled with -no-pie)
	lea rdi, [rip + filename]	# must use for pie (loads adrress of filename into rdi)
	mov esi, 01101 	# 01 is WR_ONLY, 01000 is O_TRUNC, 0100 is O_CREAT
	mov edx, 0644	#  
	syscall

    # check return of open()
    mov edi, 10
    test rax, rax   # check rax has the fd. Test to see if neg
    js exit

    # save file pointer to callee saved reg
    mov r12d, eax    # file descriptors will fir into 32 bits

    # Wite prompt to myfile.dat
    mov rax, 0x1    # write() syscall
    mov rdi, rax    # move 1 from rax into rdi for stdout
    lea rsi, [rip + message]    # load addr of message to rsi reg
    mov rdx, OFFSET msg_len
    syscall

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
    mov edx, eax
    mov eax, 0x1
    mov edi, eax
    lea rsi, [rip + buff]
    mov rdx, 4096
    syscall

    xor rdi, rdi    # Set return code to 0

# Exit program
exit:
    mov rax, 60
    syscall

.section .bss   #bss is uninitialized
.lcomm buff, 4096   # reserve 4096 bytes in the bss section

.section .rodata
message: .ascii "Enter something => "
.set msg_len, . - message
filename: .asciz "myfile.dat"
