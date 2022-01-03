
#include "stdio.h"

void c_rnd_gen(double *arr, double *a, double *c, double *m)
{
    __asm__ __volatile__(
        "fldl (%0)\n"
        "mov $0, %%rbx\n"
        // "fstpl (%%rdi, %%rbx, 8)\n"
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
        : "D"(arr), "S"(a), "d"(c), "c"(m)
        : "%rbx"
    );
}

void c_fun(double* arr, double* A, double* B) {
    __asm__ __volatile__(
        "mov $0, %%rdx\n"

    ".fun.loop:\n"
        "cmp $32, %%rdx\n"
        "jge .fun.loop.end\n"

        "fldl (%2)\n"
        "fldl (%1)\n"
        "fldl (%%rdi, %%rdx, 8)\n"

        "fmulp\n"
        "faddp\n"

        "fstpl (%%rdi, %%rdx, 8)\n"

        "inc %%rdx\n"
        "jmp .fun.loop\n"

    ".fun.loop.end:\n"
        :
        : "D"(arr), "S"(A), "c"(B)
        :"%rdx"
    );
}

int main(int argc, char **argv)
{
    double arr[32];

    double x, a, c, m;
    double A, B;
    printf("Enter x, a, c, m: ");
    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);
    printf("Enter A, B: ");
    scanf("%lf%lf", &A, &B);

    arr[0] = x;
    c_rnd_gen(arr, &a, &c, &m);
    printf("BEFORE\n");
    int i = 0;      while (i < 32) { printf("%.2lf, ", arr[i++]); }

    c_fun(arr, &A, &B);

    printf("\n\nAFTER\n");

    i = 0;      while (i < 32) { printf("%.2lf, ", arr[i++]); }
}