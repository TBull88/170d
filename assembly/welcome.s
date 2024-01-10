# Example using scanf/printf
# Written by Kenton Groombridge
# gas version and pie compliant
# assemble with: as welcome.s -o welcome.o
# link with:
# ld -pie -z noexecstack -e _start -dynamic-linker \
		/lib64/ld-linux-x86-64.so.2 -o welcome welcome.o -lc

.intel_syntax noprefix                  	# use intel syntax
.section .note.GNU-stack,"",@progbits   	# directive for non-executeable stack
.global _start                        	# _start will be our entry point

.section .text

_start:
    # When calling functions, align rsp on 16 byte boundaries for x86_64

    and rsp, 0xfffffffffffffff0		# align rsp on 16 bytes
    mov rbp, rsp    # create new stack frame

    lea rdi, yourname[rip]
    mov al, 0 # number of arguments in SSE
    call printf@plt

    lea rdi, scanstring[rip]
    lea rsi, buf[rip]
    mov al, 0 # number of arguments in SSE
    call scanf@plt

    lea rdi, welcome[rip]
    lea rsi, buf[rip]
    mov al, 0 # number of arguments in SSE
    call printf@plt

    mov rsp, rbp    # undo the current stack frame
    pop rbp         # could also do a "leave"
    
    mov rax, 60       # exit syscall
    mov rdi, 0        # 0 in a Linux shell means all worked well
    syscall           # perform exit syscall

.section .bss		# bss is unitialized
.lcomm buf, 4096		# reserve 4096 bytes in the bss section

.section .rodata		# rodata can’t be modified
yourname: .asciz "Your name: "
welcome: .asciz "Welcome %s!\n"
scanstring: .asciz "%s"
