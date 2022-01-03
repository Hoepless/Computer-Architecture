
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


void c_fun(long *arr, double B, double C, double *res)
{
    __asm__ __volatile__(
        "mov $255, %%rax\n"
        "cvtsi2sd %%rax, %%xmm0\n"
        "movsd (%1), %%xmm1\n"
        "mov $2, %%rax\n"
        "cvtsi2sd %%rax, %%xmm2\n"

        "divsd %%xmm1, %%xmm0\n"
        "divsd %%xmm2, %%xmm0\n"
        
// divsd src, dst = dst / src and result is in dst
// mulsd src, dst = dst * src and result is in dst
// subsd src, dst = dst - src and result is in dst
        "movsd (%2), %%xmm1\n"
        "mulsd %%xmm1, %%xmm0\n"

        "cvtsi2sd (%%rdi), %%xmm1\n"
        "mulsd %%xmm1, %%xmm0\n"

        "cvtsi2sd -8(%%rdi), %%xmm1\n"
        "subsd %%xmm1, %%xmm0\n"

        "movsd %%xmm0, (%%rbx)\n"

        :
        : "D"(arr), "S"(&B), "d"(&C), "b"(res)
        : "%rax", "%rcx", "%xmm0", "%xmm1");
}

int main(int argc, char **argv)
{
    long arr[32];
    double res[32];
    int i = 0;      while(i < 32) { arr[i++] = i; }
    
    double x, a, c, m;
    double A = 2, B = 3;
    printf("Enter x, a, c, m: ");

    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);

    printf("Enter b, c: ");
    scanf("%lf%lf", &A, &B);
    arr[0] = 0;
    arr[1] = x;
    c_rnd_gen(&arr[1], &a, &c, &m);
    printf("BEFORE\n");
    i = 0;      while (i < 32) { printf("%ld, ", arr[i++]); }

    i = 1;
    while(i < 33) {
        c_fun(&arr[i], A, B, &res[i]);
        i++;
    }
    
    printf("\n\nAFTER\n");
    
    i = 1;      while (i < 33) { printf("%.4lf, ", res[i++]); }
}