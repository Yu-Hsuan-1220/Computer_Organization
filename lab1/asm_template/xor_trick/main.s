# extern int asm_entry(int *arr, int size);

.section .text
.global asm_entry

asm_entry:
    # TODO: You have to implement the xor_trick function with assembly language
    
    add t0, a0, zero
    addi a0, zero, 0

    addi t1, zero, 0 ## t1 = i

    loop1:
        bge t1, a1, loopend
        lw t2, 0(t0)
        xor a0, a0, t2
        addi t0, t0, 4 
        addi t1, t1, 1
        j loop1
    loopend:
        ret
