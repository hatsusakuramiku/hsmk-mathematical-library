/*
 * Copyright  2024 hatsusakuramiku
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef _HSMK_MATH_LIB_MEMSWAP_H
#define _HSMK_MATH_LIB_MEMSWAP_H

#include <string.h>

/**
 * @brief Copy memory block from source to destination.
 *
 * @details
 * This is a simple wrapper around memcpy() that returns a pointer to the end of the copied memory block.
 *
 * @param dest Pointer to the destination memory block.
 * @param src Pointer to the source memory block.
 * @param len Length of the memory block to be copied.
 * @return Pointer to the end of the copied memory block.
 */
inline void *__mempcpy(void *dest, const void *src, size_t len)
{
   memcpy(dest, src, len);
   return (void *)((uintptr_t)dest + len);
}

/**
 * @brief Swap two memory blocks of size @p n.
 *
 * @details
 * This function is implemented using multiple small memcpys with constant size to
 * enable inlining on most targets.
 *
 * @param p1 The first memory block to swap.
 * @param p2 The second memory block to swap.
 * @param n  The size of the memory blocks to swap.
 */
static inline void __memswap(void *__restrict p1, void *__restrict p2, size_t n)
{
   if (!p1 || !p2)
      return;

   /* Use multiple small memcpys with constant size to enable inlining on most
      targets.  */
   enum
   {
      SWAP_GENERIC_SIZE = 32
   };
   while (n > SWAP_GENERIC_SIZE)
   {
      unsigned char tmp[SWAP_GENERIC_SIZE];
      memcpy(tmp, p1, SWAP_GENERIC_SIZE);
      p1 = __mempcpy(p1, p2, SWAP_GENERIC_SIZE);
      p2 = __mempcpy(p2, tmp, SWAP_GENERIC_SIZE);
      n -= SWAP_GENERIC_SIZE;
   }
   while (n > 0)
   {
      const unsigned char t = ((unsigned char *)p1)[--n];
      ((unsigned char *)p1)[n] = ((unsigned char *)p2)[n];
      ((unsigned char *)p2)[n] = t;
   }
}

/**
 * @brief Swap two memory blocks using a temporary buffer.
 *
 * @details
 * This function swaps two memory blocks of size @p n using a temporary buffer.
 * It is useful when the two memory blocks are overlapping.
 *
 * @param p1 The first memory block to swap.
 * @param p2 The second memory block to swap.
 * @param temp The temporary buffer to use for swapping.
 * @param n  The size of the memory blocks to swap.
 */
static inline void memswapWithTemp(void *__restrict p1, void *__restrict p2, void *__restrict temp, size_t n)
{
   if (!p1 || !p2 || !temp)
      return;
   if (p1 == p2 || n == 0)
      return;
   memcpy(temp, p1, n);
   memcpy(p1, p2, n);
   memcpy(p2, temp, n);
}

/**
 * @brief Move a pointer to the right by a specified number of elements.
 *
 * @details
 * This function moves a pointer to the right by a specified number of elements.
 * It is useful when dealing with arrays.
 *
 * @param ptr The pointer to move to the right.
 * @param size The size of each element in the array.
 * @param count The number of elements to move the pointer to the right.
 *
 * @return A pointer pointing to the new location.
 */
static inline void *rightMovePtr(void *ptr, size_t size, size_t count)
{
   // Move the pointer to the right by a specified number of elements
   return (void *)((uintptr_t)ptr + size * count);
}

/**
 * @brief Move a pointer to the left by a specified number of elements.
 *
 * @details
 * This function moves a pointer to the left by a specified number of elements.
 * It is useful when dealing with arrays.
 *
 * @param ptr The pointer to move to the left.
 * @param size The size of each element in the array.
 * @param count The number of elements to move the pointer to the left.
 *
 * @return A pointer pointing to the new location.
 */
static inline void *leftMovePtr(void *ptr, size_t size, size_t count)
{
   // Move the pointer to the left by a specified number of elements
   return (void *)((uintptr_t)ptr - size * count);
}
#endif //_HSMK_MATH_LIB_MEMSWAP_H
