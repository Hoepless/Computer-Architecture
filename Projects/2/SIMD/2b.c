
#include "stdio.h"
#include "stdint.h"

void c_rnd_gen(long *arr, double *a, double *c, double *m)
{
    __asm__ __volatile__(
        "fldl (%0)\n"
        "mov $0, %%rbx\n"
        // "fstpl (%%rdi, %%rbx, 8)\n"
        "fldl (%3)\n"

    ".rnd.loop:\n"
        "cmp $32, %%rbx\n"
        "jge .rnd.loop.end\n"

        "fildl (%%rdi, %%rbx, 8)\n"
        "fldl (%1)\n"
        "fmulp\n"
        "fldl (%2)\n"
        "faddp\n"
        "fprem\n"
        "fistpl 8(%%rdi, %%rbx, 8)\n"

        "inc %%rbx\n"
        "jmp .rnd.loop\n"
    ".rnd.loop.end:\n"
        :
        : "D"(arr), "S"(a), "d"(c), "c"(m)
        : "%rbx"
    );
}

void c_fun(long* arr, double* res, double* A, double* B) {
    __asm__ __volatile__(
        "mov $0, %%rdx\n"

    ".fun.loop:\n"
        "cmp $32, %%rdx\n"
        "jge .fun.loop.end\n"

        // "movsd (%%rdi, %%rdx, 8), %%xmm0\n"
        // SI - scalar int??? Long???
        "cvtsi2sd (%%rdi, %%rdx, 8), %%xmm0\n"
        "movsd (%2), %%xmm1\n"
        "movsd (%3), %%xmm2\n"
        "vfmadd132sd %%xmm1, %%xmm2, %%xmm0\n"
        "movsd %%xmm0, (%%rsi, %%rdx, 8)\n"

        "inc %%rdx\n"
        "jmp .fun.loop\n"

    ".fun.loop.end:\n"

        :
        : "D"(arr), "S"(res), "a"(A), "b"(B)
        : "%xmm0", "%xmm1", "%xmm2", "%rdx");
}

int main(int argc, char **argv)
{
    long arr[32];
    double res[32];
    int i = 0;      while(i < 32) { arr[i++] = i; }
    
    double x, a, c, m;
    double A, B;
    printf("Enter x, a, c, m: ");
    // scanf("%d%d%d%d", &x, &a, &c, &m);
    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);
    printf("Enter A, B: ");
    scanf("%lf%lf", &A, &B);

    arr[0] = x;
    c_rnd_gen(arr, &a, &c, &m);
    printf("BEFORE\n");
    i = 0;      while (i < 32) { printf("%ld, ", arr[i++]); }

    c_fun(arr, res, &A, &B);

    printf("\n\nAFTER\n");

    i = 0;      while (i < 32) { printf("%.2lf, ", res[i++]); }
}