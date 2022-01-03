
#include "stdio.h"

void c_rnd_gen(double *arr, double *a, double *c, double *m)
{
    __asm__ __volatile__(
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
        : "D"(arr), "S"(a), "d"(c), "c"(m)
        : "%rbx");
}

void c_fun(double *arr, double A, double B, double C)
{
    __asm__ __volatile__(
        "mov $0, %%rax\n"

        "fldl (%%rdi, %%rax, 8)\n"
        "fldl (%1)\n"
        "fmulp\n"

        "inc %%rax\n"
        "fldl (%%rdi, %%rax, 8)\n"
        "fldl (%2)\n"
        "fmulp\n"

        "inc %%rax\n"
        "fldl (%%rdi, %%rax, 8)\n"
        "fldl (%3)\n"
        "fmulp\n"

        "faddp\n"
        "faddp\n"

        "dec %%rax\n"
        "dec %%rax\n"
        "fstpl (%%rdi, %%rax, 8)\n"

        :
        : "D"(arr), "S"(&A), "c"(&B), "d"(&C)
        : "%rax");
}

int main(int argc, char **argv)
{
    double arr[34];

    double x, a, c, m;
    printf("Enter x, a, c, m: ");
    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);

    arr[0] = x;
    c_rnd_gen(arr, &a, &c, &m);
    printf("BEFORE\n");
    int i = 0;
    while (i < 32) { printf("%.2lf, ", arr[i++]); }

    i = 0;
    while(i < 30) {
        c_fun(&arr[i], 0.393, 0.769, 0.189);
        c_fun(&arr[i + 1], 0.349, 0.686, 0.168);
        c_fun(&arr[i + 2], 0.272, 0.534, 0.131);
        i++;
    }
    
    printf("\n\nAFTER\n");
    
    i = 0;      while (i < 32) { printf("%.4lf, ", arr[i++]); }
}