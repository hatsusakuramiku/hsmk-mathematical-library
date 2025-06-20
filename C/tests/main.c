#include <stdio.h>
#include "../include/StdDef/result.h"

HSMK_RESULT gamma_test(int num);
int main(void)
{
    int value = 0;
    HSMK_RESULT result = gamma_test(21);
    if (result.type == HSMK_MATH_LIB_RESULT_TYPE_SUCCESS)
    {
        printf("Result: %lld,\n %s,\n file = %s,\n line = %d,\n function = %s\n", *(long long *)result.data, result.exception.message, result.exception.file, result.exception.line, result.exception.function);
    }
    else
    {
        printf("Error: %s,\n file = %s,\n line = %d,\n function = %s\n", result.exception.message, result.exception.file, result.exception.line, result.exception.function);
    }
    return 0;
}

HSMK_RESULT gamma_test(int num)
{
    if (num <= 0)
    {
        return HSMK_RESULT_CREATE_ERROR("Invalid number, must > 0");
    }
    else if (num > 21)
    {
        return HSMK_RESULT_CREATE_ERROR("Invalid number, must <= 21");
    }
    long long out_value = 1;
    for (int i = 2; i < num; i++)
    {
        out_value *= i;
    }
    return HSMK_RESULT_CREATE_SUCCESS(&out_value, sizeof(long long), HSMK_MATH_LIB_RESULT_DATA_TYPE_LONG_LONG);
}