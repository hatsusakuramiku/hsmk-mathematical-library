#include <stdio.h>
#include "../include/StdDef/result.h"
#include <stdlib.h>

HSMK_RESULT gamma_test(int num);

char *longlong_to_string(HSMK_RESULT result);
int main(void)
{
    int value = 0;
    HSMK_RESULT result = gamma_test(0);
    print_hsmk_result(result, longlong_to_string);
    return 0;
}

HSMK_RESULT gamma_test(int num)
{
    if (num <= 0)
    {
        return HSMK_RESULT_CREATE_ERROR("Invalid number, input number must > 0");
    }
    else if (num > 21)
    {
        return HSMK_RESULT_CREATE_ERROR("Invalid number, input number must <= 21");
    }
    long long out_value = 1;
    for (int i = 2; i < num; i++)
    {
        out_value *= i;
    }
    return HSMK_RESULT_CREATE_SUCCESS(&out_value, sizeof(long long), "long long");
}

char *longlong_to_string(HSMK_RESULT result)
{
    // 分配足够大的缓冲区
    char *buf = malloc(1024);
    if (!buf)
        return NULL;

    if (result.status == HSMK_MATH_LIB_RESULT_STATUS_SUCCESS && result.data != NULL)
    {
        snprintf(buf, 1024,
                 "Operation status: Success\nResult: %lld\nType: %s\n",
                 *(long long *)result.data,
                 result.type_name);
    }
    else
    {
        snprintf(buf, 1024,
                 "Operation status: Error\nError message: %s\nfile: %s\nfunction: %s\nline: %d\n",
                 result.exception.message,
                 result.exception.file,
                 result.exception.function,
                 result.exception.line);
    }
    return buf; // 记得外部 free
}