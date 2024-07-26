/*

Copyright (c) 2024, HSMK

Permission to use, copy, modify, and/or distribute this software
for any purpose with or without fee is hereby granted, provided
that the above copyright notice and this permission notice appear
in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

 */

#include <stdlib.h>
#include <string.h>

#include "arraylist.h"

#define ARRAYLIST_DEFAULT_LENGTH 10
#define ARRAYLIST_OPERATION_FAILED 0
#define ARRAYLIST_OPERATION_SUCCEEDED 1
#define TRUE 1
#define FALSE 0

ArrayList *arraylist_new(unsigned int length)
{
    ArrayList *new_arraylist;

    /* If the length is not specified, use the default value. */

    length = (length <= 0) ? ARRAYLIST_DEFAULT_LENGTH : length;

    /* Allocate memory for the ArrayList. */

    new_arraylist = (ArrayList *)malloc(sizeof(ArrayList));

    if (new_arraylist == NULL)
    {
        return NULL;
    }

    new_arraylist->alloced = length;
    new_arraylist->length = 0;

    /* Allocate memory for the data array. */

    new_arraylist->data = (ArrayListValue *)malloc(sizeof(ArrayListValue) * length);

    if (new_arraylist->data == NULL)
    {
        free(new_arraylist);
        return NULL;
    }

    return new_arraylist;
}

void arraylist_free(ArrayList *arraylist)
{
    /* Free the data array. */

    if (arraylist != NULL)
    {
        free(arraylist->data);
        free(arraylist);
    }
}

static int arrayList_enlarge(ArrayList *arraylist)
{
    unsigned int new_alloced;
    ArrayListValue *new_data;

    /* Double the allocated length. */

    new_alloced = arraylist->alloced * 2;

    /* Reallocate the data array. */

    new_data = realloc(arraylist->data, sizeof(ArrayListValue) * new_alloced);

    if (new_data == NULL)
    {
        return ARRAYLIST_OPERATION_FAILED;
    }
    else
    {

        arraylist->data = new_data;
        arraylist->alloced = new_alloced;

        return ARRAYLIST_OPERATION_SUCCEEDED;
    }
}

int arraylist_insert(ArrayList *arraylist, unsigned int index, ArrayListValue data)
{
    /* Check that the index is valid. */

    if ((index > arraylist->length) || (index < 0))
    {
        return ARRAYLIST_OPERATION_FAILED;
    }

    /* Increase the array if necessary. */

    if (arraylist->length + 1 >= arraylist->alloced)
    {

        if (arrayList_enlarge(arraylist) == ARRAYLIST_OPERATION_FAILED)
        {

            return ARRAYLIST_OPERATION_FAILED;
        }
    }

    /* Move to the contens of the array forward from the index onwards.*/

    memmove(&arraylist->data[index + 1], &arraylist->data[index],
            sizeof(ArrayListValue) * (arraylist->length - index));

    /* Insert the data. */

    if (index < arraylist->length)
    {
        memmove(&arraylist->data[index + 1], &arraylist->data[index],
                sizeof(ArrayListValue) * (arraylist->length - index));
    }
    arraylist->data[index] = data;
    arraylist->length++;
}

int arraylist_append(ArrayList *arraylist, ArrayListValue data)
{
    return arraylist_insert(arraylist, arraylist->length, data);
}

int arraylist_prepend(ArrayList *arraylist, ArrayListValue data)
{

    return arraylist_insert(arraylist, 0, data);
}

void arraylist_remove(ArrayList *arraylist, unsigned int index)
{

    memmove(&arraylist->data[index], &arraylist->data[index + 1],
            sizeof(ArrayListValue) * (arraylist->length - index - 1));
    arraylist->length--;
}

void arraylist_remove_range(ArrayList *arraylist, unsigned int index,
                            unsigned int length)
{
    memmove(&arraylist->data[index], &arraylist->data[index + length],
            sizeof(ArrayListValue) * (arraylist->length - index - length));
    arraylist->length -= length;
}

int arraylist_index_of(ArrayList *arraylist,
                       ArrayListEqualFunc callback,
                       ArrayListValue data)
{

    unsigned int i;

    for (i = 0; i < arraylist->length; i++)
    {

        if (callback(arraylist->data[i], data) == TRUE)
        {

            return i;
        }
    }
}

void arraylist_clear(ArrayList *arraylist)
{
    arraylist->length = 0;

    memset(arraylist->data, 0, sizeof(ArrayListValue) * arraylist->alloced);
}

