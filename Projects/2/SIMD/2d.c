
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

void c_fun(long *arr, double *res, double A)
{
    __asm__ __volatile__(
        "cvtsi2sd (%%rdi), %%xmm0\n"
        "cvtsi2sd 8(%%rdi), %%xmm1\n"
        "cvtsi2sd 16(%%rdi), %%xmm2\n"

        "addsd %%xmm0, %%xmm1\n"
        "addsd %%xmm1, %%xmm2\n"

        "movsd (%2), %%xmm1\n"
        "divsd %%xmm1, %%xmm2\n"

        "movsd %%xmm2, (%%rbx)\n"

        :
        : "D"(arr), "b"(res), "S"(&A)
        : "%rax", "%xmm0", "%xmm1", "%xmm2");
}

int main(int argc, char **argv)
{
    long arr[32];
    double res[32];
    int i = 0;      while(i < 32) { arr[i++] = i; }
    
    double x, a, c, m;
    // double A, B;
    printf("Enter x, a, c, m: ");

    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);

    arr[0] = x;
    c_rnd_gen(arr, &a, &c, &m);
    printf("BEFORE\n");
    i = 0;      while (i < 32) { printf("%ld, ", arr[i++]); }

    i = 0;
    while (i < 30)
    {
        c_fun(&arr[i], &res[i], 3);
        i++;
    }

    printf("\n\nAFTER\n");

    i = 0;      while (i < 32) { printf("%.4lf, ", res[i++]); }
}