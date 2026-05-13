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
{ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE}
{ SOFTWARE.                                                                    }
{******************************************************************************}

{ Require Version >= Delphi XE4 (Delphi 10.0) }

unit SortFunctionToolUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections, System.TypInfo,
  System.Generics.Defaults;

type
  /// <summary>
  /// Delegate function type for getting an item from a collection at a specific index.
  /// </summary>
  /// <typeparam name="T">Collection type.</typeparam>
  /// <typeparam name="R">Item type.</typeparam>
  /// <param name="AItems">The collection instance to access.</param>
  /// <param name="AIndex">The index to access.</param>
  /// <returns>The value at the specified index.</returns>
  TGetItem<T, R> = reference to function(AItems: T; AIndex: Integer): R;

  /// <summary>
  /// Delegate procedure type for setting an item in a collection at a specific index.
  /// </summary>
  /// <typeparam name="T">Collection type.</typeparam>
  /// <typeparam name="R">Item type.</typeparam>
  /// <param name="AItems">The collection instance to modify (var).</param>
  /// <param name="AItem">The new value to write.</param>
  /// <param name="AIndex">The index to modify.</param>
  TSetItem<T, R> = reference to procedure(var AItems: T; AItem: R; AIndex: Integer);

  /// <summary>
  /// Delegate function type for getting the total count of items in a collection.
  /// </summary>
  /// <typeparam name="T">Collection type.</typeparam>
  /// <param name="AItems">The collection instance to access.</param>
  /// <returns>The number of items in the collection.</returns>
  TGetCount<T> = reference to function(AItems: T): Integer;

  /// <summary>
  /// Interface defining the contract for data access to generic collections.
  /// Enables dynamic binding of read/write operations via delegates.
  /// </summary>
  /// <typeparam name="T">Collection type.</typeparam>
  /// <typeparam name="R">Item type.</typeparam>
  IDataAccessor<T, R> = interface
    ['{D49ADCE1-11B3-45DF-99BA-93FB8DABE1BA}']
    /// <summary>
    /// Gets the item at the specified index in the collection.
    /// </summary>
    /// <param name="AItems">The collection instance.</param>
    /// <param name="AIndex">The index.</param>
    /// <returns>The item R at the specified index.</returns>
    function GetItem(AItems: T; AIndex: Integer): R;
    /// <summary>
    /// Sets the item at the specified index in the collection.
    /// </summary>
    /// <param name="AItems">The collection instance (var).</param>
    /// <param name="AItem">The new value to set.</param>
    /// <param name="AIndex">The index.</param>
    procedure SetItem(var AItems: T; AItem: R; AIndex: Integer);
    /// <summary>
    /// Gets the total count of items in the collection.
    /// </summary>
    /// <param name="AItems">The collection instance.</param>
    /// <returns>The item count.</returns>
    function GetCount(AItems: T): Integer;
  end;

  /// <summary>
  /// Generic base class implementing IDataAccessor interface.
  /// Does not contain specific data access logic; forwards calls via constructor-injected delegates.
  /// </summary>
  /// <typeparam name="T">Collection type.</typeparam>
  /// <typeparam name="R">Item type.</typeparam>
  TDataAccessor<T, R> = class(TInterfacedObject, IDataAccessor<T, R>)
  protected
    /// <summary>
    /// Stores the item getter delegate.
    /// </summary>
    FGetter: TGetItem<T, R>;
    /// <summary>
    /// Stores the item setter delegate.
    /// </summary>
    FSetter: TSetItem<T, R>;
    /// <summary>
    /// Stores the count getter delegate.
    /// </summary>
    FGetCount: TGetCount<T>;
  public
    /// <summary>
    /// Constructor initializing the accessor with injected delegate implementations.
    /// </summary>
    /// <param name="AGetter">The item getter delegate implementation.</param>
    /// <param name="ASetter">The item setter delegate implementation.</param>
    /// <param name="AGetCount">The count getter delegate implementation.</param>
    constructor Create(AGetter: TGetItem<T, R>; ASetter: TSetItem<T, R>; AGetCount: TGetCount<T>);
    /// <summary>
    /// Gets the item at the specified index.
    /// </summary>
    /// <param name="AItems">The collection instance.</param>
    /// <param name="AIndex">The index.</param>
    /// <returns>The item at the specified index.</returns>
    function GetItem(AItems: T; AIndex: Integer): R;
    /// <summary>
    /// Sets the item at the specified index.
    /// </summary>
    /// <param name="AItems">The collection instance (var).</param>
    /// <param name="AItem">The new value to set.</param>
    /// <param name="AIndex">The index.</param>
    procedure SetItem(var AItems: T; AItem: R; AIndex: Integer);
    /// <summary>
    /// Gets the total count of items.
    /// </summary>
    /// <param name="AItems">The collection instance.</param>
    /// <returns>The item count.</returns>
    function GetCount(AItems: T): Integer;
  end;

  /// <summary>
  /// Concrete implementation of TDataAccessor for TStrings collection.
  /// </summary>
  TStringsDataAccessor = class(TDataAccessor<TStrings, string>)
  private
    /// <summary>
    /// GetItem implementation for TStrings.
    /// </summary>
    /// <param name="AItems">The TStrings instance.</param>
    /// <param name="AIndex">The index.</param>
    /// <returns>The string at the specified index.</returns>
    function GetItem(AItems: TStrings; AIndex: Integer): string;
    /// <summary>
    /// SetItem implementation for TStrings.
    /// </summary>
    /// <param name="AItems">The TStrings instance (var).</param>
    /// <param name="AItem">The new value to set.</param>
    /// <param name="AIndex">The index.</param>
    procedure SetItem(var AItems: TStrings; AItem: string; AIndex: Integer);
    /// <summary>
    /// GetCount implementation for TStrings.
    /// </summary>
    /// <param name="AItems">The TStrings instance.</param>
    /// <returns>The count of strings.</returns>
    function GetCount(AItems: TStrings): Integer;
  public
    /// <summary>
    /// Constructor. Automatically registers own methods as parent delegate implementations.
    /// </summary>
    constructor Create();
  end;

  /// <summary>
  /// Concrete implementation of TDataAccessor for native array TArray&lt;R&gt;.
  /// </summary>
  /// <typeparam name="R">Item type.</typeparam>
  TArrayDataAccessor<R> = class(TDataAccessor<TArray<R>, R>)
  private
    /// <summary>
    /// GetItem implementation for TArray&lt;R&gt;.
    /// </summary>
    /// <param name="AItems">The TArray instance.</param>
    /// <param name="AIndex">The index.</param>
    /// <returns>The item at the specified index.</returns>
    function GetItem(AItems: TArray<R>; AIndex: Integer): R;
    /// <summary>
    /// SetItem implementation for TArray&lt;R&gt;.
    /// </summary>
    /// <param name="AItems">The TArray instance (var).</param>
    /// <param name="AItem">The new value to set.</param>
    /// <param name="AIndex">The index.</param>
    procedure SetItem(var AItems: TArray<R>; AItem: R; AIndex: Integer);
    /// <summary>
    /// GetCount implementation for TArray&lt;R&gt;.
    /// </summary>
    /// <param name="AItems">The TArray instance.</param>
    /// <returns>The length of the array.</returns>
    function GetCount(AItems: TArray<R>): Integer;
  public
    /// <summary>
    /// Constructor. Automatically registers own methods as parent delegate implementations.
    /// </summary>
    constructor Create();
  end;

  /// <summary>
  /// Reference type defining a standard generic sorting procedure.
  /// Implements the Strategy pattern, allowing different sorting algorithms to be passed as parameters.
  /// </summary>
  /// <typeparam name="T">Element type of the array to sort.</typeparam>
  /// <param name="AValueArray">The dynamic array to sort (var, passed by reference).</param>
  /// <param name="AComparer">The comparer interface defining element comparison rules.</param>
  /// <param name="AIndex">The starting index for the sort operation.</param>
  /// <param name="ACount">The number of elements to sort from the starting index.</param>
  TSortFunc<T> = reference to procedure(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);

  /// <summary>
  /// Reference type defining a standard generic sorting procedure for custom collections via IDataAccessor.
  /// </summary>
  /// <typeparam name="T">Collection type.</typeparam>
  /// <typeparam name="R">Item type.</typeparam>
  /// <param name="AItems">The collection to sort (var).</param>
  /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
  /// <param name="AComparer">The comparer interface defining item comparison rules.</param>
  /// <param name="AIndex">The starting index.</param>
  /// <param name="ACount">The number of elements to sort.</param>
  TSortFunc<T, R> = reference to procedure(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);

  /// <summary>
  /// Static utility class encapsulating various generic array sorting algorithms.
  /// All methods are class methods that can be called directly without instantiation.
  /// </summary>
  TArraySortUtils = class
  private
    /// <summary>
    /// Constant defining the sub-array length threshold for switching to insertion sort in hybrid algorithms.
    /// When the sub-array length is less than or equal to this value, insertion sort is used.
    /// Typical values are 8, 16, 32. Default is 8.
    /// </summary>
    const
      FMinSubArrLen: Integer = 8;

    class function GetDefaultSortFunc<T>: TSortFunc<T>; overload; static;
    class function CheckSortRangeValid<T>(const AValueArray: array of T; const AIndex, ACount: Integer): Boolean; overload; static;
    class procedure QuickSortHelper<T>(var AValueArray: array of T; AComparer: IComparer<T>; ALeft, ARight: Integer); overload; static;
    class function GetHibbardStepArr(ALength: Integer): TArray<Integer>; static;
    class procedure Merge<T>(var AValueArray, ATempArray: array of T; AComparer: IComparer<T>; AStart, AMid, AEnd: Integer); overload; static;
    class procedure Heapify<T>(var AValueArray: array of T; AComparer: IComparer<T>; ABaseIndex, AHeapSize, ANodeIndex: Integer); overload; static;
    class function Partition<T>(var AValueArray: array of T; AComparer: IComparer<T>; ALeft, ARight: Integer): Integer; overload; static;
    class procedure IntroSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; ALeft, ARight, ADepthLimit: Integer); overload; static;
    class procedure SwapItem<T>(var AValueArray: array of T; ALeftIndex, ARightIndex: Integer; var ASwapBuffer: T); overload; static;

    class function GetDefaultSortFunc<T, R>: TSortFunc<T, R>; overload; static;
    class function CheckSortRangeValid<T, R>(const AItems: T; ADataAccessor: IDataAccessor<T, R>; const AIndex, ACount: Integer): Boolean; overload; static;
    class procedure QuickSortHelper<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight: Integer); overload; static;
    class procedure SwapItem<T, R>(var AItems: T; ASG: IDataAccessor<T, R>; ALeftIndex, ARightIndex: Integer; var ASwapBuffer: R); overload; static; inline;
    class procedure Merge<T, R>(var AItems: T; var ATempArray: TArray<R>; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AStart, AMid, AEnd: Integer); overload; static;
    class procedure Heapify<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ABaseIndex, AHeapSize, ANodeIndex: Integer); overload; static;
    class function Partition<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight: Integer): Integer; overload; static;
    class procedure IntroSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight, ADepthLimit: Integer); overload; static;
  public
    class function GetMinSubArrLen: Integer; static;

    // For Dynamic array
    /// <summary>
    /// Sorts the entire array using the default comparer and default algorithm (QuickSort).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    class procedure Sort<T>(var AValueArray: array of T); overload; static;
    /// <summary>
    /// Sorts the array using the specified comparer and default algorithm (QuickSort).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    class procedure Sort<T>(var AValueArray: array of T; AComparer: IComparer<T>); overload; static;
    /// <summary>
    /// Sorts a range of the array using the specified comparer and default algorithm (QuickSort).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    class procedure Sort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts the entire array using the specified sort function.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="ASortFunc">The sort function to use.</param>
    /// <param name="AValueArray">The array to sort (var).</param>
    class procedure Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array of T); overload; static;
    /// <summary>
    /// Sorts the array using the specified sort function and comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="ASortFunc">The sort function to use.</param>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    class procedure Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array of T; AComparer: IComparer<T>); overload; static;
    /// <summary>
    /// Sorts a range of the array using the specified sort function and comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="ASortFunc">The sort function to use.</param>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    class procedure Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    // Sort Algorithms (Dynamic Array)
    /// <summary>
    /// Sorts a range of the array using Bubble Sort algorithm.
    /// Time complexity: O(n^2), Space: O(1).
    /// Includes an early termination optimization when the array becomes sorted.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// Uses a flag to detect if any swaps occurred in each pass. If no swaps occur,
    /// the array is already sorted and the algorithm terminates early.
    /// Typically used only for educational purposes or very small datasets.
    /// </remarks>
    class procedure BubbleSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using Selection Sort algorithm.
    /// Time complexity: O(n^2) in all cases, Space: O(1).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// Selection Sort has minimal swap operations (at most n-1), but performs
    /// comparisons regardless of input order. Generally not suitable for large datasets.
    /// </remarks>
    class procedure SelectionSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using Insertion Sort algorithm.
    /// Time complexity: O(n^2) worst/average, O(n) best (already sorted), Space: O(1).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// Highly efficient for small arrays or nearly-sorted data.
    /// Often used as the final step in more complex algorithms like QuickSort and MergeSort.
    /// </remarks>
    class procedure InsertionSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using Shell Sort algorithm with Hibbard gap sequence.
    /// Time complexity: approximately O(n^(3/2)) with Hibbard sequence, Space: O(1).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// An improvement over Insertion Sort that allows exchange of items that are
    /// far apart. Uses Hibbard gap sequence: 2^k - 1 (e.g., 63, 31, 15, 7, 3, 1).
    /// </remarks>
    class procedure ShellSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using Quick Sort algorithm with Hoare partition scheme.
    /// Time complexity: O(n log n) average, O(n^2) worst, Space: O(log n).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// Uses middle element as pivot to avoid worst-case performance on sorted/reversed arrays.
    /// The partition function returns the final pivot position (Hoare scheme).
    /// </remarks>
    class procedure QuickSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using Merge Sort algorithm (bottom-up iterative).
    /// Time complexity: O(n log n) in all cases, Space: O(n).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// A stable sorting algorithm that divides the array into sorted subarrays
    /// and merges them. Pre-sorts small subarrays using Insertion Sort for optimization.
    /// </remarks>
    class procedure MergeSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using Heap Sort algorithm.
    /// Time complexity: O(n log n) in all cases, Space: O(1).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// Builds a max-heap in-place, then repeatedly extracts the maximum element.
    /// Not a stable sort but has guaranteed O(n log n) performance.
    /// </remarks>
    class procedure HeapSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using IntroSort algorithm (QuickSort + HeapSort + InsertionSort).
    /// Time complexity: O(n log n) average and worst, Space: O(log n).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// Hybrid algorithm combining QuickSort, HeapSort, and InsertionSort.
    /// Starts with QuickSort, switches to HeapSort when recursion depth exceeds
    /// 2*log2(n), and uses InsertionSort for small subarrays (&lt;= FMinSubArrLen).
    /// Provides excellent all-around performance similar to C++ STL's introsort.
    /// </remarks>
    class procedure IntroSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    /// <summary>
    /// Sorts a range of the array using Hybrid Sort (InsertionSort + MergeSort with HeapSort fallback).
    /// Time complexity: O(n log n), Space: O(n) for MergeSort, O(1) for HeapSort fallback.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to sort (var).</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <remarks>
    /// For small arrays (&lt;= FMinSubArrLen), uses InsertionSort directly.
    /// For larger arrays, attempts MergeSort first; if memory allocation fails
    /// (EOutOfMemory), falls back to HeapSort which is in-place.
    /// </remarks>
    class procedure HybridSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;

    // For Other (via IDataAccessor)
    /// <summary>
    /// Sorts the entire collection using the specified data accessor and comparer.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    class procedure Sort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>); overload; static;
    /// <summary>
    /// Sorts a range of the collection using the specified data accessor and comparer.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure Sort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using the specified sort function, data accessor, and comparer.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="ASortFunc">The sort function to use.</param>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure Sort<T, R>(const ASortFunc: TSortFunc<T, R>; var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;

    // Sort Algorithms (IDataAccessor)
    /// <summary>
    /// Sorts a range of the collection using Bubble Sort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure BubbleSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using Selection Sort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure SelectionSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using Insertion Sort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure InsertionSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using Shell Sort algorithm with Hibbard gap sequence.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure ShellSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using Quick Sort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure QuickSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using Merge Sort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure MergeSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using Heap Sort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure HeapSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using IntroSort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure IntroSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    /// <summary>
    /// Sorts a range of the collection using Hybrid Sort algorithm.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to sort (var).</param>
    /// <param name="ADataAccessor">The data accessor for reading/writing items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to sort.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    class procedure HybridSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;

    // Helper functions
    /// <summary>
    /// Checks if the entire array is sorted according to the comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to check.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <returns>True if the array is sorted, False otherwise.</returns>
    class function CheckIsSorted<T>(AValueArray: array of T; AComparer: IComparer<T>): Boolean; overload; static;
    /// <summary>
    /// Checks if a range of the array is sorted according to the comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to check.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, Length(AValueArray) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to check.
    ///   Valid range: [1, Length(AValueArray) - AIndex].
    /// </param>
    /// <returns>True if the range is sorted, False otherwise.</returns>
    class function CheckIsSorted<T>(AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer): Boolean; overload; static;
    /// <summary>
    /// Checks if the entire collection is sorted according to the comparer.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to check.</param>
    /// <param name="ADataAccessor">The data accessor for reading items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <returns>True if the collection is sorted, False otherwise.</returns>
    class function CheckIsSorted<T, R>(AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>): Boolean; overload; static;
    /// <summary>
    /// Checks if a range of the collection is sorted according to the comparer.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AItems">The collection to check.</param>
    /// <param name="ADataAccessor">The data accessor for reading items.</param>
    /// <param name="AComparer">The comparer interface.</param>
    /// <param name="AIndex">
    ///   The starting index (0-based).
    ///   Valid range: [0, ADataAccessor.GetCount(AItems) - 1].
    /// </param>
    /// <param name="ACount">
    ///   The number of elements to check.
    ///   Valid range: [1, ADataAccessor.GetCount(AItems) - AIndex].
    /// </param>
    /// <returns>True if the range is sorted, False otherwise.</returns>
    class function CheckIsSorted<T, R>(AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer): Boolean; overload; static;
  end;

  /// <summary>
  /// Delegate procedure type for processing a single parameter.
  /// </summary>
  /// <typeparam name="T">Parameter type.</typeparam>
  /// <param name="AParam">The parameter value.</param>
  TSingleProc<T> = reference to procedure(AParam: T);

  /// <summary>
  /// Helper class for list/collection operations.
  /// </summary>
  TListHelperClass = class
  public
    /// <summary>
    /// Iterates through each element in the collection and executes the provided procedure.
    /// </summary>
    /// <typeparam name="T">Collection type.</typeparam>
    /// <typeparam name="R">Item type.</typeparam>
    /// <param name="AList">The collection to iterate.</param>
    /// <param name="ADataAccessor">The data accessor for reading items.</param>
    /// <param name="ADoFunc">The procedure to execute on each element.</param>
    class procedure DoForEach<T, R>(AList: T; ADataAccessor: IDataAccessor<T, R>; ADoFunc: TSingleProc<R>); static;
  end;

implementation

uses
  System.Math, System.Rtti, System.RTLConsts, ExceptionStrConstsUnit;

{ TArraySortUtils }

class function TArraySortUtils.GetMinSubArrLen: Integer;
begin
  Result := FMinSubArrLen;
end;

class function TArraySortUtils.GetDefaultSortFunc<T>: TSortFunc<T>;
begin
  Result := QuickSort<T>;
end;

class function TArraySortUtils.GetDefaultSortFunc<T, R>: TSortFunc<T, R>;
begin
  Result := QuickSort<T, R>;
end;

class function TArraySortUtils.CheckSortRangeValid<T>(const AValueArray: array of T; const AIndex, ACount: Integer): Boolean;
begin
  Result := not ((AIndex < Low(AValueArray)) or ((AIndex > High(AValueArray)) and (ACount > 0)) or (AIndex + ACount - 1 > High(AValueArray)) or (ACount < 0) or (AIndex + ACount < 0));
end;

class function TArraySortUtils.CheckSortRangeValid<T, R>(const AItems: T; ADataAccessor: IDataAccessor<T, R>; const AIndex, ACount: Integer): Boolean;
var
  iMaxIndex: Integer;
begin
  iMaxIndex := ADataAccessor.GetCount(AItems) - 1;
  Result := not ((AIndex < 0) or ((AIndex > iMaxIndex) and (ACount > 0)) or (AIndex + ACount - 1 > iMaxIndex) or (ACount < 0) or (AIndex + ACount < 0));
end;

class procedure TArraySortUtils.SwapItem<T>(var AValueArray: array of T; ALeftIndex, ARightIndex: Integer; var ASwapBuffer: T);
begin
  ASwapBuffer := AValueArray[ALeftIndex];
  AValueArray[ALeftIndex] := AValueArray[ARightIndex];
  AValueArray[ARightIndex] := ASwapBuffer;
end;

class procedure TArraySortUtils.SwapItem<T, R>(var AItems: T; ASG: IDataAccessor<T, R>; ALeftIndex, ARightIndex: Integer; var ASwapBuffer: R);
begin
  ASwapBuffer := ASG.GetItem(AItems, ALeftIndex);
  ASG.SetItem(AItems, ASG.GetItem(AItems, ARightIndex), ALeftIndex);
  ASG.SetItem(AItems, ASwapBuffer, ARightIndex);
end;

class procedure TArraySortUtils.BubbleSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  i, j: Integer;
  bFlag: Boolean;
  SwapBuffer: T;
  LBound, UBound: Integer;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  LBound := AIndex;
  UBound := AIndex + ACount - 1;

  for i := 0 to ACount - 2 do
  begin
    bFlag := False;
    for j := LBound to UBound - 1 - i do
    begin
      if AComparer.Compare(AValueArray[j], AValueArray[j + 1]) > 0 then
      begin
        SwapItem<T>(AValueArray, j, j + 1, SwapBuffer);
        bFlag := True;
      end;
    end;

    if not bFlag then
      Exit;
  end;
end;

class procedure TArraySortUtils.BubbleSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  i, j: Integer;
  bFlag: Boolean;
  SwapBuffer: R;
  LBound, UBound: Integer;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  LBound := AIndex;
  UBound := AIndex + ACount - 1;

  for i := 0 to ACount - 2 do
  begin
    bFlag := False;
    for j := LBound to UBound - 1 - i do
    begin
      if AComparer.Compare(ADataAccessor.GetItem(AItems, j), ADataAccessor.GetItem(AItems, j + 1)) > 0 then
      begin
        SwapItem<T, R>(AItems, ADataAccessor, j, j + 1, SwapBuffer);
        bFlag := True;
      end;
    end;

    if not bFlag then
      Exit;
  end;
end;

class procedure TArraySortUtils.SelectionSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  i, j, iMinIndex, iEndIndex: Integer;
  SwapBuffer: T;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iEndIndex := AIndex + ACount - 1;
  for i := AIndex to iEndIndex - 1 do
  begin
    iMinIndex := i;

    for j := i + 1 to iEndIndex do
    begin
      if AComparer.Compare(AValueArray[j], AValueArray[iMinIndex]) < 0 then
        iMinIndex := j;
    end;

    if iMinIndex <> i then
    begin
      SwapBuffer := AValueArray[i];
      AValueArray[i] := AValueArray[iMinIndex];
      AValueArray[iMinIndex] := SwapBuffer;
    end;
  end;
end;

class procedure TArraySortUtils.SelectionSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  i, j, iMinIndex, iEndIndex: Integer;
  SwapBuffer: R;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iEndIndex := AIndex + ACount - 1;
  for i := AIndex to iEndIndex - 1 do
  begin
    iMinIndex := i;

    for j := i + 1 to iEndIndex do
    begin
      if AComparer.Compare(ADataAccessor.GetItem(AItems, j), ADataAccessor.GetItem(AItems, iMinIndex)) < 0 then
        iMinIndex := j;
    end;

    if iMinIndex <> i then
    begin
      SwapItem<T, R>(AItems, ADataAccessor, iMinIndex, i, SwapBuffer);
    end;
  end;
end;

class procedure TArraySortUtils.InsertionSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  i, j, iEndIndex: Integer;
  KeyBuffer: T;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iEndIndex := AIndex + ACount - 1;

  for i := AIndex + 1 to iEndIndex do
  begin
    KeyBuffer := AValueArray[i];
    j := i;

    while (j > AIndex) and (AComparer.Compare(KeyBuffer, AValueArray[j - 1]) < 0) do
    begin
      AValueArray[j] := AValueArray[j - 1];
      Dec(j);
    end;

    AValueArray[j] := KeyBuffer;
  end;
end;

class procedure TArraySortUtils.InsertionSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  i, j, iEndIndex: Integer;
  KeyBuffer: R;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iEndIndex := AIndex + ACount - 1;

  for i := AIndex + 1 to iEndIndex do
  begin
    KeyBuffer := ADataAccessor.GetItem(AItems, i);
    j := i;

    while (j > AIndex) and (AComparer.Compare(KeyBuffer, ADataAccessor.GetItem(AItems, j - 1)) < 0) do
    begin
      ADataAccessor.SetItem(AItems, ADataAccessor.GetItem(AItems, j - 1), j);
      Dec(j);
    end;
    ADataAccessor.SetItem(AItems, KeyBuffer, j);
  end;
end;

class function TArraySortUtils.GetHibbardStepArr(ALength: Integer): TArray<Integer>;
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

class procedure TArraySortUtils.ShellSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  i, j, Step, iEndIndex, StepIndex: Integer;
  TempElement: T;
  aHibbardStepArr: TArray<Integer>;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iEndIndex := AIndex + ACount - 1;

  aHibbardStepArr := GetHibbardStepArr(ACount);

  for StepIndex := Low(aHibbardStepArr) to High(aHibbardStepArr) do
  begin
    Step := aHibbardStepArr[StepIndex];

    for i := AIndex + Step to iEndIndex do
    begin
      TempElement := AValueArray[i];
      j := i;

      while (j >= AIndex + Step) and (AComparer.Compare(TempElement, AValueArray[j - Step]) < 0) do
      begin
        AValueArray[j] := AValueArray[j - Step];
        j := j - Step;
      end;

      AValueArray[j] := TempElement;
    end;
  end;
end;

class procedure TArraySortUtils.ShellSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  i, j, Step, iEndIndex, StepIndex: Integer;
  TempElement: R;
  aHibbardStepArr: TArray<Integer>;
begin
  if ACount <= 1 then
    Exit;

  iEndIndex := AIndex + ACount - 1;

  aHibbardStepArr := GetHibbardStepArr(ACount);

  for StepIndex := Low(aHibbardStepArr) to High(aHibbardStepArr) do
  begin
    Step := aHibbardStepArr[StepIndex];

    for i := AIndex + Step to iEndIndex do
    begin
      TempElement := ADataAccessor.GetItem(AItems, i);
      j := i;

      while (j >= AIndex + Step) and (AComparer.Compare(TempElement, ADataAccessor.GetItem(AItems, j - Step)) < 0) do
      begin
        ADataAccessor.SetItem(AItems, ADataAccessor.GetItem(AItems, j - Step), j);
        j := j - Step;
      end;
      ADataAccessor.SetItem(AItems, TempElement, j);
    end;
  end;
end;

class function TArraySortUtils.Partition<T>(var AValueArray: array of T; AComparer: IComparer<T>; ALeft, ARight: Integer): Integer;
var
  i, j: Integer;
  Pivot, SwapBuffer: T;
begin
  Pivot := AValueArray[ALeft + (ARight - ALeft) shr 1];
  i := ALeft - 1;
  j := ARight + 1;

  while True do
  begin
    repeat
      Inc(i);
    until AComparer.Compare(AValueArray[i], Pivot) >= 0;

    repeat
      Dec(j);
    until AComparer.Compare(AValueArray[j], Pivot) <= 0;

    if i >= j then
      Exit(j);

    SwapBuffer := AValueArray[i];
    AValueArray[i] := AValueArray[j];
    AValueArray[j] := SwapBuffer;
  end;
end;

class function TArraySortUtils.Partition<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight: Integer): Integer;
var
  i, j: Integer;
  Pivot, SwapBuffer: R;
begin
  Pivot := ADataAccessor.GetItem(AItems, ALeft + (ARight - ALeft) shr 1);
  i := ALeft - 1;
  j := ARight + 1;

  while True do
  begin
    repeat
      Inc(i);
    until AComparer.Compare(ADataAccessor.GetItem(AItems, i), Pivot) >= 0;

    repeat
      Dec(j);
    until AComparer.Compare(ADataAccessor.GetItem(AItems, j), Pivot) <= 0;

    if i >= j then
      Exit(j);

    SwapItem<T, R>(AItems, ADataAccessor, i, j, SwapBuffer);
  end;
end;

class procedure TArraySortUtils.QuickSortHelper<T>(var AValueArray: array of T; AComparer: IComparer<T>; ALeft, ARight: Integer);
var
  i, j: Integer;
  Pivot, Temp: T;
begin
  if (Length(AValueArray) = 0) or ((ARight - ALeft) <= 0) then
    Exit;
  repeat
    i := ALeft;
    j := ARight;
    Pivot := AValueArray[ALeft + (ARight - ALeft) shr 1];
    repeat
      while AComparer.Compare(AValueArray[i], Pivot) < 0 do
        Inc(i);
      while AComparer.Compare(AValueArray[j], Pivot) > 0 do
        Dec(j);
      if i <= j then
      begin
        if i <> j then
        begin
          Temp := AValueArray[i];
          AValueArray[i] := AValueArray[j];
          AValueArray[j] := Temp;
        end;
        Inc(i);
        Dec(j);
      end;
    until i > j;
    if ALeft < j then
      QuickSortHelper<T>(AValueArray, AComparer, ALeft, j);
    ALeft := i;
  until i >= ARight
end;

class procedure TArraySortUtils.QuickSortHelper<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight: Integer);
var
  i, j: Integer;
  Pivot, Temp: R;
begin
  if (ADataAccessor.GetCount(AItems) = 0) or ((ARight - ALeft) <= 0) then
    Exit;
  repeat
    i := ALeft;
    j := ARight;
    Pivot := ADataAccessor.GetItem(AItems, ALeft + (ARight - ALeft) shr 1);
    repeat
      while AComparer.Compare(ADataAccessor.GetItem(AItems, i), Pivot) < 0 do
        Inc(i);
      while AComparer.Compare(ADataAccessor.GetItem(AItems, j), Pivot) > 0 do
        Dec(j);
      if i <= j then
      begin
        if i <> j then
        begin
          SwapItem<T, R>(AItems, ADataAccessor, i, j, Temp);
        end;
        Inc(i);
        Dec(j);
      end;
    until i > j;
    if ALeft < j then
      QuickSortHelper<T, R>(AItems, ADataAccessor, AComparer, ALeft, j);
    ALeft := i;
  until i >= ARight
end;

class procedure TArraySortUtils.QuickSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;
  QuickSortHelper<T>(AValueArray, AComparer, AIndex, AIndex + ACount - 1);
end;

class procedure TArraySortUtils.QuickSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;
  QuickSortHelper<T, R>(AItems, ADataAccessor, AComparer, AIndex, AIndex + ACount - 1);
end;

class procedure TArraySortUtils.Merge<T>(var AValueArray: array of T; var ATempArray: array of T; AComparer: IComparer<T>; AStart, AMid, AEnd: Integer);
var
  i, j, k: Integer;
begin
  i := AStart;
  j := AMid + 1;
  k := 0;

  while (i <= AMid) and (j <= AEnd) do
  begin
    if AComparer.Compare(AValueArray[i], AValueArray[j]) <= 0 then
    begin
      ATempArray[k] := AValueArray[i];
      Inc(i);
    end
    else
    begin
      ATempArray[k] := AValueArray[j];
      Inc(j);
    end;
    Inc(k);
  end;

  while i <= AMid do
  begin
    ATempArray[k] := AValueArray[i];
    Inc(i);
    Inc(k);
  end;

  while j <= AEnd do
  begin
    ATempArray[k] := AValueArray[j];
    Inc(j);
    Inc(k);
  end;

  for i := 0 to k - 1 do
    AValueArray[AStart + i] := ATempArray[i];
end;

class procedure TArraySortUtils.Merge<T, R>(var AItems: T; var ATempArray: TArray<R>; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AStart, AMid, AEnd: Integer);
var
  i, j, k: Integer;
begin
  i := AStart;
  j := AMid + 1;
  k := 0;

  while (i <= AMid) and (j <= AEnd) do
  begin
    if AComparer.Compare(ADataAccessor.GetItem(AItems, i), ADataAccessor.GetItem(AItems, j)) <= 0 then
    begin
      ATempArray[k] := ADataAccessor.GetItem(AItems, i);
      Inc(i);
    end
    else
    begin
      ATempArray[k] := ADataAccessor.GetItem(AItems, j);
      Inc(j);
    end;
    Inc(k);
  end;

  while i <= AMid do
  begin
    ATempArray[k] := ADataAccessor.GetItem(AItems, i);
    Inc(i);
    Inc(k);
  end;

  while j <= AEnd do
  begin
    ATempArray[k] := ADataAccessor.GetItem(AItems, j);
    Inc(j);
    Inc(k);
  end;

  for i := 0 to k - 1 do
    ADataAccessor.SetItem(AItems, ATempArray[i], AStart + i);
end;

class procedure TArraySortUtils.MergeSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  i, iWidth, iLeft, iMid, iRight, iEndIndex: Integer;
  iMinSubArrLen: Integer;
  TempArray: TArray<T>;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iMinSubArrLen := GetMinSubArrLen();
  iEndIndex := AIndex + ACount - 1;

  i := AIndex;
  while i <= iEndIndex do
  begin
    iRight := Min(i + iMinSubArrLen - 1, iEndIndex);
    InsertionSort<T>(AValueArray, AComparer, i, iRight - i + 1);
    i := i + iMinSubArrLen;
  end;

  SetLength(TempArray, ACount);
  iWidth := iMinSubArrLen;
  while iWidth < ACount do
  begin
    i := AIndex;
    while i <= iEndIndex do
    begin
      iLeft := i;
      iMid := i + iWidth - 1;
      iRight := Min(i + 2 * iWidth - 1, iEndIndex);

      if iMid < iRight then
      begin
        Merge<T>(AValueArray, TempArray, AComparer, iLeft, iMid, iRight);
      end;

      i := i + 2 * iWidth;
    end;
    iWidth := iWidth * 2;
  end;
end;

class procedure TArraySortUtils.MergeSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  i, iWidth, iLeft, iMid, iRight, iEndIndex: Integer;
  iMinSubArrLen: Integer;
  TempArray: TArray<R>;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iMinSubArrLen := GetMinSubArrLen();
  iEndIndex := AIndex + ACount - 1;

  i := AIndex;
  while i <= iEndIndex do
  begin
    iRight := Min(i + iMinSubArrLen - 1, iEndIndex);
    InsertionSort<T, R>(AItems, ADataAccessor, AComparer, i, iRight - i + 1);
    i := i + iMinSubArrLen;
  end;

  SetLength(TempArray, ACount);
  iWidth := iMinSubArrLen;
  while iWidth < ACount do
  begin
    i := AIndex;
    while i <= iEndIndex do
    begin
      iLeft := i;
      iMid := i + iWidth - 1;
      iRight := Min(i + 2 * iWidth - 1, iEndIndex);

      if iMid < iRight then
      begin
        Merge<T, R>(AItems, TempArray, ADataAccessor, AComparer, iLeft, iMid, iRight);
      end;

      i := i + 2 * iWidth;
    end;
    iWidth := iWidth * 2;
  end;
end;

class procedure TArraySortUtils.Heapify<T>(var AValueArray: array of T; AComparer: IComparer<T>; ABaseIndex, AHeapSize, ANodeIndex: Integer);
var
  CurrentIndex, LargestIndex, LeftChildIndex, RightChildIndex: Integer;
  SwapBuffer: T;
begin
  CurrentIndex := ANodeIndex;
  while True do
  begin
    LargestIndex := CurrentIndex;
    LeftChildIndex := 2 * CurrentIndex + 1;
    RightChildIndex := 2 * CurrentIndex + 2;

    if (LeftChildIndex < AHeapSize) and (AComparer.Compare(AValueArray[ABaseIndex + LeftChildIndex], AValueArray[ABaseIndex + LargestIndex]) > 0) then
    begin
      LargestIndex := LeftChildIndex;
    end;

    if (RightChildIndex < AHeapSize) and (AComparer.Compare(AValueArray[ABaseIndex + RightChildIndex], AValueArray[ABaseIndex + LargestIndex]) > 0) then
    begin
      LargestIndex := RightChildIndex;
    end;

    if LargestIndex <> CurrentIndex then
    begin
      SwapBuffer := AValueArray[ABaseIndex + CurrentIndex];
      AValueArray[ABaseIndex + CurrentIndex] := AValueArray[ABaseIndex + LargestIndex];
      AValueArray[ABaseIndex + LargestIndex] := SwapBuffer;

      CurrentIndex := LargestIndex;
    end
    else
      Break;
  end;
end;

class procedure TArraySortUtils.Heapify<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ABaseIndex, AHeapSize, ANodeIndex: Integer);
var
  CurrentIndex, LargestIndex, LeftChildIndex, RightChildIndex: Integer;
  SwapBuffer: R;
begin
  CurrentIndex := ANodeIndex;
  while True do
  begin
    LargestIndex := CurrentIndex;
    LeftChildIndex := 2 * CurrentIndex + 1;
    RightChildIndex := 2 * CurrentIndex + 2;

    if (LeftChildIndex < AHeapSize) and (AComparer.Compare(ADataAccessor.GetItem(AItems, ABaseIndex + LeftChildIndex), ADataAccessor.GetItem(AItems, ABaseIndex + LargestIndex)) > 0) then
    begin
      LargestIndex := LeftChildIndex;
    end;

    if (RightChildIndex < AHeapSize) and (AComparer.Compare(ADataAccessor.GetItem(AItems, ABaseIndex + RightChildIndex), ADataAccessor.GetItem(AItems, ABaseIndex + LargestIndex)) > 0) then
    begin
      LargestIndex := RightChildIndex;
    end;

    if LargestIndex <> CurrentIndex then
    begin
      SwapItem<T, R>(AItems, ADataAccessor, ABaseIndex + CurrentIndex, ABaseIndex + LargestIndex, SwapBuffer);

      CurrentIndex := LargestIndex;
    end
    else
      Break;
  end;
end;

class procedure TArraySortUtils.HeapSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  i: Integer;
  SwapBuffer: T;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  for i := (ACount div 2) - 1 downto 0 do
    Heapify<T>(AValueArray, AComparer, AIndex, ACount, i);

  for i := ACount - 1 downto 1 do
  begin
    SwapBuffer := AValueArray[AIndex];
    AValueArray[AIndex] := AValueArray[AIndex + i];
    AValueArray[AIndex + i] := SwapBuffer;

    Heapify<T>(AValueArray, AComparer, AIndex, i, 0);
  end;
end;

class procedure TArraySortUtils.HeapSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  i: Integer;
  SwapBuffer: R;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;
  for i := (ACount div 2) - 1 downto 0 do
    Heapify<T, R>(AItems, ADataAccessor, AComparer, AIndex, ACount, i);

  for i := ACount - 1 downto 1 do
  begin
    SwapItem<T, R>(AItems, ADataAccessor, AIndex, AIndex + i, SwapBuffer);

    Heapify<T, R>(AItems, ADataAccessor, AComparer, AIndex, i, 0);
  end;
end;

class procedure TArraySortUtils.IntroSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  DepthLimit: Integer;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  if ACount = 0 then
    DepthLimit := 0
  else
    DepthLimit := 2 * Trunc(Log2(ACount));

  IntroSort<T>(AValueArray, AComparer, AIndex, AIndex + ACount - 1, DepthLimit);
end;

class procedure TArraySortUtils.IntroSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  DepthLimit: Integer;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  if ACount = 0 then
    DepthLimit := 0
  else
    DepthLimit := 2 * Trunc(Log2(ACount));

  IntroSort<T, R>(AItems, ADataAccessor, AComparer, AIndex, AIndex + ACount - 1, DepthLimit);
end;

class procedure TArraySortUtils.IntroSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; ALeft, ARight, ADepthLimit: Integer);
var
  PartitionIndex: Integer;
begin
  while (ARight - ALeft + 1) > GetMinSubArrLen() do
  begin
    if ADepthLimit <= 0 then
    begin
      HeapSort<T>(AValueArray, AComparer, ALeft, ARight - ALeft + 1);
      Exit;
    end;

    PartitionIndex := Partition<T>(AValueArray, AComparer, ALeft, ARight);

    if (PartitionIndex - ALeft) < (ARight - PartitionIndex) then
    begin
      IntroSort<T>(AValueArray, AComparer, ALeft, PartitionIndex, ADepthLimit - 1);
      ALeft := PartitionIndex + 1;
    end
    else
    begin
      IntroSort<T>(AValueArray, AComparer, PartitionIndex + 1, ARight, ADepthLimit - 1);
      ARight := PartitionIndex;
    end;
  end;

  if ARight > ALeft then
    InsertionSort<T>(AValueArray, AComparer, ALeft, ARight - ALeft + 1);
end;

class procedure TArraySortUtils.IntroSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight, ADepthLimit: Integer);
var
  PartitionIndex: Integer;
begin
  while (ARight - ALeft + 1) > GetMinSubArrLen() do
  begin
    if ADepthLimit <= 0 then
    begin
      HeapSort<T, R>(AItems, ADataAccessor, AComparer, ALeft, ARight - ALeft + 1);
      Exit;
    end;

    PartitionIndex := Partition<T, R>(AItems, ADataAccessor, AComparer, ALeft, ARight);

    if (PartitionIndex - ALeft) < (ARight - PartitionIndex) then
    begin
      IntroSort<T, R>(AItems, ADataAccessor, AComparer, ALeft, PartitionIndex, ADepthLimit - 1);
      ALeft := PartitionIndex + 1;
    end
    else
    begin
      IntroSort<T, R>(AItems, ADataAccessor, AComparer, PartitionIndex + 1, ARight, ADepthLimit - 1);
      ARight := PartitionIndex;
    end;
  end;

  if ARight > ALeft then
    InsertionSort<T, R>(AItems, ADataAccessor, AComparer, ALeft, ARight - ALeft + 1);
end;

class procedure TArraySortUtils.HybridSort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  TempArray: TArray<T>;
  iMinSubArrLen: Integer;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iMinSubArrLen := GetMinSubArrLen();

  if ACount <= iMinSubArrLen then
  begin
    InsertionSort<T>(AValueArray, AComparer, AIndex, ACount);
    Exit;
  end;

  try
    SetLength(TempArray, ACount);
    MergeSort<T>(AValueArray, AComparer, AIndex, ACount);
  except
    on EOutOfMemory do
    begin
      HeapSort<T>(AValueArray, AComparer, AIndex, ACount);
    end
    else
      raise;
  end;
end;

class procedure TArraySortUtils.HybridSort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
var
  TempArray: TArray<R>;
  iMinSubArrLen: Integer;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  iMinSubArrLen := GetMinSubArrLen();

  if ACount <= iMinSubArrLen then
  begin
    InsertionSort<T, R>(AItems, ADataAccessor, AComparer, AIndex, ACount);
    Exit;
  end;

  try
    SetLength(TempArray, ACount);
    MergeSort<T, R>(AItems, ADataAccessor, AComparer, AIndex, ACount);
  except
    on EOutOfMemory do
    begin
      HeapSort<T, R>(AItems, ADataAccessor, AComparer, AIndex, ACount);
    end
    else
      raise;
  end;
end;

class procedure TArraySortUtils.Sort<T>(var AValueArray: array of T);
begin
  Sort<T>(GetDefaultSortFunc<T>(), AValueArray, TComparer<T>.Default, 0, Length(AValueArray));
end;

class procedure TArraySortUtils.Sort<T>(var AValueArray: array of T; AComparer: IComparer<T>);
begin
  Sort<T>(GetDefaultSortFunc<T>(), AValueArray, AComparer, 0, Length(AValueArray));
end;

class procedure TArraySortUtils.Sort<T>(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
begin
  Sort<T>(GetDefaultSortFunc<T>(), AValueArray, AComparer, AIndex, ACount);
end;

class procedure TArraySortUtils.Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array of T);
begin
  Sort<T>(ASortFunc, AValueArray, TComparer<T>.Default, 0, Length(AValueArray));
end;

class procedure TArraySortUtils.Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array of T; AComparer: IComparer<T>);
begin
  Sort<T>(ASortFunc, AValueArray, AComparer, 0, Length(AValueArray));
end;

class procedure TArraySortUtils.Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
begin
  ASortFunc(AValueArray, AComparer, AIndex, ACount);
end;

class procedure TArraySortUtils.Sort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>);
begin
  Sort<T, R>(GetDefaultSortFunc<T, R>(), AItems, ADataAccessor, AComparer, 0, ADataAccessor.GetCount(AItems));
end;

class procedure TArraySortUtils.Sort<T, R>(var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
begin
  Sort<T, R>(GetDefaultSortFunc<T, R>(), AItems, ADataAccessor, AComparer, AIndex, ACount);
end;

class procedure TArraySortUtils.Sort<T, R>(const ASortFunc: TSortFunc<T, R>; var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
begin
  ASortFunc(AItems, ADataAccessor, AComparer, AIndex, ACount);
end;

class function TArraySortUtils.CheckIsSorted<T>(AValueArray: array of T; AComparer: IComparer<T>): Boolean;
begin
  CheckIsSorted<T>(AValueArray, AComparer, Low(AValueArray), Length(AValueArray));
end;

class function TArraySortUtils.CheckIsSorted<T>(AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
  begin
    Result := True;
    Exit;
  end;
  Result := True;
end;

class function TArraySortUtils.CheckIsSorted<T, R>(AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>): Boolean;
begin
  CheckIsSorted<T, R>(AItems, ADataAccessor, AComparer, 0, ADataAccessor.GetCount(AItems));
end;

class function TArraySortUtils.CheckIsSorted<T, R>(AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
  begin
    Result := False;
    Exit;
  end;

  for i := AIndex to AIndex + ACount - 1 do
  begin
    if AComparer.Compare(ADataAccessor.GetItem(AItems, i), ADataAccessor.GetItem(AItems, i)) > 0 then
      Exit;
  end;
  Result := True;
end;

{ TDataAccessor }

constructor TDataAccessor<T, R>.Create(AGetter: TGetItem<T, R>; ASetter: TSetItem<T, R>; AGetCount: TGetCount<T>);
begin
  if not Assigned(AGetter) or not Assigned(ASetter) or not Assigned(AGetCount) then
  begin
    raise EArgumentException.Create('DataAccessor requires all Getter, Setter, and Count delegates to be provided during construction!');
  end;

  FGetter := AGetter;
  FSetter := ASetter;
  FGetCount := AGetCount;
end;

function TDataAccessor<T, R>.GetCount(AItems: T): Integer;
begin
  if Assigned(FGetCount) then
    Result := FGetCount(AItems);
end;

function TDataAccessor<T, R>.GetItem(AItems: T; AIndex: Integer): R;
begin
  if Assigned(FGetter) then
    Result := FGetter(AItems, AIndex);
end;

procedure TDataAccessor<T, R>.SetItem(var AItems: T; AItem: R; AIndex: Integer);
begin
  if Assigned(FSetter) then
    FSetter(AItems, AItem, AIndex);
end;

{ TStringsDataAccessor }

constructor TStringsDataAccessor.Create();
begin
  inherited Create(
    Self.GetItem,
    Self.SetItem,
    Self.GetCount
  );
end;

function TStringsDataAccessor.GetCount(AItems: TStrings): Integer;
begin
  Result := AItems.Count;
end;

function TStringsDataAccessor.GetItem(AItems: TStrings; AIndex: Integer): string;
begin
  Result := AItems[AIndex];
end;

procedure TStringsDataAccessor.SetItem(var AItems: TStrings; AItem: string; AIndex: Integer);
begin
  AItems[AIndex] := AItem;
end;

{ TArrayDataAccessor<R> }

constructor TArrayDataAccessor<R>.Create();
begin
  inherited Create(
    Self.GetItem,
    Self.SetItem,
    Self.GetCount
  );
end;

function TArrayDataAccessor<R>.GetCount(AItems: TArray<R>): Integer;
begin
  Result := Length(AItems);
end;

function TArrayDataAccessor<R>.GetItem(AItems: TArray<R>; AIndex: Integer): R;
begin
  Result := AItems[AIndex];
end;

procedure TArrayDataAccessor<R>.SetItem(var AItems: TArray<R>; AItem: R; AIndex: Integer);
begin
  AItems[AIndex] := AItem;
end;

{ TListHelperClass }

class procedure TListHelperClass.DoForEach<T, R>(AList: T; ADataAccessor: IDataAccessor<T, R>; ADoFunc: TSingleProc<R>);
var
  i: Integer;
begin
  for i := 0 to ADataAccessor.GetCount(AList) - 1 do
  begin
    ADoFunc(ADataAccessor.GetItem(AList, i));
  end;
end;

end.