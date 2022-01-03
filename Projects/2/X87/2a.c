
#include "stdio.h"

void c_rnd_gen(double* arr, double* a, double* c, double* m) {
    __asm__ __volatile__ (
            "rnd_gen:\n"

            "fldl (%0)\n"
            "mov $0, %%rbx\n"
            "fstpl (%%rdi, %%rbx, 8)\n"
            "fldl (%3)\n"
            
        ".rnd.loop:\n"
            "cmp $32, %%rbx\n"
            "jge .rnd.loop.end\n"

            "fldl (%%rdi, %%rbx, 8)\n"
            "fldl (%1)\n"
            "fmulp\n"
            "fldl (%2)\n"
            "faddp\n"
            "fprem\n"
            "fstpl 8(%%rdi, %%rbx, 8)\n"

            "inc %%rbx\n"
            "jmp .rnd.loop\n"
        ".rnd.loop.end:\n"
        :
        :"D"(arr), "S"(a), "d"(c), "c"(m)
        :"%rbx"
    );
}

int main(int argc, char** argv) {
    double arr[32];
    
    double x = 34, a = 42, c = 21, m = 432;
    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);
    
    int i = 0;
    // while (i < 32) { arr[i++] = i; }

    // printf("BEFORE\n");
    // i = 0;      while (i < 32) { printf("%.2lf, ", arr[i++]); }

    arr[0] = 34;
    c_rnd_gen(arr, &a, &c, &m);
    
    // printf("\n\nAFTER\n");
    i = 0;      while(i < 32) { printf("%.2lf, ", arr[i++]); }

}