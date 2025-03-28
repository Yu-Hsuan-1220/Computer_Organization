# extern void entry(int *arr, int t, int *arr2)

.section .text
.global asm_dp

asm_dp:
    # TODO: You have to implement dynamic programming with assembly code
    # HINT: You might need to use "slli(shift left)" to implement multiplication
    # HINT: You might need to be careful of calculating the memory address you store in your register
    # t1 = i  ,  t2 = j 
    addi t1, zero, 1
    addi t2, zero, 0
    
    loop1:
        blt a1, t1, outloop ## jump out outer loop
        addi t2, zero, 0

        loop2:
            addi s3, zero, 6
            bge t2, s3, loop1end
            slli t3, t2, 3
            add t3, t3, a0     
            lw t4, 0(t3)    ## t4 = arr[2*j]
            
            sub t5, t1, t4   ## t5 = i-arr[2*j]
            blt t5, zero, loop2end

            
            lw t4, 4(t3)    ## t4 = arr[2*j+1]
            slli t5, t5, 2
            add t5, t5, a2
            lw t5, 0(t5)       ## t5 = dp[i-arr[2*j]]
            add t6, t5, t4
            
            slli s1, t1, 2     ## dp[i] pos    
            add s1, a2, s1
            lw s2, 0(s1)
            bge s2, t6, loop2end
            sw t6, 0(s1)

            loop2end:
                addi t2, t2, 1
                j loop2


        loop1end:
            addi t1, t1, 1
            j loop1


    outloop:
        ret
        