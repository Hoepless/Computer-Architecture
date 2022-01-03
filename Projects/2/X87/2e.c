
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

void c_fun(double *arr, double B, double C)
{
    __asm__ __volatile__(
        "mov $-1, %%rax\n"
        "fldl (%%rdi, %%rax, 8)\n"

        "push $2\n"
        "fildl (%%rsp)\n"
        "fldl (%1)\n"
        "push $255\n"
        "fildl (%%rsp)\n"
        "add $16, %%rsp\n"

        "fdivp\n"
        "fdivp\n"

        "fldl (%2)\n"
        "fmulp\n"

        "xor %%rax, %%rax\n"
        "fldl (%%rdi, %%rax, 8)\n"
        "fmulp\n"
        "fsubp\n"
        
        "xor %%rax, %%rax\n"
        "fstpl (%%rdi, %%rax, 8)\n"

        :
        : "D"(arr), "S"(&B), "d"(&C)
        : "%rax", "%rcx");
}

int main(int argc, char **argv)
{
    double arr[34];


    double x, a, c, m;
    printf("Enter x, a, c, m: ");
    scanf("%lf%lf%lf%lf", &x, &a, &c, &m);

    double A, B;
    printf("Enter b, c: ");
    scanf("%lf%lf", &A, &B);
    arr[1] = x;
    c_rnd_gen(&arr[1], &a, &c, &m);
    printf("BEFORE\n");
    int i = 1;
    while (i < 33) { printf("%.2lf, ", arr[i++]); }

    i = 1;
    while(i < 33) {
        c_fun(&arr[i], A, B);
        i++;
    }
    
    printf("\n\nAFTER\n");
    
    i = 1;      while (i < 33) { printf("%.4lf, ", arr[i++]); }
}