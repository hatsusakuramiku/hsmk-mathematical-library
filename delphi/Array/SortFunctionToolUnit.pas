{******************************************************************************}
{                       Copyright  2025 hatsusakuramiku                        }
{                                                                              }
{                              MIT LICENSE                                     }
{ Permission is hereby granted, free of charge, to any person obtaining a copy }
{ of this software and associated documentation files (the "Software"), to deal}
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
{ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  }
{ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE}
{ SOFTWARE.                                                                    }
{******************************************************************************}

{* Require Version >= Delphi XE4(Delphi 10.0) *}
unit SortFunctionToolUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections, System.TypInfo,
  System.Generics.Defaults;

{* PurePascal Sort Function *}
type
  TGetItem<T, R> = reference to function(AItems: T; AIndex: Integer): R;
  TSetItem<T, R> = reference to procedure(var AItems: T; AItem: R; AIndex:
    Integer);
  TGetCount<T> = reference to function(AItems: T): Integer;

  IDataAccessor<T, R> = interface
    function GetItem(AItems: T; AIndex: Integer): R;
    procedure SetItem(var AItems: T; AItem: R; AIndex: Integer);
    function GetCount(AItems: T): Integer;
  end;

  TDataAccessor<T, R> = class(TInterfacedObject, IDataAccessor<T, R>)
  private
    FGetter: TGetItem<T, R>;
    FSetter: TSetItem<T, R>;
    FGetCount: TGetCount<T>;
  public
    function GetItem(AItems: T; AIndex: Integer): R; virtual;
    procedure SetItem(var AItems: T; AItem: R; AIndex: Integer); virtual;
    function GetCount(AItems: T): Integer; virtual;
    constructor Create(AGetter: TGetItem<T, R>; ASetter: TSetItem<T, R>;
      AGetCount: TGetCount<T>);
  end;

  // 类型定义： TSortFunc<T>
  // 功能： 定义了一个标准的泛型排序过程的引用类型。
  //       这是一个“策略模式”的体现，允许动态地将不同的排序算法作为参数传递。
  // 泛型参数: T - 待排序数组中元素的类型。
  // 签名： procedure(var AValueArray: array of T; AComparer: IComparer<T>; AIndex, ACount: Integer);
  //      - AValueArray: 要排序的动态数组，使用 var 关键字表示引用传递，可以直接修改。
  //      - AComparer: 比较器接口，用于定义元素T的比较规则。
  //      - AIndex: 排序操作的起始索引。
  //      - ACount: 从起始索引开始，需要排序的元素数量。
  TSortFunc<T> = reference to procedure(var AValueArray: array of T; AComparer:
    IComparer<T>; AIndex, ACount: Integer);
  TSortFunc<T, R> = reference to procedure(var AItems: T; ADataAccessor:
    IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);

  // 类名： TArraySortUtils
  // 功能： 一个静态工具类（Static Class），封装了多种通用的泛型数组排序算法。
  // 备注： 所有方法均为类方法（Class Function/Procedure），无需创建类的实例即可直接调用，例如 TArraySortUtils.Sort<Integer>(MyArray)。
  //       提供了重载的 Sort 方法，方便用户以不同方式调用，并支持传入自定义的排序算法实现。
  TArraySortUtils = class
  private
    // 常量：FMinSubArrLen
    // 功能：定义混合排序算法中，切换到插入排序的子数组长度阈值。
    // 备注：当待排序的子数组长度小于或等于此值时，将使用插入排序。
    //      因为对于小规模或基本有序的数组，插入排序的开销更小，性能更好。通常取值为8, 16, 32等。
    const FMinSubArrLen: Integer = 8;

      // For Dynamic array
    class function GetDefaultSortFunc<T>: TSortFunc<T>; overload; static;
    class function CheckSortRangeValid<T>(const AValueArray: array of T; const
      AIndex, ACount: Integer): Boolean; overload; static;
    class procedure QuickSortHelper<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; ALeft, ARight: Integer); overload; static;
    class function GetHibbardStepArr(ALength: Integer): TArray<Integer>; static;
    class procedure Merge<T>(var AValueArray, ATempArray: array of T; AComparer:
      IComparer<T>; AStart, AMid, AEnd: Integer); overload; static;
    class procedure Heapify<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; ABaseIndex, AHeapSize, ANodeIndex: Integer); overload; static;
    class function Partition<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; ALeft, ARight: Integer): Integer; overload; static;
    class procedure IntroSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; ALeft, ARight, ADepthLimit: Integer); overload; static;
    class procedure SwapItem<T>(var AValueArray: array of T; ALeftIndex,
      ARightIndex: Integer; var ASwapBuffer: T); overload; static;

    // For Other
    class function GetDefaultSortFunc<T, R>: TSortFunc<T, R>; overload; static;
    class function CheckSortRangeValid<T, R>(const AItems: T; ADataAccessor:
      IDataAccessor<T, R>; const AIndex, ACount: Integer): Boolean; overload;
      static;
    class procedure QuickSortHelper<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight: Integer);
      overload; static;
    class procedure SwapItem<T, R>(var AItems: T; ASG: IDataAccessor<T, R>;
      ALeftIndex, ARightIndex: Integer; var ASwapBuffer: R); overload; static;
      inline;
    class procedure Merge<T, R>(var AItems: T; var ATempArray: TArray<R>;
      ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AStart, AMid,
      AEnd: Integer); overload; static;
    class procedure Heapify<T, R>(var AItems: T; ADataAccessor: IDataAccessor < T,
      R > ; AComparer: IComparer<R>; ABaseIndex, AHeapSize, ANodeIndex: Integer);
      overload; static;
    class function Partition<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight: Integer):
      Integer; overload; static;
    class procedure IntroSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight, ADepthLimit:
      Integer); overload; static;
  public
    // For Dynamic array
    class function GetMinSubArrLen: Integer; static;
    class procedure Sort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure Sort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>); overload; static;
    class procedure Sort<T>(var AValueArray: array of T); overload; static;
    class procedure Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array
      of T; AComparer: IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array
      of T; AComparer: IComparer<T>); overload; static;
    class procedure Sort<T>(const ASortFunc: TSortFunc<T>; var AValueArray: array
      of T); overload; static;

    // Sort Algorithm
    class procedure HybridSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure QuickSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure MergeSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure HeapSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure InsertionSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure SelectionSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure BubbleSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure IntroSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;
    class procedure ShellSort<T>(var AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer); overload; static;

    // For Other
    class procedure Sort<T, R>(var AItems: T; ADataAccessor: IDataAccessor < T,
      R > ; AComparer: IComparer<R>; AIndex, ACount: Integer); overload; static;
    class procedure Sort<T, R>(const ASortFunc: TSortFunc<T, R>; var AItems: T;
      ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount:
      Integer); overload; static;

    class procedure HybridSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure QuickSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure MergeSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure HeapSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure InsertionSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure SelectionSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure BubbleSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure IntroSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;
    class procedure ShellSort<T, R>(var AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
      overload; static;

    // Other helper function
    class function CheckIsSorted<T>(AValueArray: array of T; AComparer:
      IComparer<T>; AIndex, ACount: Integer): Boolean; overload; static;
    class function CheckIsSorted<T>(AValueArray: array of T; AComparer:
      IComparer<T>): Boolean; overload; static;
    class function CheckIsSorted<T, R>(AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer):
      Boolean; overload; static;
    class function CheckIsSorted<T, R>(AItems: T; ADataAccessor:
      IDataAccessor<T, R>; AComparer: IComparer<R>): Boolean; overload; static;
  end;

  {* C-Like Sort Function *}

implementation

uses
  System.Math, System.Rtti, System.RTLConsts, ExceptionStrConstsUnit;

{ TArraySortUtils }

// 功能：对数组的指定范围使用冒泡排序（Bubble Sort）进行排序。
// 复杂度：时间 O(n^2)，空间 O(1)。
// 备注：实现中加入了有序标记（bFlag），若在一轮比较中未发生任何交换，则说明数组已有序，可提前终止。
//       这是一种基础排序算法，效率较低，通常仅用于教学或数据量极小的情况。
// 参数:
//  - AValueArray: array of T, 待排序数组（引用传递）。
//  - AComparer: IComparer<T>, 比较器接口，定义元素比较逻辑。
//  - AIndex: Integer, 排序的起始索引。
//  - ACount: Integer, 排序元素的数量。
class procedure TArraySortUtils.BubbleSort<T, R>(var AItems: T; ADataAccessor:
  IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex, ACount: Integer);
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
      if AComparer.Compare(ADataAccessor.GetItem(AItems, j),
        ADataAccessor.GetItem(AItems, j + 1)) > 0 then
      begin
        SwapItem<T, R>(AItems, ADataAccessor, j, j + 1, SwapBuffer);
        bFlag := True;
      end;
    end;

    if not bFlag then
      Exit;
  end;
end;

// 功能：对数组的指定范围使用冒泡排序（Bubble Sort）进行排序。
// 复杂度：时间 O(n^2)，空间 O(1)。
// 备注：实现中加入了有序标记（bFlag），若在一轮比较中未发生任何交换，则说明数组已有序，可提前终止。
//       这是一种基础排序算法，效率较低，通常仅用于教学或数据量极小的情况。
// 参数:
//  - AValueArray: array of T, 待排序数组（引用传递）。
//  - AComparer: IComparer<T>, 比较器接口，定义元素比较逻辑。
//  - AIndex: Integer, 排序的起始索引。
//  - ACount: Integer, 排序元素的数量。
class procedure TArraySortUtils.BubbleSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
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

// 功能：检查提供给排序函数的参数（数组、起始索引、数量）是否有效。
// 备注：这是一个健壮性检查，防止因无效参数（如索引越界、负数数量）导致运行时错误。
//       const 关键字表示按常量引用传递，避免不必要的数据复制，提高效率。
// 参数:
//  - AValueArray: const array of T, 待检查的数组。
//  - AIndex: const Integer, 起始索引。
//  - ACount: const Integer, 元素数量。
// 返回值：Boolean, 如果参数均在合法范围内，则返回 True，否则返回 False。
class function TArraySortUtils.CheckIsSorted<T, R>(AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>): Boolean;
begin
  CheckIsSorted<T, R>(AItems, ADataAccessor, AComparer, 0,
    ADataAccessor.GetCount(AItems));
end;

class function TArraySortUtils.CheckIsSorted<T, R>(AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer): Boolean;
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
    if AComparer.Compare(ADataAccessor.GetItem(AItems, i),
      ADataAccessor.GetItem(AItems, i)) > 0 then
      Exit;
  end;
  Result := True;
end;

class function TArraySortUtils.CheckIsSorted<T>(AValueArray: array of T;
  AComparer: IComparer<T>): Boolean;
begin
  CheckIsSorted<T>(AValueArray, AComparer, Low(AValueArray),
    Length(AValueArray));
end;

class function TArraySortUtils.CheckIsSorted<T>(AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer): Boolean;
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

class function TArraySortUtils.CheckSortRangeValid<T, R>(const AItems: T;
  ADataAccessor: IDataAccessor<T, R>; const AIndex, ACount: Integer): Boolean;
var
  iMaxIndex: Integer;
begin
  iMaxIndex := ADataAccessor.GetCount(AItems) - 1;
  Result := not ((AIndex < 0)
    or ((AIndex > iMaxIndex) and (ACount > 0))
    or (AIndex + ACount - 1 > iMaxIndex)
    or (ACount < 0)
    or (AIndex + ACount < 0));
end;

class function TArraySortUtils.CheckSortRangeValid<T>(
  const AValueArray: array of T; const AIndex, ACount: Integer): Boolean;
begin
  Result := not ((AIndex < Low(AValueArray))
    or ((AIndex > High(AValueArray)) and (ACount > 0))
    or (AIndex + ACount - 1 > High(AValueArray))
    or (ACount < 0)
    or (AIndex + ACount < 0));
end;

// 功能：获取默认的排序算法函数引用。
// 备注：用于 Sort 的重载版本，当用户不指定具体排序算法时，默认使用此函数返回的算法。
//       当前默认设置为快速排序（QuickSort），因为它在大多数情况下具有良好的综合性能。
// 返回值：TSortFunc<T>, 指向 QuickSort<T> 过程的引用。
class function TArraySortUtils.GetDefaultSortFunc<T, R>: TSortFunc<T, R>;
begin
  Result := QuickSort<T, R>;
end;

class function TArraySortUtils.GetDefaultSortFunc<T>: TSortFunc<T>;
begin
  Result := QuickSort<T>;
end;

// 功能：获取混合排序算法中切换到插入排序的子数组长度阈值。
// 返回值：Integer, 返回 FMinSubArrLen 常量的值。
class function TArraySortUtils.GetMinSubArrLen: Integer;
begin
  Result := FMinSubArrLen;
end;

// 功能：对数组的指定范围使用插入排序（Insertion Sort）进行排序。
// 复杂度：时间 O(n^2)，最优情况 O(n)；空间 O(1)。
// 备注：对于小规模数组或基本有序的数组，插入排序非常高效。
//       因此，它常被用作更复杂排序算法（如快速排序、归并排序）的优化手段，用于处理小规模的子问题。
// 参数:
//  - AValueArray: var array of T, 待排序数组。
//  - AComparer: IComparer<T>, 比较器。
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。

class procedure TArraySortUtils.InsertionSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
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

    while (j > AIndex) and (AComparer.Compare(KeyBuffer,
      ADataAccessor.GetItem(AItems, j - 1)) < 0) do
    begin
      ADataAccessor.SetItem(AItems, ADataAccessor.GetItem(AItems, j - 1), j);
      Dec(j);
    end;
    ADataAccessor.SetItem(AItems, KeyBuffer, j);
  end;
end;

class procedure TArraySortUtils.InsertionSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
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

// 功能：快速排序的分区（Partition）辅助函数，采用Hoare分区方案。
// 备注：选择一个基准元（Pivot），将数组分为两部分，一部分所有元素小于等于基准，另一部分所有元素大于等于基准。
//       此实现选择中间元素作为基准，有助于避免在有序或逆序数组上性能退化为 O(n^2)。
// 参数:
//  - AValueArray: var array of T, 待分区的数组。
//  - AComparer: IComparer<T>, 比较器。
//  - ALeft: Integer, 分区范围的左边界索引。
//  - ARight: Integer, 分区范围的右边界索引。
// 返回值：Integer, 分区点的索引。注意，Hoare分区的返回值不一定是基准元素最终的位置。
class function TArraySortUtils.Partition<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft,
  ARight: Integer): Integer;
var
  i, j: Integer;
  Pivot: R;
  SwapBuffer: R;
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

class function TArraySortUtils.Partition<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; ALeft, ARight: Integer): Integer;
var
  i, j: Integer;
  Pivot: T;
  SwapBuffer: T;
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

// 功能：内省排序（IntroSort）的递归辅助函数。
// 备注：IntroSort 是快速排序的变体，它通过限制递归深度来防止最坏情况的发生。
//       当递归深度达到限制时（ADepthLimit <= 0），算法会切换到堆排序（HeapSort），保证 O(n log n) 的最坏时间复杂度。
//       当子数组规模小于 FMinSubArrLen 时，切换到插入排序进行优化。
//       此实现还使用了尾递归优化（通过循环代替对较大分区的递归调用）。
// 参数:
//  - ALeft, ARight: 待排序子数组的左右边界索引。
//  - ADepthLimit: 递归深度限制。
class procedure TArraySortUtils.IntroSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ALeft, ARight,
  ADepthLimit: Integer);
var
  PartitionIndex: Integer;
begin
  while (ARight - ALeft + 1) > GetMinSubArrLen() do
  begin
    if ADepthLimit <= 0 then
    begin
      HeapSort<T, R>(AItems, ADataAccessor, AComparer, ALeft, ARight - ALeft +
        1);
      Exit;
    end;

    PartitionIndex := Partition<T, R>(AItems, ADataAccessor, AComparer, ALeft,
      ARight);

    if (PartitionIndex - ALeft) < (ARight - PartitionIndex) then
    begin
      IntroSort<T, R>(AItems, ADataAccessor, AComparer, ALeft, PartitionIndex,
        ADepthLimit - 1);
      ALeft := PartitionIndex + 1;
    end
    else
    begin
      IntroSort<T, R>(AItems, ADataAccessor, AComparer, PartitionIndex + 1,
        ARight, ADepthLimit - 1);
      ARight := PartitionIndex;
    end;
  end;

  if ARight > ALeft then
    InsertionSort<T, R>(AItems, ADataAccessor, AComparer, ALeft, ARight - ALeft
      + 1);
end;

class procedure TArraySortUtils.IntroSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>;
  ALeft, ARight, ADepthLimit: Integer);
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
      IntroSort<T>(AValueArray, AComparer, ALeft, PartitionIndex, ADepthLimit -
        1);
      ALeft := PartitionIndex + 1;
    end
    else
    begin
      IntroSort<T>(AValueArray, AComparer, PartitionIndex + 1, ARight,
        ADepthLimit - 1);
      ARight := PartitionIndex;
    end;
  end;

  if ARight > ALeft then
    InsertionSort<T>(AValueArray, AComparer, ALeft, ARight - ALeft + 1);
end;

// 功能：对数组的指定范围使用内省排序（IntroSort）。
// 复杂度：平均时间 O(n log n)，最坏时间 O(n log n)，空间 O(log n)。
// 备注：这是 IntroSort 的主入口。它首先计算一个合适的递归深度限制（通常为 2*log2(n)），然后调用递归辅助函数。
//       IntroSort 结合了快速排序、堆排序和插入排序的优点，是一种性能非常稳定且高效的内部排序算法，被许多标准库（如C++ STL）采用。
// 参数:
//  - AIndex, ACount: 待排序范围的起始索引和元素数量。

class procedure TArraySortUtils.IntroSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
var
  DepthLimit: Integer;
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  // 计算最大递归深度: 2 * log2(N)
  if ACount = 0 then
    DepthLimit := 0
  else
    DepthLimit := 2 * Trunc(Log2(ACount));

  IntroSort<T, R>(AItems, ADataAccessor, AComparer, AIndex, AIndex + ACount - 1,
    DepthLimit);
end;

class procedure TArraySortUtils.IntroSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
var
  DepthLimit: Integer;
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;

  // 计算最大递归深度: 2 * log2(N)
  if ACount = 0 then
    DepthLimit := 0
  else
    DepthLimit := 2 * Trunc(Log2(ACount));

  IntroSort<T>(AValueArray, AComparer, AIndex, AIndex + ACount - 1, DepthLimit);
end;

// 功能：归并排序的合并（Merge）辅助函数。
// 备注：将两个已排序的相邻子数组（[AStart..AMid] 和 [AMid+1..AEnd]）合并成一个有序的数组。
//       合并操作需要一个与待合并范围大小相等的临时数组（ATempArray）来存储结果，然后再复制回原数组。
// 参数:
//  - AValueArray: var array of T, 包含两个待合并子数组的原始数组。
//  - ATempArray: var array of T, 用于存放合并结果的临时数组。
//  - AStart, AMid, AEnd: 定义了两个子数组范围的索引。
class procedure TArraySortUtils.Merge<T, R>(var AItems: T;
  var ATempArray: TArray<R>; ADataAccessor: IDataAccessor<T, R>;
  AComparer: IComparer<R>; AStart, AMid, AEnd: Integer);
var
  i, j, k: Integer;
begin
  i := AStart;
  j := AMid + 1;
  k := 0;

  while (i <= AMid) and (j <= AEnd) do
  begin
    if AComparer.Compare(ADataAccessor.GetItem(AItems, i),
      ADataAccessor.GetItem(AItems, j)) <= 0 then
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

class procedure TArraySortUtils.Merge<T>(var AValueArray: array of T; var
  ATempArray: array of T;
  AComparer: IComparer<T>; AStart, AMid, AEnd: Integer);
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

// 功能：对数组的指定范围使用归并排序（Merge Sort）。
// 复杂度：时间 O(n log n)，空间 O(n)。
// 备注：此实现是一种自底向上的迭代式归并排序，避免了递归开销。
//       首先，将数组视为多个长度为 FMinSubArrLen 的小块，并使用插入排序对这些小块进行预排序。
//       然后，逐步合并这些有序的子数组（块宽从 MINSUBARRLEN 开始，每次翻倍），直到整个数组有序。
//       归并排序是一种稳定的排序算法。
// 参数:
//  - AValueArray: var array of T, 待排序数组。
//  - AComparer: IComparer<T>, 比较器。
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。
class procedure TArraySortUtils.MergeSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
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
        Merge<T, R>(AItems, TempArray, ADataAccessor, AComparer, iLeft, iMid,
          iRight);
      end;

      i := i + 2 * iWidth;
    end;
    iWidth := iWidth * 2;
  end;
end;

class procedure TArraySortUtils.MergeSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
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

// 功能：堆排序的辅助函数，用于维护最大堆的性质（下沉操作，Sift-Down）。
// 备注：假设一个节点的左右子树都已经是最大堆，此过程通过将该节点与其子节点中较大者交换，
//       并递归地向下调整，来确保以该节点为根的子树也满足最大堆性质。
//       这是一个迭代实现，以避免递归开销。
// 参数:
//  - ABaseIndex: Integer, 子数组在原始数组中的起始索引，用于计算绝对位置。
//  - AHeapSize: Integer, 当前堆的逻辑大小（元素数量）。
//  - ANodeIndex: Integer, 需要进行下沉操作的节点索引（相对于子数组的0-based索引）。
class procedure TArraySortUtils.Heapify<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; ABaseIndex,
  AHeapSize, ANodeIndex: Integer);
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

    if (LeftChildIndex < AHeapSize) and
      (AComparer.Compare(ADataAccessor.GetItem(AItems, ABaseIndex +
      LeftChildIndex), ADataAccessor.GetItem(AItems, ABaseIndex + LargestIndex))
      > 0) then
    begin
      LargestIndex := LeftChildIndex;
    end;

    if (RightChildIndex < AHeapSize) and
      (AComparer.Compare(ADataAccessor.GetItem(AItems, ABaseIndex +
      RightChildIndex), ADataAccessor.GetItem(AItems, ABaseIndex + LargestIndex))
      > 0) then
    begin
      LargestIndex := RightChildIndex;
    end;

    if LargestIndex <> CurrentIndex then
    begin
      SwapItem<T, R>(AItems, ADataAccessor, ABaseIndex + CurrentIndex, ABaseIndex
        + LargestIndex, SwapBuffer);

      CurrentIndex := LargestIndex;
    end
    else
      Break;
  end;
end;

class procedure TArraySortUtils.Heapify<T>(var AValueArray: array of T;
  AComparer: IComparer<T>;
  ABaseIndex, AHeapSize, ANodeIndex: Integer);
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

    if (LeftChildIndex < AHeapSize) and
      (AComparer.Compare(AValueArray[ABaseIndex + LeftChildIndex],
      AValueArray[ABaseIndex + LargestIndex]) > 0) then
    begin
      LargestIndex := LeftChildIndex;
    end;

    if (RightChildIndex < AHeapSize) and
      (AComparer.Compare(AValueArray[ABaseIndex + RightChildIndex],
      AValueArray[ABaseIndex + LargestIndex]) > 0) then
    begin
      LargestIndex := RightChildIndex;
    end;

    if LargestIndex <> CurrentIndex then
    begin
      SwapBuffer := AValueArray[ABaseIndex + CurrentIndex];
      AValueArray[ABaseIndex + CurrentIndex] := AValueArray[ABaseIndex +
        LargestIndex];
      AValueArray[ABaseIndex + LargestIndex] := SwapBuffer;

      CurrentIndex := LargestIndex;
    end
    else
      Break;
  end;
end;

// 功能：对数组的指定范围使用堆排序（Heap Sort）。
// 复杂度：时间 O(n log n)，空间 O(1)。
// 备注：堆排序分为两个阶段：
//       1. 建堆：从最后一个非叶子节点开始，向前对每个节点调用 Heapify，将整个数组构建成一个最大堆。
//       2. 排序：重复地将堆顶元素（最大值）与堆末尾元素交换，然后缩小堆的大小并对新的堆顶调用 Heapify 以恢复最大堆性质。
//       堆排序是一种不稳定的排序算法。
// 参数:
//  - AValueArray: var array of T, 待排序数组。
//  - AComparer: IComparer<T>, 比较器。
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。

class procedure TArraySortUtils.HeapSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
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

class procedure TArraySortUtils.HeapSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
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

// 功能：混合排序算法，根据可用内存和数据规模选择合适的策略。
// 备注：这是一种稳健的排序策略。
//       1. 对于小数组（<= FMinSubArrLen），直接使用插入排序。
//       2. 对于大数组，优先尝试使用归并排序，因为它通常性能稳定且快速。
//       3. 如果为归并排序分配临时数组时发生内存不足（EOutOfMemory），则自动降级为使用堆排序，
//          因为堆排序是原地排序（空间复杂度O(1)），不需额外的大块内存。
// 参数:
//  - AValueArray: var array of T, 待排序数组。
//  - AComparer: IComparer<T>, 比较器。
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。

class procedure TArraySortUtils.HybridSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
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

class procedure TArraySortUtils.HybridSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
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

// 功能：使用默认排序算法（QuickSort）对整个数组进行排序。
// 参数:
//  - AValueArray: var array of T, 待排序数组。
//  - AComparer: IComparer<T>, 比较器。
class procedure TArraySortUtils.Sort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>);
begin
  Sort<T>(GetDefaultSortFunc<T>(), AValueArray, AComparer, 0,
    Length(AValueArray));
end;

// 功能：使用默认排序算法（QuickSort）对数组的指定范围进行排序。
// 参数:
//  - AValueArray: var array of T, 待排序数组。
//  - AComparer: IComparer<T>, 比较器。
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。
class procedure TArraySortUtils.Sort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
begin
  Sort<T>(GetDefaultSortFunc<T>(), AValueArray, AComparer, AIndex, ACount);
end;

// 功能：使用默认比较器和默认排序算法对整个数组进行排序。
// 备注：这是一个最方便的重载，适用于元素类型 T 有默认比较器（TComparer<T>.Default）的情况。
// 参数:
//  - AValueArray: var array of T, 待排序数组。
class procedure TArraySortUtils.Sort<T>(var AValueArray: array of T);
begin
  Sort<T>(GetDefaultSortFunc<T>(), AValueArray, TComparer<T>.Default, 0,
    Length(AValueArray));
end;

// 功能：对数组的指定范围使用快速排序（Quick Sort）。
// 复杂度：平均时间 O(n log n)，最坏时间 O(n^2)，空间 O(log n)。
// 备注：快速排序的主入口函数，内部调用递归辅助函数 QuickSortHelper。
// 参数
//  - AValueArray array of T 待排序数组;
//  - AComparer IComparer<T> 比较函数接口;
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。

class procedure TArraySortUtils.QuickSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
begin
  if not CheckSortRangeValid<T, R>(AItems, ADataAccessor, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;
  QuickSortHelper<T, R>(AItems, ADataAccessor, AComparer, AIndex, AIndex + ACount
    - 1);
end;

class procedure TArraySortUtils.QuickSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
begin
  if not CheckSortRangeValid<T>(AValueArray, AIndex, ACount) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  if ACount <= 1 then
    Exit;
  QuickSortHelper<T>(AValueArray, AComparer, AIndex, AIndex + ACount - 1);
end;

// 功能：快速排序的递归辅助函数。
// 备注：这是一个经典的快速排序实现，使用 "三数取中" 选择基准值以提高性能稳定性。
//       通过将对较大分区的递归调用改为循环（尾递归优化），可以减少递归深度，降低栈溢出的风险。
class procedure TArraySortUtils.QuickSortHelper<T, R>(
  var AItems: T; ADataAccessor: IDataAccessor<T, R>;
  AComparer: IComparer<R>; ALeft, ARight: Integer);
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

class procedure TArraySortUtils.QuickSortHelper<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; ALeft, ARight: Integer);
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

// 功能：对数组的指定范围使用选择排序（Selection Sort）。
// 复杂度：时间 O(n^2)，空间 O(1)。
// 备注：选择排序的特点是数据交换次数少（最多n-1次），但比较次数多。
//       在所有情况下时间复杂度都是 O(n^2)，性能不理想，通常仅用于教学。
// 参数
//  - AValueArray array of T 待排序数组;
//  - AComparer IComparer<T> 比较函数接口;
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。
class procedure TArraySortUtils.SelectionSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
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
      if AComparer.Compare(ADataAccessor.GetItem(AItems, j),
        ADataAccessor.GetItem(AItems, iMinIndex)) < 0 then
        iMinIndex := j;
    end;

    if iMinIndex <> i then
    begin
      SwapItem<T, R>(AItems, ADataAccessor, iMinIndex, i, SwapBuffer);
    end;
  end;
end;

class procedure TArraySortUtils.SelectionSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
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

// 功能：为希尔排序生成Hibbard增量序列。
// 序列公式：2^k - 1。例如：..., 63, 31, 15, 7, 3, 1。
// 备注：Hibbard序列是希尔排序中一种较为经典且性能不错的增量序列。
// 参数：ALength: Integer, 待排序的元素总数。
// 返回值：TArray<Integer>, 生成的Hibbard增量序列数组，按降序排列。
class function TArraySortUtils.GetHibbardStepArr(ALength: Integer):
  TArray<Integer>;
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

// 功能：对数组的指定范围使用希尔排序（Shell Sort）。
// 复杂度：时间复杂度依赖于增量序列，使用Hibbard序列时约为 O(n^(3/2))；空间 O(1)。
// 备注：希尔排序是插入排序的改进版本，通过允许交换相距较远的元素，来快速减少数组的无序度。
//       它也被称为“递减增量排序”。
// 参数
//  - AValueArray array of T 待排序数组;
//  - AComparer IComparer<T> 比较函数接口;
//  - AIndex: Integer, 起始索引。
//  - ACount: Integer, 元素数量。
class procedure TArraySortUtils.ShellSort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
var
  i, j, Step, iEndIndex, StepIndex: Integer;
  TempElement: R;
  aHibbardStepArr: TArray<Integer>; // 假设步长序列
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

      while (j >= AIndex + Step) and (AComparer.Compare(TempElement,
        ADataAccessor.GetItem(Aitems, j - Step)) < 0) do
      begin
        ADataAccessor.SetItem(AItems, ADataAccessor.GetItem(AItems, j - Step),
          j);
        j := j - Step;
      end;
      ADataAccessor.SetItem(AItems, TempElement, j);
    end;
  end;
end;

class procedure TArraySortUtils.ShellSort<T>(var AValueArray: array of T;
  AComparer: IComparer<T>; AIndex, ACount: Integer);
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

      while (j >= AIndex + Step) and (AComparer.Compare(TempElement,
        AValueArray[j - Step]) < 0) do
      begin
        AValueArray[j] := AValueArray[j - Step];
        j := j - Step;
      end;

      AValueArray[j] := TempElement;
    end;
  end;
end;

// 功能：使用指定的排序函数和比较器对整个数组进行排序。
// 参数:
//  - ASortFunc: TSortFunc<T>, 用户指定的排序算法函数引用。
//  - AValueArray: var array of T, 待排序数组。
//  - AComparer: IComparer<T>, 比较器。
class procedure TArraySortUtils.Sort<T>(const ASortFunc: TSortFunc<T>;
  var AValueArray: array of T; AComparer: IComparer<T>);
begin
  Sort<T>(ASortFunc, AValueArray, AComparer, 0, Length(AValueArray));
end;

// 功能：使用指定的排序函数对数组的指定范围进行排序
// 参数:
//  - ASortFunc TSortFunc<T> 指定的排序函数;
//  - AValueArray array of T 待排序数组（引用）;
//  - AComparer IComparer<T> 比较函数接口;
//  - AIndex Integer 起始索引;
//  - ACount Integer 排序元素的数量
class procedure TArraySortUtils.Sort<T>(const ASortFunc: TSortFunc<T>;
  var AValueArray: array of T; AComparer: IComparer<T>; AIndex,
  ACount: Integer);
begin
  ASortFunc(AValueArray, AComparer, AIndex, ACount);
end;

// 功能：使用指定的排序函数和默认比较器对整个数组进行排序。
class procedure TArraySortUtils.Sort<T, R>(var AItems: T;
  ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>; AIndex,
  ACount: Integer);
begin
  Sort<T, R>(GetDefaultSortFunc<T, R>(), AItems, ADataAccessor, AComparer,
    AIndex, ACount);
end;

class procedure TArraySortUtils.Sort<T, R>(const ASortFunc: TSortFunc<T, R>;
  var AItems: T; ADataAccessor: IDataAccessor<T, R>; AComparer: IComparer<R>;
  AIndex, ACount: Integer);
begin
  ASortFunc(AItems, ADataAccessor, AComparer, AIndex, ACount);
end;

class procedure TArraySortUtils.Sort<T>(const ASortFunc: TSortFunc<T>;
  var AValueArray: array of T);
begin
  Sort<T>(ASortFunc, AValueArray, TComparer<T>.Default, 0, Length(AValueArray));
end;

class procedure TArraySortUtils.SwapItem<T, R>(var AItems: T;
  ASG: IDataAccessor<T, R>; ALeftIndex, ARightIndex: Integer;
  var ASwapBuffer: R);
begin
  ASwapBuffer := ASG.GetItem(AItems, ALeftIndex);
  ASG.SetItem(AItems, ASG.GetItem(AItems, ARightIndex), ALeftIndex);
  ASG.SetItem(AItems, ASwapBuffer, ARightIndex);
end;

class procedure TArraySortUtils.SwapItem<T>(var AValueArray: array of T;
  ALeftIndex, ARightIndex: Integer; var ASwapBuffer: T);
begin
  ASwapBuffer := AValueArray[ALeftIndex];
  AValueArray[ALeftIndex] := AValueArray[ARightIndex];
  AValueArray[ARightIndex] := ASwapBuffer;
end;

{ TDataAccessor<T, R> }
constructor TDataAccessor<T, R>.Create(AGetter: TGetItem<T, R>; ASetter:
  TSetItem<T, R>; AGetCount: TGetCount<T>);
begin
  FGetter := AGetter;
  FSetter := ASetter;
  FGetCount := AGetCount;
end;

function TDataAccessor<T, R>.GetCount(AItems: T): Integer;
begin
  if Assigned(FGetCount) then
    Result := FGetCount(AItems)
  else
    raise Exception.Create('GetCount function not set!');
end;

function TDataAccessor<T, R>.GetItem(AItems: T; AIndex: Integer): R;
begin
  if Assigned(FGetter) then
    Result := FGetter(AItems, AIndex)
  else
    raise Exception.Create('Getter function not set!');
end;

procedure TDataAccessor<T, R>.SetItem(var AItems: T; AItem: R; AIndex: Integer);
begin
  if Assigned(FSetter) then
    FSetter(AItems, AItem, AIndex)
  else
    raise Exception.Create('Setter procedure not set!');
end;

end.

