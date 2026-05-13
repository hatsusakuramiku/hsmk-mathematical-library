{******************************************************************************}
{                       Copyright  2025 hatsusakuramiku                        }
{                                                                              }
{                              MIT LICENSE                                     }
{ Permission is hereby granted, free of charge, to any person obtaining a copy }
{ of this software and associated documentation files (the "Software"), to deal }
{ in the Software without restriction, including without limitation the rights }
{ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    }
{ copies of the Software, and to permit persons to whom the Software is        }
{ furnished to do so, subject to the following conditions:                     }
{                                                                              }
{ The above copyright notice and this permission notice shall be included in   }
{ all copies or substantial portions of the Software.                          }
{                                                                              }
{ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   }
{ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     }
{ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE }
{ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN   }
{ THE SOFTWARE.                                                                }
{******************************************************************************}

{ Require Version >= Delphi XE4 (Delphi 10.0) }

{ This unit provides pointer-based operations similar to C language functions. }
{ To maintain compatibility with FMX framework, Windows library functions are not used. }

unit CLikeFunctionToolsUnit;

interface

{$IFNDEF TSize_T}
type
  TSize_T = NativeUInt;
{$ENDIF}

{ Memory Functions }

/// <summary>
/// Compares two memory blocks byte by byte.
/// </summary>
/// <param name="APData1">Pointer to the first memory block.</param>
/// <param name="APData2">Pointer to the second memory block.</param>
/// <param name="ASize">Number of bytes to compare.</param>
/// <returns>True if the memory blocks are identical, False otherwise.</returns>
function MemCompare(const APData1, APData2: Pointer; const ASize: TSize_T): Boolean;

/// <summary>
/// Swaps two memory blocks of the specified size using a temporary buffer.
/// </summary>
/// <param name="APData1">Pointer to the first memory block.</param>
/// <param name="APData2">Pointer to the second memory block.</param>
/// <param name="ASize">Size in bytes to swap.</param>
procedure MemSwap(const APData1, APData2: Pointer; const ASize: TSize_T); overload; inline;

/// <summary>
/// Swaps two memory blocks using a caller-provided temporary buffer.
/// </summary>
/// <param name="AData1">Pointer to the first memory block.</param>
/// <param name="AData2">Pointer to the second memory block.</param>
/// <param name="ASwapBuffer">Pointer to a temporary buffer of at least ASize bytes.</param>
/// <param name="ASize">Size in bytes to swap.</param>
procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: TSize_T); overload; inline;

type
  /// <summary>
  /// Callback function type for validating array elements.
  /// </summary>
  /// <param name="APCheckedData">Pointer to the element to check.</param>
  /// <param name="AContext">Pointer to user-provided context data.</param>
  /// <returns>True if the element is valid, False otherwise.</returns>
  TCheckFunction = reference to function(const APCheckedData, AContext: Pointer): Boolean;

/// <summary>
/// Validates that all elements in an array satisfy a condition.
/// </summary>
/// <param name="APBase">Pointer to the base of the array.</param>
/// <param name="AContext">Pointer to user-provided context data passed to the check function.</param>
/// <param name="AElemNum">Number of elements in the array.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="ACheckFunc">Function to validate each element.</param>
/// <returns>True if all elements are valid, False otherwise.</returns>
/// <remarks>
/// Returns False immediately if APBase or ACheckFunc is nil, or if AElemNum &lt;= 0 or AElemSize &lt;= 0.
/// Returns True only if all elements pass the check function.
/// </remarks>
function CheckArrayAllElemAreVaild(const APBase, AContext: Pointer; const AElemNum, AElemSize: TSize_T; const ACheckFunc: TCheckFunction): Boolean; overload;

/// <summary>
/// Validates that all elements in an Integer array satisfy a condition.
/// </summary>
/// <param name="AArray">The dynamic Integer array to check.</param>
/// <param name="AContext">Pointer to user-provided context data passed to the check function.</param>
/// <param name="ACheckFunc">Function to validate each element.</param>
/// <returns>True if all elements are valid, False otherwise.</returns>
function CheckArrayAllElemAreVaild(const AArray: array of Integer; const AContext: Pointer; ACheckFunc: TCheckFunction): Boolean; overload;

{ Sort Functions }

type
  /// <summary>
  /// Comparison function type for sorting.
  /// </summary>
  /// <param name="APData1">Pointer to the first data element.</param>
  /// <param name="APData2">Pointer to the second data element.</param>
  /// <param name="APContext">Pointer to user-provided context data.</param>
  /// <returns>
  ///   -1 if APData1 &lt; APData2
  ///   0 if APData1 = APData2
  ///   1 if APData1 &gt; APData2
  /// </returns>
  TCompareFunction = reference to function(APData1, APData2, APContext: Pointer): Integer;

  /// <summary>
  /// Sort function type for pointer-based sorting.
  /// </summary>
  /// <param name="APBase">Pointer to the base of the array.</param>
  /// <param name="AElemNum">Number of elements.</param>
  /// <param name="AElemSize">Size of each element in bytes.</param>
  /// <param name="APContext">Pointer to user-provided context data.</param>
  /// <param name="ACompareFunc">Comparison function.</param>
  TSortFunction = procedure(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

const
  /// <summary>
  /// Minimum subarray length threshold for hybrid sorting algorithms.
  /// When subarrays are smaller than this, insertion sort is used.
  /// </summary>
  MINSUBARRLEN: TSize_T = 8;

{ Pointer Helper Functions }

/// <summary>
/// Moves a pointer left by the specified byte offset.
/// </summary>
/// <param name="ApBase">The original pointer.</param>
/// <param name="AOffset">The byte offset to move (positive = left/negative direction).</param>
/// <returns>The moved pointer.</returns>
function LeftMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer; inline;

/// <summary>
/// Moves a pointer right by the specified byte offset.
/// </summary>
/// <param name="ApBase">The original pointer.</param>
/// <param name="AOffset">The byte offset to move (positive = right/forward direction).</param>
/// <returns>The moved pointer.</returns>
function RightMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer; inline;

/// <summary>
/// Moves a pointer by the specified signed offset.
/// </summary>
/// <param name="APBase">The original pointer.</param>
/// <param name="AOffset">The signed byte offset (positive = forward, negative = backward).</param>
/// <returns>The moved pointer.</returns>
function MovePtr(const APBase: Pointer; const AOffset: NativeInt): Pointer; inline;

{ Validation Functions }

/// <summary>
/// Checks if the array is sorted in ascending order according to the compare function.
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function defining sort order.</param>
/// <returns>True if sorted in ascending order, False otherwise.</returns>
function IsSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;

/// <summary>
/// Reverses the order of elements in the array.
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
procedure ReverseArray(const APBase: Pointer; AElemNum, AElemSize: TSize_T);

/// <summary>
/// Checks if the array is sorted in descending order according to the compare function.
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function defining sort order.</param>
/// <returns>True if sorted in descending order, False otherwise.</returns>
function IsReverseSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;

{ Sort Algorithms }

/// <summary>
/// Sorts the array using Bubble Sort algorithm.
/// Time complexity: O(n^2), Space: O(1).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
procedure BubbleSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Insertion Sort algorithm.
/// Time complexity: O(n^2) worst/average, O(n) best, Space: O(1).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
procedure InsertionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Selection Sort algorithm.
/// Time complexity: O(n^2) all cases, Space: O(1).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
procedure SelectionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Shell Sort algorithm with Hibbard gap sequence.
/// Time complexity: approximately O(n^(3/2)), Space: O(1).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
procedure ShellSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Merge Sort algorithm.
/// Time complexity: O(n log n) all cases, Space: O(n).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
procedure MergeSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Heap Sort algorithm.
/// Time complexity: O(n log n) all cases, Space: O(1).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
procedure HeapSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Hybrid Sort (InsertionSort + MergeSort with HeapSort fallback).
/// Time complexity: O(n log n), Space: O(n) for MergeSort, O(1) for HeapSort fallback.
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <remarks>
/// For small arrays (&lt;= MINSUBARRLEN), uses InsertionSort directly.
/// For larger arrays, attempts MergeSort first; if memory allocation fails (EOutOfMemory),
/// falls back to HeapSort which is in-place.
/// </remarks>
procedure HybridSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Quick Sort algorithm.
/// Time complexity: O(n log n) average, O(n^2) worst, Space: O(log n).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
procedure QuickSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Sorts the array using Intro Sort algorithm (QuickSort + HeapSort + InsertionSort).
/// Time complexity: O(n log n) average and worst, Space: O(log n).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <remarks>
/// Hybrid algorithm combining QuickSort, HeapSort, and InsertionSort.
/// Uses middle element as pivot. Switches to HeapSort when recursion depth exceeds 2*log2(n).
/// Uses InsertionSort for subarrays &lt;= MINSUBARRLEN elements.
/// </remarks>
procedure IntroSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

/// <summary>
/// Optimized sorting that checks if array is already sorted or reverse sorted.
/// </summary>
/// <param name="ASortFunc">The sort function to use if sorting is needed.</param>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <remarks>
/// Checks if already sorted (exits early), or if reverse sorted (reverses array in-place),
/// before calling the actual sort function. Useful for frequently called sorting operations
/// where data may already be in order.
/// </remarks>
procedure OptimizedSort(ASortFunc: TSortFunction; const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

{ Search Functions }

type
  /// <summary>
  /// Search function type returning a single index result.
  /// </summary>
  /// <param name="APBase">Pointer to the array base to search.</param>
  /// <param name="AElemNum">Number of elements.</param>
  /// <param name="AElemSize">Size of each element in bytes.</param>
  /// <param name="APContext">Pointer to user-provided context data.</param>
  /// <param name="ASearchedElem">Pointer to the target element to find.</param>
  /// <param name="ACompareFunc">Comparison function to determine element equality and ordering.</param>
  /// <returns>
  ///   -1 if not found or array is empty;
  ///   otherwise, the index of the found element (0-based).
  /// </returns>
  TSearchFunction = function(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;

  /// <summary>
  /// Search function type returning all matching indices.
  /// </summary>
  /// <param name="APBase">Pointer to the array base to search.</param>
  /// <param name="AElemNum">Number of elements.</param>
  /// <param name="AElemSize">Size of each element in bytes.</param>
  /// <param name="APContext">Pointer to user-provided context data.</param>
  /// <param name="ASearchedElem">Pointer to the target element to find.</param>
  /// <param name="ACompareFunc">Comparison function to determine element equality and ordering.</param>
  /// <returns>
  ///   Empty array if not found or array is empty;
  ///   otherwise, array of indices of all matching elements (0-based).
  /// </returns>
  TSearchsFunction = function(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TArray<Integer>;

/// <summary>
/// Searches for an element using binary search. Array must be sorted in ascending order.
/// Time complexity: O(log n).
/// </summary>
/// <param name="APBase">Pointer to the sorted array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ASearchedElem">Pointer to the target element to find.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <returns>
///   -1 if not found;
///   otherwise, the index of the found element (0-based).
/// </returns>
/// <remarks>
/// Array must be sorted in ascending order. If the array contains duplicates,
/// returns the index of one of the matching elements (not necessarily the first).
/// </remarks>
function BinarySearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;

/// <summary>
/// Searches for all matching elements using binary search. Array must be sorted.
/// Time complexity: O(log n + k) where k is the number of matches.
/// </summary>
/// <param name="APBase">Pointer to the sorted array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ASearchedElem">Pointer to the target element to find.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <returns>
///   Empty array if not found;
///   otherwise, array of indices of all matching elements (0-based, sorted ascending).
/// </returns>
function BinarySearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TArray<Integer>;

/// <summary>
/// Searches for an element using sequential/linear search.
/// Time complexity: O(n).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ASearchedElem">Pointer to the target element to find.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <returns>
///   -1 if not found;
///   otherwise, the index of the first match (0-based).
/// </returns>
function SequentialSearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;

/// <summary>
/// Searches for an element using sequential search with offset capability.
/// Time complexity: O(n).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ASearchedElem">Pointer to the target element to find.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <param name="AOffset">
///   Skip count. Default 0.
///   If &gt; 0, ignores the first AOffset matching elements and returns the position of the next one.
///   For finding the Nth occurrence of a duplicate element.
/// </param>
/// <returns>
///   -1 if not found or insufficient matches;
///   otherwise, the index of the found element (0-based).
/// </returns>
function SequentialSearchEx(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction; AOffset: Cardinal = 0): Integer;

/// <summary>
/// Searches for all matching elements using sequential search.
/// Time complexity: O(n).
/// </summary>
/// <param name="APBase">Pointer to the array base.</param>
/// <param name="AElemNum">Number of elements.</param>
/// <param name="AElemSize">Size of each element in bytes.</param>
/// <param name="APContext">Pointer to user-provided context data.</param>
/// <param name="ASearchedElem">Pointer to the target element to find.</param>
/// <param name="ACompareFunc">Comparison function.</param>
/// <returns>
///   Empty array if not found;
///   otherwise, array of indices of all matching elements (0-based, sorted ascending).
/// </returns>
function SequentialSearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TArray<Integer>;

implementation

uses
  System.SysUtils, System.Math;

{ Memory Functions }

function MemCompare(const APData1, APData2: Pointer; const ASize: TSize_T): Boolean;
begin
  Result := CompareMem(APData1, APData2, ASize);
end;

procedure MemSwap(const APData1, APData2: Pointer; const ASize: TSize_T); overload;
var
  pTemp: Pointer;
begin
  if (ASize = 0) or (APData1 = APData2) then
    Exit;

  pTemp := AllocMem(ASize);
  try
    MemSwap(APData1, APData2, pTemp, ASize);
  finally
    FreeMem(pTemp);
  end;
end;

procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: TSize_T); overload;
{$IF defined(PUREPASCAL) OR defined(FMX)}
{$POINTERMATH ON}
var
  Source1Ptr, Source2Ptr, SwapBufferPtr: PByte;
  ByteOffset: TSize_T;
  TempNativeInt, NativeIntSize: TSize_T;
begin
  if ASize = 0 then
    Exit;

  Source1Ptr := PByte(AData1);
  Source2Ptr := PByte(AData2);
  SwapBufferPtr := PByte(ASwapBuffer);
  NativeIntSize := SizeOf(TSize_T);

  if ASize <= NativeIntSize then
    case ASize of
      1:
        begin
          SwapBufferPtr[0] := Source1Ptr[0];
          Source1Ptr[0] := Source2Ptr[0];
          Source2Ptr[0] := SwapBufferPtr[0];
        end;
      2:
        begin
          PWord(SwapBufferPtr)[0] := PWord(Source1Ptr)[0];
          PWord(Source1Ptr)[0] := PWord(Source2Ptr)[0];
          PWord(Source2Ptr)[0] := PWord(SwapBufferPtr)[0];
        end;
      3:
        begin
          PWord(SwapBufferPtr)[0] := PWord(Source1Ptr)[0];
          PWord(Source1Ptr)[0] := PWord(Source2Ptr)[0];
          PWord(Source2Ptr)[0] := PWord(SwapBufferPtr)[0];

          SwapBufferPtr[0] := Source1Ptr[2];
          Source1Ptr[2] := Source2Ptr[2];
          Source2Ptr[2] := SwapBufferPtr[0];
        end;
      4:
        begin
          PInteger(SwapBufferPtr)[0] := PInteger(Source1Ptr)[0];
          PInteger(Source1Ptr)[0] := PInteger(Source2Ptr)[0];
          PInteger(Source2Ptr)[0] := PInteger(SwapBufferPtr)[0];
        end;
      5:
        begin
          PInteger(SwapBufferPtr)[0] := PInteger(Source1Ptr)[0];
          PInteger(Source1Ptr)[0] := PInteger(Source2Ptr)[0];
          PInteger(Source2Ptr)[0] := PInteger(SwapBufferPtr)[0];

          SwapBufferPtr[0] := Source1Ptr[4];
          Source1Ptr[4] := Source2Ptr[4];
          Source2Ptr[4] := SwapBufferPtr[0];
        end;
      6:
        begin
          PInteger(SwapBufferPtr)[0] := PInteger(Source1Ptr)[0];
          PInteger(Source1Ptr)[0] := PInteger(Source2Ptr)[0];
          PInteger(Source2Ptr)[0] := PInteger(SwapBufferPtr)[0];

          PWord(SwapBufferPtr)[0] := PWord(Source1Ptr)[2];
          PWord(Source1Ptr)[2] := PWord(Source2Ptr)[2];
          PWord(Source2Ptr)[2] := PWord(SwapBufferPtr)[0];
        end;
      7:
        begin
          PInteger(SwapBufferPtr)[0] := PInteger(Source1Ptr)[0];
          PInteger(Source1Ptr)[0] := PInteger(Source2Ptr)[0];
          PInteger(Source2Ptr)[0] := PInteger(SwapBufferPtr)[0];

          PWord(SwapBufferPtr)[0] := PWord(Source1Ptr)[2];
          PWord(Source1Ptr)[2] := PWord(Source2Ptr)[2];
          PWord(Source2Ptr)[2] := PWord(SwapBufferPtr)[0];

          SwapBufferPtr[0] := Source1Ptr[6];
          Source1Ptr[6] := Source2Ptr[6];
          Source2Ptr[6] := SwapBufferPtr[0];
        end;
      8:
        begin
          PInt64(SwapBufferPtr)[0] := PInt64(Source1Ptr)[0];
          PInt64(Source1Ptr)[0] := PInt64(Source2Ptr)[0];
          PInt64(Source2Ptr)[0] := PInt64(SwapBufferPtr)[0];
        end;
    else
      for ByteOffset := 0 to ASize - 1 do
      begin
        SwapBufferPtr[ByteOffset] := Source1Ptr[ByteOffset];
        Source1Ptr[ByteOffset] := Source2Ptr[ByteOffset];
        Source2Ptr[ByteOffset] := SwapBufferPtr[ByteOffset];
      end;
    end
  else
  begin
    ByteOffset := 0;
    while ByteOffset + NativeIntSize <= ASize do
    begin
      TempNativeInt := PNativeInt(Source1Ptr + ByteOffset)^;
      PNativeInt(Source1Ptr + ByteOffset)^ := PNativeInt(Source2Ptr + ByteOffset)^;
      PNativeInt(Source2Ptr + ByteOffset)^ := TempNativeInt;
      Inc(ByteOffset, NativeIntSize);
    end;

    while ByteOffset < ASize do
    begin
      SwapBufferPtr[0] := Source1Ptr[ByteOffset];
      Source1Ptr[ByteOffset] := Source2Ptr[ByteOffset];
      Source2Ptr[ByteOffset] := SwapBufferPtr[0];
      Inc(ByteOffset);
    end;
  end;
end;
{$POINTERMATH OFF}
{$ELSEIF defined(POSIX)}
begin
  if ASize > 0 then
  begin
    memmove(ASwapBuffer, AData1, ASize);
    memmove(AData1, AData2, ASize);
    memmove(AData2, ASwapBuffer, ASize);
  end;
end;
{$ELSE}
begin
  Move(AData1^, ASwapBuffer^, ASize);
  Move(AData2^, AData1^, ASize);
  Move(ASwapBuffer^, AData2^, ASize);
end;
{$ENDIF}

function CheckArrayAllElemAreVaild(const APBase, AContext: Pointer; const AElemNum, AElemSize: TSize_T; const ACheckFunc: TCheckFunction): Boolean; overload;
var
  i: TSize_T;
begin
  Result := False;

  if not (Assigned(APBase) and (AElemSize > 0) and (AElemNum > 0) and Assigned(ACheckFunc)) then
    Exit;

  for i := 0 to AElemNum - 1 do
  begin
    if not ACheckFunc(LeftMovePtr(APBase, i * AElemSize), AContext) then
      Exit;
  end;

  Result := True;
end;

function CheckArrayAllElemAreVaild(const AArray: array of Integer; const AContext: Pointer; ACheckFunc: TCheckFunction): Boolean; overload;
var
  i: Integer;
begin
  Result := False;

  if not Assigned(ACheckFunc) then
    Exit;

  for i := Low(AArray) to High(AArray) do
  begin
    if not ACheckFunc(@AArray[i], AContext) then
      Exit;
  end;

  Result := True;
end;

{ Sort Function Helpers }

var
  MemSwapBufferSize: TSize_T;
  MemSwapBuffer: Pointer;

procedure DestoryMemSwapBuffer;
begin
  if Assigned(MemSwapBuffer) then
  begin
    FreeMem(MemSwapBuffer, MemSwapBufferSize);
  end;

  MemSwapBuffer := nil;
  MemSwapBufferSize := 0;
end;

procedure CreateMemSwapBuffer(ABufferSize: TSize_T);
begin
  DestoryMemSwapBuffer;
  MemSwapBufferSize := ABufferSize;
  MemSwapBuffer := AllocMem(MemSwapBufferSize);
end;

procedure MemSwapFaster(const APData1, APData2: Pointer);
begin
  MemSwap(APData1, APData2, MemSwapBuffer, MemSwapBufferSize);
end;

{ Pointer Helper Functions }

function LeftMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;
begin
  Result := Pointer(TSize_T(ApBase) - AOffset);
end;

function RightMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;
begin
  Result := Pointer(TSize_T(ApBase) + AOffset);
end;

function MovePtr(const APBase: Pointer; const AOffset: NativeInt): Pointer; inline;
begin
  Result := Pointer(NativeInt(APBase) + AOffset);
end;

procedure ReverseArray(const APBase: Pointer; AElemNum, AElemSize: TSize_T);
var
  pLeft, pRight: Pointer;
  i: TSize_T;
begin
  if (APBase = nil) or (AElemNum < 2) or (AElemSize = 0) then
    Exit;

  pLeft := APBase;
  pRight := RightMovePtr(APBase, (AElemNum - 1) * AElemSize);

  CreateMemSwapBuffer(AElemSize);
  try
    for i := 0 to (AElemNum div 2) - 1 do
    begin
      MemSwapFaster(pLeft, pRight);
      pLeft := RightMovePtr(pLeft, AElemSize);
      pRight := LeftMovePtr(pRight, AElemSize);
    end;
  finally
    DestoryMemSwapBuffer;
  end;
end;

function IsReverseSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;
var
  i: TSize_T;
begin
  Result := True;

  if (APBase = nil) or (AElemNum <= 1) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit(False);

  for i := 0 to AElemNum - 2 do
  begin
    if ACompareFunc(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase, (i + 1) * AElemSize), APContext) > 0 then
    begin
      Result := False;
      Break;
    end;
  end;
end;

procedure OptimizedSort(ASortFunc: TSortFunction; const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
begin
  if (APBase = nil) or (AElemNum <= 1) or (AElemSize = 0) or (not Assigned(ACompareFunc)) or (not Assigned(ASortFunc)) then
    Exit;

  if IsSorted(APBase, AElemNum, AElemSize, APContext, ACompareFunc) then
    Exit;

  if IsReverseSorted(APBase, AElemNum, AElemSize, APContext, ACompareFunc) then
  begin
    ReverseArray(APBase, AElemNum, AElemSize);
    Exit;
  end;

  ASortFunc(APBase, AElemNum, AElemSize, APContext, ACompareFunc);
end;

function IsSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;
var
  i: TSize_T;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit(False);

  for i := 0 to AElemNum - 2 do
  begin
    if ACompareFunc(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase, (i + 1) * AElemSize), APContext) > 0 then
      Exit(False);
  end;

  Result := True;
end;

procedure BubbleSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  bFlag: Boolean;
  i, j: TSize_T;
  PData1, PData2: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  CreateMemSwapBuffer(AElemSize);
  try
    for i := 0 to AElemNum - 1 do
    begin
      bFlag := False;

      for j := 0 to AElemNum - 2 - i do
      begin
        PData1 := RightMovePtr(APBase, j * AElemSize);
        PData2 := RightMovePtr(APBase, (j + 1) * AElemSize);
        if ACompareFunc(PData1, PData2, APContext) > 0 then
        begin
          MemSwapFaster(PData1, PData2);
          bFlag := True;
        end;
      end;

      if not bFlag then
        Break;
    end;
  finally
    DestoryMemSwapBuffer;
  end;
end;

procedure InsertionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i, j: TSize_T;
  pKey: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  pKey := AllocMem(AElemSize);
  try
    for i := 1 to AElemNum - 1 do
    begin
      Move(RightMovePtr(APBase, i * AElemSize)^, pKey^, AElemSize);
      j := i;

      while (j >= 1) and (ACompareFunc(pKey, RightMovePtr(APBase, (j - 1) * AElemSize), APContext) < 0) do
      begin
        Move(RightMovePtr(APBase, (j - 1) * AElemSize)^, RightMovePtr(APBase, j * AElemSize)^, AElemSize);
        Dec(j);
      end;

      Move(pKey^, RightMovePtr(APBase, j * AElemSize)^, AElemSize);
    end;
  finally
    FreeMem(pKey);
  end;
end;

procedure SelectionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i, j, iMinIndex: TSize_T;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  CreateMemSwapBuffer(AElemSize);
  try
    for i := 0 to AElemNum - 2 do
    begin
      iMinIndex := i;

      for j := i + 1 to AElemNum - 1 do
      begin
        if ACompareFunc(RightMovePtr(APBase, j * AElemSize), RightMovePtr(APBase, iMinIndex * AElemSize), APContext) < 0 then
          iMinIndex := j;
      end;

      if iMinIndex <> i then
        MemSwapFaster(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase, iMinIndex * AElemSize));
    end;
  finally
    DestoryMemSwapBuffer;
  end;
end;

function GetHibbardStepArr(ALength: Integer): TArray<Integer>;
var
  iNum, i: Integer;
begin
  iNum := Floor(Log2(ALength + 1));
  if iNum = 0 then
    Inc(iNum);

  SetLength(Result, iNum);

  for i := iNum - 1 downto 0 do
  begin
    Result[i] := Floor(Power(2, i + 1)) - 1;
  end;
end;

procedure ShellSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i, j, k: TSize_T;
  aHibbardStepArr: TArray<Integer>;
  pKey: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  aHibbardStepArr := GetHibbardStepArr(AElemNum);
  pKey := AllocMem(AElemSize);
  try
    for k := Low(aHibbardStepArr) to High(aHibbardStepArr) do
    begin
      for i := aHibbardStepArr[k] to AElemNum - 1 do
      begin
        Move(RightMovePtr(APBase, i * AElemSize)^, pKey^, AElemSize);
        j := i;

        while (j >= 1) and (ACompareFunc(pKey, RightMovePtr(APBase, (j - 1) * AElemSize), APContext) < 0) do
        begin
          Move(RightMovePtr(APBase, (j - 1) * AElemSize)^, RightMovePtr(APBase, j * AElemSize)^, AElemSize);
          Dec(j);
        end;

        Move(pKey^, RightMovePtr(APBase, j * AElemSize)^, AElemSize);
      end;
    end;
  finally
    FreeMem(pKey);
  end;
end;

procedure Heapify(APBase: Pointer; AElemNum, AIndex, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  CurrentIndex: TSize_T;
  LargestIndex: TSize_T;
  LeftChildIndex: TSize_T;
  RightChildIndex: TSize_T;
  CurrentNodePtr, LargestNodePtr, LeftChildPtr, RightChildPtr: Pointer;
begin
  CurrentIndex := AIndex;

  while True do
  begin
    LargestIndex := CurrentIndex;

    LeftChildIndex := 2 * CurrentIndex + 1;
    RightChildIndex := 2 * CurrentIndex + 2;

    if (LeftChildIndex < AElemNum) then
    begin
      LeftChildPtr := RightMovePtr(APBase, LeftChildIndex * AElemSize);
      CurrentNodePtr := RightMovePtr(APBase, LargestIndex * AElemSize);
      if ACompareFunc(LeftChildPtr, CurrentNodePtr, APContext) > 0 then
      begin
        LargestIndex := LeftChildIndex;
      end;
    end;

    if (RightChildIndex < AElemNum) then
    begin
      RightChildPtr := RightMovePtr(APBase, RightChildIndex * AElemSize);
      CurrentNodePtr := RightMovePtr(APBase, LargestIndex * AElemSize);
      if ACompareFunc(RightChildPtr, CurrentNodePtr, APContext) > 0 then
      begin
        LargestIndex := RightChildIndex;
      end;
    end;

    if LargestIndex <> CurrentIndex then
    begin
      CurrentNodePtr := RightMovePtr(APBase, CurrentIndex * AElemSize);
      LargestNodePtr := RightMovePtr(APBase, LargestIndex * AElemSize);
      MemSwapFaster(CurrentNodePtr, LargestNodePtr);
      CurrentIndex := LargestIndex;
    end
    else
      Break;
  end;
end;

procedure HeapSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i: TSize_T;
  LastNodePtr, RootNodePtr: Pointer;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  CreateMemSwapBuffer(AElemSize);
  try
    if AElemNum > 1 then
    begin
      for i := (AElemNum div 2) - 1 downto 0 do
      begin
        Heapify(APBase, AElemNum, i, AElemSize, APContext, ACompareFunc);
      end;
    end;

    for i := AElemNum - 1 downto 1 do
    begin
      RootNodePtr := APBase;
      LastNodePtr := RightMovePtr(APBase, i * AElemSize);
      MemSwapFaster(RootNodePtr, LastNodePtr);

      Heapify(APBase, i, 0, AElemSize, APContext, ACompareFunc);
    end;
  finally
    DestoryMemSwapBuffer;
  end;
end;

procedure MergeSortBase(const APBase: Pointer; AStart, AMid, AEnd, AElemSize: TSize_T; APContext, ATemp: Pointer; ACompareFunc: TCompareFunction);
var
  pLeftPtr, pRightPtr, pTempCurrent: Pointer;
  iLeftIndex, iRightIndex, iTempIndex: TSize_T;
begin
  iLeftIndex := AStart;
  iRightIndex := AMid + 1;
  iTempIndex := 0;

  while (iLeftIndex <= AMid) and (iRightIndex <= AEnd) do
  begin
    pLeftPtr := RightMovePtr(APBase, iLeftIndex * AElemSize);
    pRightPtr := RightMovePtr(APBase, iRightIndex * AElemSize);
    pTempCurrent := RightMovePtr(ATemp, iTempIndex * AElemSize);

    if ACompareFunc(pLeftPtr, pRightPtr, APContext) < 0 then
    begin
      Move(pLeftPtr^, pTempCurrent^, AElemSize);
      Inc(iLeftIndex);
    end
    else
    begin
      Move(pRightPtr^, pTempCurrent^, AElemSize);
      Inc(iRightIndex);
    end;

    Inc(iTempIndex);
  end;

  while iLeftIndex <= AMid do
  begin
    pTempCurrent := RightMovePtr(ATemp, iTempIndex * AElemSize);
    Move(RightMovePtr(APBase, iLeftIndex * AElemSize)^, pTempCurrent^, AElemSize);
    Inc(iLeftIndex);
    Inc(iTempIndex);
  end;

  while iRightIndex <= AEnd do
  begin
    pTempCurrent := RightMovePtr(ATemp, iTempIndex * AElemSize);
    Move(RightMovePtr(APBase, iRightIndex * AElemSize)^, pTempCurrent^, AElemSize);
    Inc(iRightIndex);
    Inc(iTempIndex);
  end;

  Move(ATemp^, RightMovePtr(APBase, AStart * AElemSize)^, iTempIndex * AElemSize);
end;

procedure MergeSortBaseWithTemp(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext, ATemp: Pointer; ACompareFunc: TCompareFunction);
var
  iWidth, i, iLeft, iMid, iRight: TSize_T;
begin
  i := 0;
  while i < AElemNum do
  begin
    iRight := Min(i + MINSUBARRLEN - 1, AElemNum - 1);
    InsertionSort(RightMovePtr(APBase, i * AElemSize), iRight - i + 1, AElemSize, APContext, ACompareFunc);
    i := i + MINSUBARRLEN;
  end;

  iWidth := MINSUBARRLEN;
  while iWidth < AElemNum do
  begin
    i := 0;
    while i < AElemNum do
    begin
      iLeft := i;
      iMid := Min(i + iWidth - 1, AElemNum - 1);
      iRight := Min(i + 2 * iWidth - 1, AElemNum - 1);
      if iMid < iRight then
        MergeSortBase(APBase, iLeft, iMid, iRight, AElemSize, APContext, ATemp, ACompareFunc);
      i := i + 2 * iWidth;
    end;
    iWidth := iWidth * 2;
  end;
end;

procedure MergeSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  ATemp: Pointer;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  ATemp := AllocMem(AElemNum * AElemSize);
  try
    MergeSortBaseWithTemp(APBase, AElemNum, AElemSize, APContext, ATemp, ACompareFunc);
  finally
    FreeMem(ATemp);
  end;
end;

procedure HybridSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  pTemp: Pointer;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  if AElemNum <= MINSUBARRLEN then
  begin
    InsertionSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc);
    Exit;
  end;

  try
    pTemp := AllocMem(AElemNum * AElemSize);
    try
      MergeSortBaseWithTemp(APBase, AElemNum, AElemSize, APContext, pTemp, ACompareFunc);
    finally
      FreeMem(pTemp);
    end;
  except
    HeapSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc);
    Exit;
  end;
end;

procedure QuickSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
  procedure InternalQuickSort(const ABase: Pointer; const AElemNum, AElemSize: TSize_T; const APContext: Pointer; const ACompareFunc: TCompareFunction; const AL, AR: TSize_T);
  var
    I, J: TSize_T;
    pivotIndex: TSize_T;
    pivotValPtr: Pointer;
  begin
    if (AR <= AL) then
      Exit;

    pivotIndex := AL + ((AR - AL) shr 1);
    pivotValPtr := RightMovePtr(ABase, pivotIndex * AElemSize);
    MemSwapFaster(RightMovePtr(ABase, AL * AElemSize), pivotValPtr);

    pivotValPtr := RightMovePtr(ABase, AL * AElemSize);

    I := AL + 1;
    J := AR;

    repeat
      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, I * AElemSize), pivotValPtr, APContext) < 0) do
        Inc(I);

      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, J * AElemSize), pivotValPtr, APContext) > 0) do
      begin
        if J = AL then
          Break;
        Dec(J);
      end;

      if I <= J then
      begin
        if I <> J then
          MemSwapFaster(RightMovePtr(ABase, I * AElemSize), RightMovePtr(ABase, J * AElemSize));

        Inc(I);
        if J > AL then
          Dec(J)
        else
          Break;
      end;
    until I > J;

    MemSwapFaster(RightMovePtr(ABase, AL * AElemSize), RightMovePtr(ABase, J * AElemSize));

    if AL < J then
      InternalQuickSort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, AL, J - 1);

    if I < AR then
      InternalQuickSort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, I, AR);
  end;
begin
  if (APBase = nil) or (AElemNum < 2) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  CreateMemSwapBuffer(AElemSize);
  try
    InternalQuickSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, 0, AElemNum - 1);
  finally
    DestoryMemSwapBuffer;
  end;
end;

procedure IntroSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  maxDepth: Integer;
  procedure InternalIntrosort(const ABase: Pointer; const ACurrentElemNum, AElemSize: NativeInt; const APContext: Pointer; const ACompareFunc: TCompareFunction; const AL, AR: NativeInt; const ADepth: Integer);
  var
    I, J: NativeInt;
    pivotIndex: NativeInt;
    pivotValPtr: Pointer;
    SubArrayBasePtr: Pointer;
    SubArrayElemNum: NativeInt;
  begin
    if (AR <= AL) then
      Exit;

    SubArrayElemNum := AR - AL + 1;
    SubArrayBasePtr := RightMovePtr(APBase, AL * AElemSize);

    if SubArrayElemNum <= MINSUBARRLEN then
    begin
      InsertionSort(SubArrayBasePtr, SubArrayElemNum, AElemSize, APContext, ACompareFunc);
      Exit;
    end;

    if ADepth > maxDepth then
    begin
      HybridSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc);
      Exit;
    end;

    pivotIndex := AL + ((AR - AL) shr 1);
    pivotValPtr := RightMovePtr(SubArrayBasePtr, pivotIndex * AElemSize);
    MemSwapFaster(SubArrayBasePtr, pivotValPtr);
    pivotValPtr := SubArrayBasePtr;

    I := AL + 1;
    J := AR;

    repeat
      while (I <= J) and (ACompareFunc(RightMovePtr(APBase, I * AElemSize), pivotValPtr, APContext) < 0) do
        Inc(I);

      while (I <= J) and (ACompareFunc(RightMovePtr(APBase, J * AElemSize), pivotValPtr, APContext) > 0) do
      begin
        if J = AL then
          Break;
        Dec(J);
      end;

      if I <= J then
      begin
        if I <> J then
          MemSwapFaster(RightMovePtr(APBase, I * AElemSize), RightMovePtr(APBase, J * AElemSize));

        Inc(I);
        if J > AL then
          Dec(J)
        else
          Break;
      end;
    until I > J;
    MemSwapFaster(RightMovePtr(APBase, AL * AElemSize), RightMovePtr(APBase, J * AElemSize));

    if AL < J then
      InternalIntrosort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, AL, J - 1, ADepth + 1);

    if I < AR then
      InternalIntrosort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, I, AR, ADepth + 1);
  end;
begin
  if (APBase = nil) or (AElemNum < 2) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  if AElemNum = 0 then
    maxDepth := 0
  else
    maxDepth := 2 * Trunc(Log2(AElemNum)) + 1;

  CreateMemSwapBuffer(AElemSize);
  try
    InternalIntrosort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, 0, AElemNum - 1, 0);
  finally
    DestoryMemSwapBuffer;
  end;
end;

{ Search Functions }

function BinarySearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;
  function GetHalf(AValue: TSize_T): TSize_T;
  begin
    Result := AValue shr 1;
  end;
var
  iA, iB, iMiddle: TSize_T;
begin
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not Assigned(ACompareFunc) then
    Exit(-1);

  if (ACompareFunc(ASearchedElem, APBase, APContext) < 0) or (ACompareFunc(ASearchedElem, RightMovePtr(APBase, (AElemNum - 1) * AElemSize), APContext) > 0) then
    Exit(-1);

  if ACompareFunc(ASearchedElem, APBase, APContext) = 0 then
    Exit(0)
  else if ACompareFunc(ASearchedElem, RightMovePtr(APBase, (AElemNum - 1) * AElemSize), APContext) = 0 then
    Exit(AElemNum - 1);

  iA := 0;
  iB := AElemNum - 1;
  iMiddle := GetHalf(iA + iB);
  while (iMiddle > iA) and (iMiddle < iB) do
  begin
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iMiddle * AElemSize), APContext) = 0 then
    begin
      iA := Max(iMiddle - 1, 0);
      while True do
      begin
        if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iA * AElemSize), APContext) <> 0 then
        begin
          Inc(iA);
          Break;
        end;
        Dec(iA);
      end;
      Exit(iA);
    end
    else if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iMiddle * AElemSize), APContext) < 0 then
      iB := iMiddle
    else
      iA := iMiddle;

    iMiddle := GetHalf(iA + iB);
  end;

  Result := -1;
end;

function BinarySearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TArray<Integer>;
var
  iMiddle, iB, i, iNum, iSize: Integer;
begin
  iMiddle := BinarySearch(APBase, AElemNum, AElemSize, APContext, ASearchedElem, ACompareFunc);
  if iMiddle < 0 then
  begin
    SetLength(Result, 0);
    Exit;
  end;

  iB := Min(iMiddle + 1, AElemNum - 1);
  iNum := AElemNum;
  iSize := AElemSize;
  while iB <= iNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iB * iSize), APContext) <> 0 then
    begin
      Dec(iB);
      Break;
    end;
    Inc(iB);
  end;

  SetLength(Result, iB - iMiddle + 1);
  for i := Low(Result) to High(Result) do
    Result[i] := iMiddle + i;
end;

function SequentialSearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;
var
  iSize, iNum: Integer;
begin
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not Assigned(ACompareFunc) then
    Exit(-1);

  iSize := AElemSize;
  iNum := AElemNum;

  for Result := 0 to iNum - 1 do
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, Result * iSize), APContext) = 0 then
      Exit;

  Result := -1;
end;

function SequentialSearchEx(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction; AOffset: Cardinal = 0): Integer;
var
  i: TSize_T;
begin
  Result := -1;

  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not Assigned(ACompareFunc) then
    Exit(-1);

  for i := 0 to AElemNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, i * AElemSize), APContext) = 0 then
    begin
      if AOffset = 0 then
      begin
        Result := i;
        Exit;
      end
      else
        Dec(AOffset);
    end;
  end;
end;

function SequentialSearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TArray<Integer>;
var
  iIndex, iTemp: TSize_T;
begin
  SetLength(Result, 0);
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not Assigned(ACompareFunc) then
    Exit;

  iTemp := 1;
  for iIndex := 0 to AElemNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iIndex * AElemSize), APContext) = 0 then
    begin
      SetLength(Result, iTemp);
      Inc(iTemp);
      Result[High(Result)] := iIndex;
    end;
  end;
end;

end.