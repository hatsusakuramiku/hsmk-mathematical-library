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

{*这个单元提供一些类似C语言的操作指针的函数，为了保持与FMX框架的兼容性，将不会使用Windows的库函数*}
unit CLikeFunctionToolsUnit;

interface

{$IFNDEF TSize_T}
type
  TSize_T = NativeUInt;
{$ENDIF}

{Memory Function}
function MemCompare(const APData1, APData2: Pointer; const ASize: TSize_T): Boolean;
procedure MemSwap(const APData1, APData2: Pointer; const ASize: TSize_T); overload;
  inline;
procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: TSize_T);
  overload;
  inline;

type
  TCheckFunction = reference to function(const APCheckedData, AContext: Pointer):
  Boolean;

function CheckArrayAllElemAreVaild(const APBase, AContext: Pointer; const AElemNum,
  AElemSize: TSize_T; const
  ACheckFunc: TCheckFunction): Boolean; overload;
function CheckArrayAllElemAreVaild(const AArray: array of Integer; const AContext:
  Pointer; ACheckFunc: TCheckFunction):
  Boolean; overload;

{Sort Function}
type
  // 比较函数类型定义，须自行实现
  //  参数：
  //    - APData1: Pointer   指向第一个被比较参数的指针
  //    - APData2: Pointer   指向第二个被比较参数的指针
  //    - APContext: Pointer 指向额外参数的指针
  //  返回值：Integer
  //    - -1  APData1 < APData2（升序）
  //    - 0   APData1 = APData2
  //    - 1   APData1 > APData2
  TCompareFunction = reference to function(APData1, APData2, APContext: Pointer):
  Integer;
  TSortFunction = procedure(const APBase: Pointer; AElemNum, AElemSize: TSize_T;
    APContext: Pointer; ACompareFunc:
    TCompareFunction);

const
  MINSUBARRLEN: TSize_T = 8; //最小子数组长度，在下面较复杂的排序中，若待排
//序长度小于这个数将使用简单排序（如插入排序等）

// 辅助函数，在此处列出可供外部调用的辅助函数
// 为性能与效率考虑，多个函数或过程中都频繁使用的辅助函数不会对输入参数进行校验
// 无参数校验
function LeftMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer; inline;
function RightMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer; inline;
function MovePtr(const APBase: Pointer; const AOffset: NativeInt): Pointer; inline;

// 有参数校验
function IsSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction): Boolean;
procedure ReverseArray(const APBase: Pointer; AElemNum, AElemSize: TSize_T);
function IsReverseSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T;
  APContext:
  Pointer; ACompareFunc:
  TCompareFunction): Boolean;

// 排序函数
procedure BubbleSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure InsertionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure SelectionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure ShellSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure MergeSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure HeapSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure HybridSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure QuickSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
procedure IntroSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);

procedure OptimizedSort(ASortFunc: TSortFunction; const APBase: Pointer; AElemNum,
  AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc: TCompareFunction);

{Search Function}
type
  // 查找函数类型定义
  // 参数：
  //   - const APBase: Pointer           指向待查找的数组的指针
  //   - AElemNum: TSize_T                元素个数
  //   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
  //   - const APContext: Pointer        指向一个额外参数的指针，在比较函数里使用
  //   - const ASearchedElem: Pointer    寻找的目标元素
  //   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
  //                                     排序依据，若第一个参数大于第二个参数时返回
  //                                     正数则为升序，否则为降序，须调用者自行实现
  // 返回值: Integer -1：没有找到符合条件的元素，一个正整数：找到的元素所在的索引（从0开始）
  TSearchFunction = function(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
    APContext, ASearchedElem:
    Pointer; ACompareFunc: TCompareFunction): Integer;

  // 查找函数类型定义
  // 参数：
  //   - const APBase: Pointer           指向待查找的数组的指针
  //   - AElemNum: TSize_T                元素个数
  //   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
  //   - const APContext: Pointer        指向一个额外参数的指针，在比较函数里使用
  //   - const ASearchedElem: Pointer    寻找的目标元素
  //   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
  //                                     排序依据，若第一个参数大于第二个参数时返回
  //                                     正数则为升序，否则为降序，须调用者自行实现
  // 返回值: TArray<Integer> 为空：没有找到符合条件的元素，不为空：找到的所有符合条件的元素的索引（从0开始）数组
  TSearchsFunction = function(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
    APContext, ASearchedElem:
    Pointer; ACompareFunc: TCompareFunction): TArray<Integer>;

//对完全有序数组查找，此处函数只能用于完全有序的数组
function BinarySearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): Integer;
function BinarySearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): TArray<Integer>;

//通用查找
function SequentialSearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): Integer;
function SequentialSearchEx(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem:
  Pointer; ACompareFunc: TCompareFunction; AOffset: Cardinal = 0): Integer;
function SequentialSearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): TArray<Integer>;

implementation

uses
  System.SysUtils, System.Math;

{Memory Function}
// 功能：内存比较函数，逐字节比较两块内存区域是否相同
// 参数：
//   - const APStr1: Pointer  指向第一块内存区域的指针
//   - const APStr2: Pointer  指向第二块内存区域的指针
//   - const ASize: TSize_T    要比较的字节数
// 返回值：Boolean  True表示两块内存完全相同，False表示存在差异
function MemCompare(const APData1, APData2: Pointer; const ASize: TSize_T): Boolean;
begin
  Result := CompareMem(APData1, APData2, ASize);
end;

// 功能：交换两个指针指向的内存区域的内容，以字节为单位进行交换
// 参数：
//   - const APStr1: Pointer  指向第一块内存区域的指针
//   - const APStr2: Pointer  指向第二块内存区域的指针
//   - const ASize: TSize_T    要交换的字节数
procedure MemSwap(const APData1, APData2: Pointer; const ASize: TSize_T); overload;
var
  pTemp: Pointer; // 指向临时内存的指针
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

// 功能：交换两个指针指向的内存区域的内容，以字节为单位进行交换
// 参数：
//   - const APStr1: Pointer  指向第一块内存区域的指针
//   - const APStr2: Pointer  指向第二块内存区域的指针
//   - const ASwapBuffer: Pointer  指向临时内存的指针
//   - const ASize: TSize_T    要交换的字节数
procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: TSize_T);
  overload;
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

  // 针对小尺寸数据进行优化处理
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
      // 逐字节处理其他小尺寸情况
      for ByteOffset := 0 to ASize - 1 do
      begin
        SwapBufferPtr[ByteOffset] := Source1Ptr[ByteOffset];
        Source1Ptr[ByteOffset] := Source2Ptr[ByteOffset];
        Source2Ptr[ByteOffset] := SwapBufferPtr[ByteOffset];
      end;
    end
  else
  begin
    // 大数据块的高效处理，按NativeInt大小进行对齐操作
    ByteOffset := 0;
    while ByteOffset + NativeIntSize <= ASize do
    begin
      TempNativeInt := PNativeInt(Source1Ptr + ByteOffset)^;
      PNativeInt(Source1Ptr + ByteOffset)^ := PNativeInt(Source2Ptr + ByteOffset)^;
      PNativeInt(Source2Ptr + ByteOffset)^ := TempNativeInt;
      Inc(ByteOffset, NativeIntSize);
    end;

    // 处理剩余的字节
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

// 功能：检查数组中是否所有元素都满足特定条件
// 参数：
//  - const APBase: Pointer            指向数组第一个元素位置的指针
//  - const AContext: Pointer          条件判断函数的额外参数
//  - const AElemNum: TSize_T          数组中元素个数
//  - const AElemSize: TSize_T         单个元素大小（以字节计）
//  - const ACheckFunc: TCheckFunction 用于检查单个元素是否满足特定条件，需调用者自行实现
// 返回值：Boolean
//  - 如果APBase与ACheckFunc任一个为nil或 AElemNum与AElemSize任一个小于1都会返回False
//  - 数组中只要有一个元素不满足条件都会立即返回False
function CheckArrayAllElemAreVaild(const APBase, AContext: Pointer; const AElemNum,
  AElemSize: TSize_T; const
  ACheckFunc: TCheckFunction): Boolean; overload;
var
  i: TSize_T;
begin
  Result := False;

  if not (Assigned(APBase) and (AElemSize > 0) and (AElemNum > 0) and
    Assigned(ACheckFunc)) then
    Exit;

  for i := 0 to AElemNum - 1 do
  begin
    if not ACheckFunc(LeftMovePtr(APBase, i * AElemSize), AContext) then
      Exit;
  end;

  Result := False;
end;

// 功能：检查整数数组中是否所有元素都满足特定条件
// 参数：
//  - const AArray: array of Integer   整数动态数组
//  - const AContext: Pointer          条件判断函数的额外参数
//  - const ACheckFunc: TCheckFunction 用于检查单个元素是否满足特定条件，需调用者自行实现
// 返回值：Boolean
//  - 如果ACheckFunc为nil或数组长度小于1都会返回False
//  - 数组中只要有一个元素不满足条件都会立即返回False
function CheckArrayAllElemAreVaild(const AArray: array of Integer; const AContext:
  Pointer; ACheckFunc: TCheckFunction):
  Boolean; overload;
var
  i: integer;
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

{Sort Function}
// 避免在进行排序操作时使用MemSwap频繁申请和释放Buffer，定义一个所有排序函数都可使用的Buffer
// 使用方式
// CreateMemSwapBuffer(BufferSize);
// try
//   ...
//   MemSwapFaster(Elem1, Elem2);
//   ...
// finally
//   DestoryMemSwapBuffer;
// end;
var
  MemSwapBufferSize: TSize_T;
  MemSwapBuffer: Pointer;

  // 释放申请的Buffer空间
procedure DestoryMemSwapBuffer;
begin
  if Assigned(MemSwapBuffer) then
  begin
    FreeMem(MemSwapBuffer, MemSwapBufferSize);
  end;

  MemSwapBuffer := nil;
  MemSwapBufferSize := 0;
end;

// 创建一个指定大小的Buffer
procedure CreateMemSwapBuffer(ABufferSize: TSize_T);
begin
  DestoryMemSwapBuffer;
  MemSwapBufferSize := ABufferSize;
  MemSwapBuffer := AllocMem(MemSwapBufferSize);
end;

// 使用固定的Buffer而不需每次交换都申请/释放Buffer
procedure MemSwapFaster(const APData1, APData2: Pointer);
begin
  MemSwap(APData1, APData2, MemSwapBuffer, MemSwapBufferSize);
end;

// 功能：将指针向右移动指定个字节
// 参数：
//  - ApBase: Pointer 原指针
//  - AOffset: TSize_T 右移的偏移量大小
// 返回值类型：Pointer 移动后的指针
function LeftMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;
begin
  Result := Pointer(TSize_T(ApBase) - AOffset);
end;

// 功能：将指针向右移动指定个字节
// 参数：
//  - ApBase: Pointer 原指针
//  - AOffset: TSize_T 右移的偏移量大小
// 返回值类型：Pointer 移动后的指针
function RightMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;
begin
  Result := Pointer(TSize_T(ApBase) + AOffset);
end;

// 功能：将指针向左/向右移动指定个字节
// 参数：
//  - ApBase: Pointer 原指针
//  - AOffset: TSize_T 移动的偏移量大小，>0向右，小于零向左
// 返回值类型：Pointer 移动后的指针
function MovePtr(const APBase: Pointer; const AOffset: NativeInt): Pointer; inline;
begin
  Result := Pointer(NativeInt(APBase) + AOffset);
end;

// 功能：反转数组
// 参数：
//   - const APBase: Pointer           指向待反转的数组的指针
//   - AElemNum: TSize_T                元素个数
//   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
procedure ReverseArray(const APBase: Pointer; AElemNum, AElemSize: TSize_T);
var
  pLeft, pRight: Pointer;
  i: TSize_T;
begin
  // 参数有效性检查
  if (APBase = nil) or (AElemNum < 2) or (AElemSize = 0) then
    Exit;

  // 设置左右指针
  pLeft := APBase;
  pRight := RightMovePtr(APBase, (AElemNum - 1) * AElemSize);

  // 从两端向中间交换元素
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

// 功能：检查数组是否完全逆序（相对于比较函数的期望顺序）
// 参数：
//   - const APBase: Pointer           指向待检查的数组的指针
//   - AElemNum: TSize_T                元素个数
//   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向额外参数的指针
//   - ACompareFunc: TCompareFunction  比较函数
// 返回值：Boolean  True表示完全逆序，False表示非完全逆序
function IsReverseSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T;
  APContext:
  Pointer; ACompareFunc:
  TCompareFunction): Boolean;
var
  i: TSize_T;
begin
  Result := True;

  // 参数有效性检查
  if (APBase = nil) or (AElemNum <= 1) or (AElemSize = 0) or (not
    Assigned(ACompareFunc)) then
    Exit(False);

  // 检查每相邻两个元素是否都是逆序的
  for i := 0 to AElemNum - 2 do
  begin
    if ACompareFunc(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase, (i + 1) *
      AElemSize), APContext) > 0 then
    begin
      Result := False;
      Break;
    end;
  end;
end;

// 功能：优化的排序函数，先检查是否已排序或完全逆序
// 参数：
//   - ASortFunc: TSortFunction        要使用的排序函数
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                元素个数
//   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向额外参数的指针
//   - ACompareFunc: TCompareFunction  比较函数
procedure OptimizedSort(ASortFunc: TSortFunction; const APBase: Pointer; AElemNum,
  AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc: TCompareFunction);
begin
  // 参数有效性检查
  if (APBase = nil) or (AElemNum <= 1) or (AElemSize = 0) or (not
    Assigned(ACompareFunc))
    or (not Assigned(ASortFunc)) then
    Exit;

  // 检查是否已经有序
  if IsSorted(APBase, AElemNum, AElemSize, APContext, ACompareFunc) then
    Exit; // 已经有序，无需排序

  // 检查是否完全逆序
  if IsReverseSorted(APBase, AElemNum, AElemSize, APContext, ACompareFunc) then
  begin
    ReverseArray(APBase, AElemNum, AElemSize); // 直接反转
    Exit;
  end;

  // 既不是有序也不是逆序，使用正常排序算法
  ASortFunc(APBase, AElemNum, AElemSize, APContext, ACompareFunc);
end;

// 功能：判断数组是否已经有序
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 返回值：Boolean True：都有序，False：至少有一个元素顺序错误
function IsSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction): Boolean;
var
  i: TSize_T;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc))
    then
    Exit(False);

  for i := 0 to AElemNum - 2 do
  begin
    if ACompareFunc(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase, (i + 1) *
      AElemSize), APContext) > 0 then
      Exit(False);
  end;

  Result := True;
end;

// 功能：冒泡排序
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  BubbleSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  BubbleSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure BubbleSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  bFlag: Boolean;
  i, j: TSize_T;
  PData1, PData2: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not
    Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效

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

// 功能：插入排序
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  InsertionSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  InsertionSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure InsertionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  i, j: TSize_T;
  pKey: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not
    Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效

  pKey := AllocMem(AElemSize);
  try
    for i := 1 to AElemNum - 1 do
    begin
      Move(RightMovePtr(APBase, i * AElemSize)^, pKey^, AElemSize);
      j := i;

      while (j >= 1) and (ACompareFunc(pKey, RightMovePtr(APBase, (j - 1) * AElemSize),
        APContext) < 0) do
      begin
        Move(RightMovePtr(APBase, (j - 1) * AElemSize)^, RightMovePtr(APBase, j *
          AElemSize)^, AElemSize);
        Dec(j);
      end;

      Move(pKey^, RightMovePtr(APBase, j * AElemSize)^, AElemSize)

    end;
  finally
    FreeMem(pKey)
  end;

end;

// 功能：选择排序
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  SelectionSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  SelectionSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure SelectionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  i, j, iMinIndex: TSize_T;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not
    Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效

  CreateMemSwapBuffer(AElemSize);
  try
    for i := 0 to AElemNum - 2 do
    begin
      iMinIndex := i;

      for j := i + 1 to AElemNum - 1 do
      begin
        if ACompareFunc(RightMovePtr(APBase, j * AElemSize), RightMovePtr(APBase,
          iMinIndex * AElemSize), APContext) < 0 then
          iMinIndex := j;
      end;

      if iMinIndex <> i then
        MemSwapFaster(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase,
          iMinIndex
          * AElemSize));
    end;
  finally
    DestoryMemSwapBuffer;
  end;
end;

// 功能：生成Hibbard增量序列
//  参数：ALength: Integer 需要排序的元素数量
//  返回值：TIntegerArray 生成的Hibbard增量序列,[1, 3, 7, 15, 31, 63,...]
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

// 功能：希尔排序（使用Hibbard增量序列）
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  ShellSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  ShellSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure ShellSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  i, j, k: TSize_T;
  aHibbardStepArr: TArray<Integer>;
  pKey: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not
    Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效
  aHibbardStepArr := GetHibbardStepArr(AElemNum);
  pKey := AllocMem(AElemSize);
  try
    for k := Low(aHibbardStepArr) to High(aHibbardStepArr) do
    begin
      for i := aHibbardStepArr[k] to AElemNum - 1 do
      begin
        Move(RightMovePtr(APBase, i * AElemSize)^, pKey^, AElemSize);
        j := i;

        while (j >= 1) and (ACompareFunc(pKey, RightMovePtr(APBase, (j - 1) *
          AElemSize),
          APContext) < 0) do
        begin
          Move(RightMovePtr(APBase, (j - 1) * AElemSize)^, RightMovePtr(APBase, j *
            AElemSize)^, AElemSize);
          Dec(j);
        end;

        Move(pKey^, RightMovePtr(APBase, j * AElemSize)^, AElemSize)

      end;
    end;

  finally
    FreeMem(pKey)
  end;
end;

// 功能：构建最大堆
// 参数：
//   - APBase: Pointer    指向待排序数组的起始指针
//   - AElemNum: TSize_T   当前堆的大小（或者说待排序部分的长度）
//   - AIndex: TSize_T     需要堆化的节点索引（从0开始）
//   - AElemSize: TSize_T  每个元素的大小
//   - APContext: Pointer 指向额外参数的指针（用于比较）
//   - ACompareFunc: TCompareFunction 比较函数
procedure Heapify(APBase: Pointer; AElemNum, AIndex, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
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

    // 检查右子节点是否存在且是否比当前最大节点大
    if (RightChildIndex < AElemNum) then
    begin
      RightChildPtr := RightMovePtr(APBase, RightChildIndex * AElemSize);
      CurrentNodePtr := RightMovePtr(APBase, LargestIndex * AElemSize); // 重新获取当前最大节点指针
      if ACompareFunc(RightChildPtr, CurrentNodePtr, APContext) > 0 then
      begin
        LargestIndex := RightChildIndex;
      end;
    end;

    // 如果最大节点不是当前节点，则交换它们
    if LargestIndex <> CurrentIndex then
    begin
      CurrentNodePtr := RightMovePtr(APBase, CurrentIndex * AElemSize);
      LargestNodePtr := RightMovePtr(APBase, LargestIndex * AElemSize);
      //      MemSwap(CurrentNodePtr, LargestNodePtr, AElemSize);
      MemSwapFaster(CurrentNodePtr, LargestNodePtr);
      // 将当前索引更新为最大节点的索引，继续向下调整
      CurrentIndex := LargestIndex;
    end
    else
      Break;
  end;
end;

// 功能：基于最大堆实现的堆排序
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  HeapSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  HeapSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure HeapSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  i: TSize_T;
  LastNodePtr, RootNodePtr: Pointer;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc))
    then
    Exit; // 参数校验

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

// 功能：归并排序的基础辅助函数，进行归并操作
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AStart: TSize_T                  归并左数组的第一个元素的索引
//   - AMid: TSize_T                    归并左数组的最后一个元素的索引
//   - AEnd: TSize_T                    归并右数组的最后一个元素的索引
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - ATemp: Pointer                  指向临时存储空间 (大小为 AElemNum * AElemSize)
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
procedure MergeSortBase(const APBase: Pointer; AStart, AMid, AEnd, AElemSize: TSize_T;
  APContext, ATemp: Pointer;
  ACompareFunc: TCompareFunction);
var
  pLeftPtr, pRightPtr, pTempCurrent: Pointer;
  iLeftIndex, iRightIndex, iTempIndex: TSize_T;
begin

  iLeftIndex := AStart; // 当前处理的左边子数组的元素索引
  iRightIndex := AMid + 1; // 当前处理的右边子数组的元素索引
  iTempIndex := 0; // 临时数组的当前写入索引

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

  // 将临时数组的内容复制回原数组
  Move(ATemp^, RightMovePtr(APBase, AStart * AElemSize)^, iTempIndex * AElemSize);
end;

// 功能：归并排序的主要辅助函数，完成主要排序操作
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ATemp: Pointer                  指向临时存储空间 (大小为 AElemNum * AElemSize)
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
procedure MergeSortBaseWithTemp(const APBase: Pointer; AElemNum, AElemSize: TSize_T;
  APContext, ATemp: Pointer;
  ACompareFunc: TCompareFunction);
var
  iWidth, i, iLeft, iMid, irRight: TSize_T;
begin
  // 第一步：处理所有长度 <= MINSUBARRLEN 的段
  i := 0;
  while i < AElemNum do
  begin
    irRight := Min(i + MINSUBARRLEN - 1, AElemNum - 1);
    InsertionSort(RightMovePtr(APBase, i * AElemSize), irRight - i + 1, AElemSize,
      APContext, ACompareFunc);
    //  SelectionSort(RightMovePtr(APBase, i * AElemSize), irRight - i + 1, AElemSize, APContext, ACompareFunc);
    i := i + MINSUBARRLEN;
  end;

  // 第二步：从 iWidth = MINSUBARRLEN 开始归并
  iWidth := MINSUBARRLEN;
  while iWidth < AElemNum do
  begin
    i := 0;
    while i < AElemNum do
    begin
      iLeft := i;
      iMid := Min(i + iWidth - 1, AElemNum - 1);
      irRight := Min(i + 2 * iWidth - 1, AElemNum - 1);
      if iMid < irRight then
        MergeSortBase(APBase, iLeft, iMid, irRight, AElemSize, APContext, ATemp,
          ACompareFunc);
      i := i + 2 * iWidth;
    end;
    iWidth := iWidth * 2;
  end;
end;

// 功能：优化的归并排序，设置最小子数组长度为MINSUBARRLEN，低于MINSUBARRLEN时使用插入排序
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  MergeSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  MergeSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure MergeSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  ATemp: Pointer;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc))
    then
    Exit;

  ATemp := AllocMem(AElemNum * AElemSize);
  try
    MergeSortBaseWithTemp(APBase, AElemNum, AElemSize, APContext, ATemp, ACompareFunc);
  finally
    FreeMem(ATemp);
  end;
end;

// 功能：混合排序，先尝试申请
//       临时空间进行优化的归并排序，若无法申请到足够的临时空间就使用堆排序
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  HybridSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  HybridSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure HybridSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  pTemp: Pointer;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc))
    then
    Exit;

  if AElemNum <= MINSUBARRLEN then
  begin
    InsertionSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc);
    Exit;
  end;

  try
    pTemp := AllocMem(AElemNum * AElemSize);
    try
      MergeSortBaseWithTemp(APBase, AElemNum, AElemSize, APContext, pTemp,
        ACompareFunc);
    finally
      FreeMem(pTemp);
    end;
  except
    HeapSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc);
    Exit;
  end;
end;

// 功能：快速排序，使用数组中间的元素作为初始支点
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  HybridSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  HybridSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure QuickSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
// 参考 System.Generics.Collections.TArray.Sort<T>实现
  procedure InternalQuickSort(const ABase: Pointer; const AElemNum, AElemSize: TSize_T;
    const APContext: Pointer; const
    ACompareFunc: TCompareFunction; const AL, AR: TSize_T);
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
      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, I * AElemSize), pivotValPtr,
        APContext) < 0) do
        Inc(I);

      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, J * AElemSize), pivotValPtr,
        APContext) > 0) do
      begin
        if J = AL then
          Break;
        Dec(J);
      end;

      if I <= J then
      begin
        if I <> J then
          MemSwapFaster(RightMovePtr(ABase, I * AElemSize), RightMovePtr(ABase, J *
            AElemSize));

        Inc(I);
        if J > AL then
          Dec(J)
        else
          Break;
      end;
    until I > J;

    MemSwapFaster(RightMovePtr(ABase, AL * AElemSize), RightMovePtr(ABase, J *
      AElemSize));

    if AL < J then
      InternalQuickSort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, AL, J -
        1);

    if I < AR then
      InternalQuickSort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, I, AR);
  end;
begin
  if (APBase = nil) or (AElemNum < 2) or (AElemSize = 0) or (not Assigned(ACompareFunc))
    then
    Exit;
  CreateMemSwapBuffer(AElemSize);
  try
    InternalQuickSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, 0, AElemNum
      -
      1);
  finally
    DestoryMemSwapBuffer;
  end;
end;

// 功能：排序使用数组中间的元素作为初始支点
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 说明：基于内省排序修改 ，当分区元素不大于MINSUBARRLEN时使用插入排序完成。如果递归深度超过阈值则会使用HybridSort代替完成排序
//      经过简单测试，当数组长度不超过1E7时不会超过递归深度阈值。
// 使用示例：
//  var
//    aIntegerArr: TArray<Integer>;
//  begin
//  aIntegerArr := GenerateRandomIntegerArray(10, 0, 100);
//  WriteLn('排序前');
//  PrintIntegerArray(aIntegerArr);
//  // 方式一，直接传递数组的引用，Delphi会自动解引用将APBase指向第一个元素
//  HybridSort(aIntegerArr, Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  // 方式二，直接传递数组第一个元素的地址
//  HybridSort(@aIntegerArr[Low(aIntegerArr)], Length(aIntegerArr), SizeOf(Integer), nil, IntegerCompareAsc);
//  WriteLn('排序后');
//  PrintIntegerArray(aIntegerArr);
//  end;
procedure IntroSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext:
  Pointer; ACompareFunc:
  TCompareFunction);
var
  maxDepth: Integer;
  procedure InternalIntrosort(const ABase: Pointer; const ACurrentElemNum, AElemSize:
    NativeInt;
    // ACurrentElemNum 指的是当前处理的子数组元素个数
    const APContext: Pointer; const ACompareFunc: TCompareFunction; const AL, AR:
    NativeInt; const ADepth: Integer);
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
      InsertionSort(SubArrayBasePtr, SubArrayElemNum, AElemSize, APContext,
        ACompareFunc);
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
      while (I <= J) and (ACompareFunc(RightMovePtr(APBase, I * AElemSize),
        pivotValPtr,
        APContext) < 0) do
        Inc(I);

      while (I <= J) and (ACompareFunc(RightMovePtr(APBase, J * AElemSize),
        pivotValPtr,
        APContext) > 0) do
      begin
        if J = AL then
          Break;

        Dec(J);
      end;

      if I <= J then
      begin
        if I <> J then
          MemSwapFaster(RightMovePtr(APBase, I * AElemSize), RightMovePtr(APBase, J *
            AElemSize));

        Inc(I);
        if J > AL then
          Dec(J)
        else
          Break;
      end;
    until I > J;
    MemSwapFaster(RightMovePtr(APBase, AL * AElemSize), RightMovePtr(APBase, J *
      AElemSize));

    if AL < J then
      InternalIntrosort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, AL, J -
        1,
        ADepth + 1);

    if I < AR then
      InternalIntrosort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, I, AR,
        ADepth + 1);
  end;
begin
  if (APBase = nil) or (AElemNum < 2) or (AElemSize = 0) or (not Assigned(ACompareFunc))
    then
    Exit; // 元素少于2个，无需排序

  // 计算最大递归深度（2*log2(n)，至少为1）
  if AElemNum = 0 then
    maxDepth := 0
  else
    maxDepth := 2 * Trunc(Log2(AElemNum)) + 1;

  CreateMemSwapBuffer(AElemSize);
  try
    InternalIntrosort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, 0, AElemNum
      -
      1, 0);
  finally
    DestoryMemSwapBuffer;
  end;
end;

{Search Function}
//对完全有序数组查找，此处函数只能用于完全有序的数组

// 功能：使用二分法在完全有序数组中查找指定元素
// 参数：
//   - const APBase: Pointer           指向待查找的数组的指针
//   - AElemNum: TSize_T                元素个数
//   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
//   - const APContext: Pointer        指向一个额外参数的指针，在比较函数里使用
//   - const ASearchedElem: Pointer    寻找的目标元素
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 返回值: Integer -1：没有找到符合条件的元素，一个正整数：找到的第一个符合条件的元素所在的索引（从0开始）
function BinarySearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): Integer;
  function GetHalf(AValue: TSize_T): TSize_T;
  begin
    Result := AValue shr 1;
  end;
var
  iA, iB, iMiddle: TSize_T;
begin
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not
    Assigned(ACompareFunc) then
    Exit(-1);

  if (ACompareFunc(ASearchedElem, APBase, APContext) < 0) or
    (ACompareFunc(ASearchedElem, RightMovePtr(APBase, (AElemNum - 1) * AElemSize),
    APContext) > 0) then
    Exit(-1);

  if ACompareFunc(ASearchedElem, APBase, APContext) = 0 then
    Exit(0)
  else if ACompareFunc(ASearchedElem, RightMovePtr(APBase, (AElemNum - 1) * AElemSize),
    APContext) = 0 then
    Exit(AElemNum - 1);

  iA := 0;
  iB := AElemNum - 1;
  iMiddle := GetHalf(iA + iB);
  while (iMiddle > iA) and (iMiddle < iB) do
  begin
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iMiddle * AElemSize), APContext)
      = 0 then
    begin
      iA := Max(iMiddle - 1, 0);
      while True do
      begin
        if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iA * AElemSize), APContext)
          <> 0 then
        begin
          Inc(iA);
          Break;
        end;

        Dec(iA);
      end;
      Exit(iA)
    end
    else if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iMiddle * AElemSize),
      APContext) < 0 then
      iB := iMiddle
    else
      iA := iMiddle;

    iMiddle := GetHalf(iA + iB);
  end;

  Result := -1;
end;

// 功能：使用二分法在完全有序数组中查找指定元素
// 参数：
//   - const APBase: Pointer           指向待查找的数组的指针
//   - AElemNum: TSize_T                元素个数
//   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
//   - const APContext: Pointer        指向一个额外参数的指针，在比较函数里使用
//   - const ASearchedElem: Pointer    寻找的目标元素
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 返回值: TArray<Integer> 为空：没有找到符合条件的元素，不为空：找到的所有符合条件的元素的索引（从0开始）数组
function BinarySearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): TArray<Integer>;
var
  iMiddle, iB, i, iNum, iSize: Integer;
begin
  iMiddle := BinarySearch(APBase, AElemNum, AElemSize, APContext, ASearchedElem,
    ACompareFunc);
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
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iB * iSize), APContext) <> 0
      then
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

//不论数组是否有序，都能使用

// 功能：使用顺序查找在数组中查找指定元素
// 参数：
//   - const APBase: Pointer           指向待查找的数组的指针
//   - AElemNum: TSize_T                元素个数
//   - AElemSize: TSize_T               元素所占空间的大小（以字节大小计）
//   - const APContext: Pointer        指向一个额外参数的指针，在比较函数里使用
//   - const ASearchedElem: Pointer    寻找的目标元素
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若两个参数相等就返回0
// 返回值: Integer -1：没有找到符合条件的元素，一个正整数：找到的第一个符合条件的元素所在的索引（从0开始）
function SequentialSearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): Integer;
var
  iSize, iNum: Integer;
begin
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not
    Assigned(ACompareFunc) then
    Exit(-1);

  iSize := AElemSize;
  iNum := AElemNum;

  for Result := 0 to iNum - 1 do
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, Result * iSize), APContext) = 0
      then
      Exit;

  Result := -1;
end;

// 功能：使用顺序查找在数组中查找指定元素
// 参数：
//   - const APBase: Pointer           指向待查找的数组的指针
//   - AElemNum: TSize_T               元素个数
//   - AElemSize: TSize_T              元素所占空间的大小（以字节大小计）
//   - const APContext: Pointer        指向一个额外参数的指针，在比较函数里使用
//   - const ASearchedElem: Pointer    寻找的目标元素
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小，当且仅当两元素相等时才返回0
//   - AOffset: Integer = 0            偏移量，表示找到的符合条件的元素前面还有多少个也满足此条件的元素
// 返回值: Integer -1：没有找到符合条件的元素，一个正整数：找到的符合条件的元素所在的索引（从0开始）
function SequentialSearchEx(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem:
  Pointer; ACompareFunc: TCompareFunction; AOffset: Cardinal = 0): Integer;
var
  i: TSize_T;
begin
  Result := -1;

  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not
    Assigned(ACompareFunc) then
    Exit(-1);

  for i := 0 to AElemNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, i * AElemSize), APContext) = 0
      then
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

// 功能：使用顺序查找在数组中查找指定元素
// 参数：
//   - const APBase: Pointer           指向待查找的数组的指针
//   - AElemNum: TSize_T               元素个数
//   - AElemSize: TSize_T              元素所占空间的大小（以字节大小计）
//   - const APContext: Pointer        指向一个额外参数的指针，在比较函数里使用
//   - const ASearchedElem: Pointer    寻找的目标元素
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小，当且仅当两元素相等时才返回0
// 返回值: TArray<Integer> 为空：没有找到符合条件的元素，不为空：找到的所有符合条件的元素的索引（从0开始）数组
function SequentialSearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const
  APContext, ASearchedElem: Pointer;
  ACompareFunc: TCompareFunction): TArray<Integer>;
var
  iIndex, iTemp: TSize_T;
begin
  SetLength(Result, 0);
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not
    Assigned(ACompareFunc) then
    Exit;

  iTemp := 1;
  for iIndex := 0 to AElemNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iIndex * AElemSize), APContext)
      =
      0 then
    begin
      SetLength(Result, iTemp);
      Inc(iTemp);
      Result[High(Result)] := iIndex;
    end;
  end;

end;

end.

