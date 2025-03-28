# extern int fibo_asm(int term)

.section .text
.global fibo_asm

fibo_asm:
    # TODO: You have to implement fibonacci with assembly language
    # HINT: You might need to use "jal(jump and link)" to finish the task
    addi sp, sp, -12  ###(callee) function called will keep the val the same
    sw ra, 4(sp)  ###(caller) store the return address for ra might change
    sw a0, 0(sp)  
    sw s0, 8(sp) ###(callee) if needed tp use, have to store it first and restore at the end of func

    addi t1, zero, 1
    beq t1, a0, fib_one
    beq zero, a0, fib_zero

    addi a0, a0, -1
    jal ra, fibo_asm
    add s0, a0, zero ## s0 = fib(n-1)

    lw a0, 0(sp)
    addi a0, a0, -2
    jal ra, fibo_asm

    add a0, a0, s0

    lw ra, 4(sp)
    lw s0, 8(sp)  ## restore s0
    addi sp, sp, 12
    ret

    fib_one:
        addi a0, zero, 1
        lw ra, 4(sp)
        addi sp, sp, 12
        ret

    fib_zero:
        
        addi a0, zero, 0
        lw ra, 4(sp)
        addi sp, sp, 12
        ret
