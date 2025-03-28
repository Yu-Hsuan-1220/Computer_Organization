#include <stdio.h>

#define term 5

extern int fibo_asm(int e);

int fibo_c(int e){
    // this is the fibonacci code written in c
    // fibonacci sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
    
    if(e==0){
        return 0;
    }
    else if(e==1){
        return 1;
    }
    else{
        return fibo_c(e-1) + fibo_c(e-2);
    }
}

int main(void)
{
    int e = term;
    
    int fibo_c_res = fibo_c(e);

    int fibo_asm_res = fibo_asm(e);
    
    printf("Result of c code: %d, Result of assembly code: %d\n", fibo_c_res, fibo_asm_res);

    return 0;
}