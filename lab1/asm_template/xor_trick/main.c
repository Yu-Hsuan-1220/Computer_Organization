#include <stdio.h>
extern int asm_entry(int *arr, int size);

int xor_trick(int *arr, int size){
    int ret = 0;
    for(int i=0; i<size; ++i)
        ret ^= arr[i];
    return ret;
}

int main(){
    int arr[] = {1, 2, 3, 3, 4, 6, 1, 4, 7, 8, 2, 8, 7};
    int n = sizeof(arr)/sizeof(int);
    int asm_ret = asm_entry(arr, n);
    int gt_ret = xor_trick(arr, n);

    printf("result: %d, gt: %d", asm_ret, gt_ret);
    printf("\n");
    return 0;
}