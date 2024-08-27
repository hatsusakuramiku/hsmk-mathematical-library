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
#include <stdlib.h>
#include <string.h>

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
static inline void _memswap(void *__restrict p1, void *__restrict p2, size_t n) {
 /* Use multiple small memcpys with constant size to enable inlining on most
    targets.  */
 enum {
  SWAP_GENERIC_SIZE = 32
 };
 while (n > SWAP_GENERIC_SIZE) {
  unsigned char tmp[SWAP_GENERIC_SIZE];
  memcpy(tmp, p1, SWAP_GENERIC_SIZE);
  p1 = mempcpy(p1, p2, SWAP_GENERIC_SIZE);
  p2 = mempcpy(p2, tmp, SWAP_GENERIC_SIZE);
  n -= SWAP_GENERIC_SIZE;
 }
 while (n > 0) {
  const unsigned char t = ((unsigned char *) p1)[--n];
  ((unsigned char *) p1)[n] = ((unsigned char *) p2)[n];
  ((unsigned char *) p2)[n] = t;
 }
}
#endif //_HSMK_MATH_LIB_MEMSWAP_H
