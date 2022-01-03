
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

void c_fun(long *arr, double *res, double A, double B, double C)
{
    __asm__ __volatile__(
        "xor %%rax, %%rax\n"
        "cvtsi2sd (%%rdi, %%rax, 8), %%xmm0\n"
        "inc %%rax\n"
        "cvtsi2sd (%%rdi, %%rax, 8), %%xmm1\n"
        "inc %%rax\n"
        "cvtsi2sd (%%rdi, %%rax, 8), %%xmm2\n"
        "movsd (%2), %%xmm3\n"
        "movsd (%3), %%xmm4\n"
        "movsd (%4), %%xmm5\n"

        "mulsd %%xmm0, %%xmm3\n"
        "mulsd %%xmm1, %%xmm4\n"
        "mulsd %%xmm2, %%xmm5\n"

        "addsd %%xmm3, %%xmm4\n"
        "addsd %%xmm4, %%xmm5\n"

        "xor %%rax, %%rax\n"
        "movsd %%xmm5, (%%rbx, %%rax, 8)\n\t"
        :
        : "D"(arr), "b"(res), "S"(&A), "c"(&B), "d"(&C)
        : "%rax", "%xmm0", "%xmm1", "%xmm2", "%xmm3", "%xmm4", "%xmm5");
}

int main(int argc, char **argv)
{
    long arr[32];
    double res[32];
    int i = 0;      while(i < 32) { arr[i++] = i; }
    
    double x, a, c, m;
    double A, B;
    printf("Enter x, a, c, m: ");

    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);

    arr[0] = x;
    c_rnd_gen(arr, &a, &c, &m);
    printf("BEFORE\n");
    i = 0;      while (i < 32) { printf("%ld, ", arr[i++]); }

    i = 0;
    while(i < 30) {
        c_fun(&arr[i], &res[i], 0.393, 0.769, 0.189);
        c_fun(&arr[i + 1], &res[i + 1], 0.349, 0.686, 0.168);
        c_fun(&arr[i + 2], &res[i + 2], 0.272, 0.534, 0.131);
        i++;
    }

    printf("\n\nAFTER\n");

    i = 0;      while (i < 32) { printf("%.4lf, ", res[i++]); }
}