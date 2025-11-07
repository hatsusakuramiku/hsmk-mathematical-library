{*******************************************************************************}
{                       Copyright  2025 hatsusakuramiku                         }
{                                                                               }
{                              MIT LICENSE                                      }
{  Permission is hereby granted, free of charge, to any person obtaining a copy }
{  of this software and associated documentation files (the "Software"), to deal}
{  in the Software without restriction, including without limitation the rights }
{  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    }
{  copies of the Software, and to permit persons to whom the Software is        }
{  furnished to do so, subject to the following conditions:                     }
{                                                                               }
{  The above copyright notice and this permission notice shall be included in   }
{  all copies or substantial portions of the Software.                          }
{                                                                               }
{  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   }
{  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     }
{  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  }
{  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       }
{  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE}
{  SOFTWARE.                                                                    }
{*******************************************************************************}

{* Require Version >= Delphi XE4 *}

{*这个单元提供一些测试函数，主要是测试运行耗时*}
unit TestUnit;

interface
uses
  GeneralTypeUnit, FuncToolPublicUnit, System.Diagnostics, System.SysUtils,
  Winapi.Windows, Winapi.Messages;

{Sort Functions Test}

type
  TSortFuncStruct = record
    PBase: Pointer;                 // 待排序数组
    ElemNum: TSize_T;                // 待排序元素个数
    ElemSize: TSize_T;              // 元素大小（字节数）
    PContext: Pointer;              // 额外参数（在比较函数中使用）
    CompareFunc: TCompareFunction;  // 比较函数 TCompareFunction = function(APData1, APData2, APContext: Pointer): Integer;
  end;

type
  TTestProc = reference to procedure;

function SortFuctRunTimeTest(ASortFuncs: array of TSortFunction; ARepeatTimes: TSize_T; APBase: Pointer; AElemNum, AElemSize: TSize_T; AContext: Pointer; ACompareFunc: TCompareFunction): TInt64Array; overload;
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ARepeatTimes: TSize_T; APBase: Pointer; AElemNum, AElemSize: TSize_T; AContext: Pointer; ACompareFunc: TCompareFunction): Int64; overload;
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct): Int64; overload;
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: TSize_T): Int64; overload;
function SortFuctRunTimeTest(ASortFunc: array of TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: TSize_T): TInt64Array; overload;
function functionRunTimeTest(ATestProc: TTestProc; ARepeatTimes: TSize_T): Int64;

implementation

{Sort Functions Test}

// 功能：测试排序函数的运行时间，当传入一个排序函数数组时，会测试所有函数。
// 参数：
//   - ASortFuncs: array of TSortFunction  待测试的排序函数数组。
//   - ARepeatTimes: TSize_T             重复测试的次数，用于提高测试的准确性。
//   - APBase: Pointer                   待排序数据块的基地址。
//   - AElemNum: TSize_T                 待排序元素的数量。
//   - AElemSize: TSize_T                每个元素的大小（字节）。
//   - AContext: Pointer                 传递给比较函数的上下文数据。
//   - ACompareFunc: TCompareFunction    用于比较两个元素的函数指针。
// 返回值：
//   - TInt64Array                       一个包含每个排序函数测试结果（运行时间，毫秒）的数组。

function SortFuctRunTimeTest(ASortFuncs: array of TSortFunction; ARepeatTimes: TSize_T; APBase: Pointer; AElemNum, AElemSize: TSize_T; AContext: Pointer; ACompareFunc: TCompareFunction): TInt64Array; overload;
var
  // 用于存储排序函数相关信息的结构体。
  ASortStruct: TSortFuncStruct;
begin
  // 将参数填充到结构体中，方便传递给内部的测试函数。
  with ASortStruct do
  begin
    PBase := APBase;          // 设置数据块的基地址。
    ElemNum := AElemNum;      // 设置元素的数量。
    ElemSize :=  AElemSize;   // 设置每个元素的大小。
    PContext := AContext;     // 设置比较函数的上下文。
    CompareFunc := ACompareFunc; // 设置比较函数。
  end;

  // 调用内部的测试函数，传入排序函数数组和结构体信息。
  // 这个函数会执行实际的测试并返回结果。
  Result := SortFuctRunTimeTest(ASortFuncs, ASortStruct, ARepeatTimes);
end;

// 功能：测试单个排序函数的运行时间。
// 参数：
//   - ASortFunc: TSortFunction          待测试的单个排序函数。
//   - ARepeatTimes: TSize_T             重复测试的次数，用于提高测试的准确性。
//   - APBase: Pointer                   待排序数据块的基地址。
//   - AElemNum: TSize_T                 待排序元素的数量。
//   - AElemSize: TSize_T                每个元素的大小（字节）。
//   - AContext: Pointer                 传递给比较函数的上下文数据。
//   - ACompareFunc: TCompareFunction    用于比较两个元素的函数指针。
// 返回值：
//   - Int64                             测试结果（平均运行时间，毫秒）。

function SortFuctRunTimeTest(ASortFunc: TSortFunction; ARepeatTimes: TSize_T; APBase: Pointer; AElemNum, AElemSize: TSize_T; AContext: Pointer; ACompareFunc: TCompareFunction): Int64; overload;
var
  // 用于存储排序函数相关信息的结构体。
  ASortStruct: TSortFuncStruct;
begin
  // 将参数填充到结构体中，方便传递给内部的测试函数。
  with ASortStruct do
  begin
    PBase := APBase;          // 设置数据块的基地址。
    ElemNum := AElemNum;      // 设置元素的数量。
    ElemSize :=  AElemSize;   // 设置每个元素的大小。
    PContext := AContext;     // 设置比较函数的上下文。
    CompareFunc := ACompareFunc; // 设置比较函数。
  end;

  // 调用内部的测试函数，传入单个排序函数和结构体信息。
  // 这个函数会执行实际的测试并返回总运行时间。
  // 然后我们计算平均时间。
  Result := SortFuctRunTimeTest(ASortFunc, ASortStruct, ARepeatTimes);
end;

//功能：根据输入的TSortFunction和TSortFuncStruct测试完成一次完全排序的执行时间
//参数：
//  - ASortFunc: TSortFunction 排序函数
//  - ASortStruct: TSortFuncStruct 用于测试排序的结构体，包含了待排序的数组、比较函数等
//返回值：Int64  完成一次完全排序执行的时间，单位ms
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct): Int64;
var
  StopWatch: TStopWatch;
  TestData: Pointer;
  TotalDataSize: TSize_T;
begin
  Result := 0;

  // 参数有效性检查
  if not Assigned(ASortFunc) or not Assigned(ASortStruct.PBase) or
     (ASortStruct.ElemNum = 0) or (ASortStruct.ElemSize = 0) or
     not Assigned(ASortStruct.CompareFunc) then
    Exit;

  // 计算总数据大小
  TotalDataSize := ASortStruct.ElemNum * ASortStruct.ElemSize;

  GetMem(TestData, TotalDataSize);

  try
    Move(ASortStruct.PBase^, TestData^, ASortStruct.ElemNum * ASortStruct.ElemSize);
    // 开始计时
    StopWatch := TStopwatch.StartNew;

    // 执行排序
//    OptimizedSort(ASortFunc, TestData, ASortStruct.ElemNum, ASortStruct.ElemSize,
//              ASortStruct.PContext, ASortStruct.CompareFunc);

    ASortFunc(TestData, ASortStruct.ElemNum, ASortStruct.ElemSize,
              ASortStruct.PContext, ASortStruct.CompareFunc);
    // 停止计时
    StopWatch.Stop;

    // 返回毫秒数
    Result := StopWatch.ElapsedMilliseconds;
  finally
    // 释放测试数据
    FreeMem(TestData);
  end;
end;

//功能：根据输入的TSortFunction和TSortFuncStruct测试对同一个数组完成ARepeatTimes次完全排序的平均执行时间
//参数：
//  - ASortFunc: TSortFunction 排序函数
//  - ASortStruct: TSortFuncStruct 用于测试排序的结构体，包含了待排序的数组、比较函数等
//  - ARepeatTimes: TSize_T 排序重复次数
//返回值：Int64  完成ARepeatTimes次完全排序的平均执行时间，单位ms
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: TSize_T): Int64;
var
  i: TSize_T;
  TotalTime: Int64;
begin
  Result := 0;

  // 参数有效性检查
  if not Assigned(ASortFunc) or not Assigned(ASortStruct.PBase) or
     (ASortStruct.ElemNum = 0) or (ASortStruct.ElemSize = 0) or
     not Assigned(ASortStruct.CompareFunc) or (ARepeatTimes = 0) then
    Exit;

  // 计算总数据大小
  TotalTime := 0;

  // 重复测试
  for i := 1 to ARepeatTimes do
  begin
      TotalTime := TotalTime + SortFuctRunTimeTest(ASortFunc, ASortStruct);
  end;

  // 返回平均时间
  Result := TotalTime div Int64(ARepeatTimes);
end;

//功能：根据输入的TSortFunction和TSortFuncStruct测试多个函数分别对同一个数组完成ARepeatTimes次完全排序的平均执行时间
//参数：
//  - ASortFunc: array of TSortFunction 排序函数列表
//  - ASortStruct: TSortFuncStruct 用于测试排序的结构体，包含了待排序的数组、比较函数等
//  - ARepeatTimes: TSize_T 排序重复次数
//返回值：TInt64Array(array of Int64)  多个函数分别对同一个数组完成ARepeatTimes次完全排序的平均执行时间，单位ms
function SortFuctRunTimeTest(ASortFunc: array of TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: TSize_T): TInt64Array;
var
  i: Integer;
  FuncCount: Integer;
begin
  // 获取函数数量
  FuncCount := Length(ASortFunc);

  // 设置结果数组长度
  SetLength(Result, FuncCount);

  // 参数有效性检查
  if (FuncCount = 0) or not Assigned(ASortStruct.PBase) or
     (ASortStruct.ElemNum = 0) or (ASortStruct.ElemSize = 0) or
     not Assigned(ASortStruct.CompareFunc) or (ARepeatTimes = 0) then
  begin
    // 如果参数无效，返回全零数组
    for i := 0 to FuncCount - 1 do
      Result[i] := 0;
    Exit;
  end;

  // 逐个测试每个排序函数
  for i := 0 to FuncCount - 1 do
  begin
    if Assigned(ASortFunc[i]) then
      Result[i] := SortFuctRunTimeTest(ASortFunc[i], ASortStruct, ARepeatTimes)
    else
      Result[i] := 0; // 如果函数指针为空，记录为0
  end;
end;

// 功能：测试指定过程的运行时间
// 参数：
//   - ATestProc: TTestProc     需要测试运行时间的过程（一个可执行的函数或方法）
//   - ARepeatTimes: TSize_T   重复执行 ATestProc 的次数
// 返回值：
//   - Int64                  多次运行 ATestProc 的平均耗时（毫秒）
function functionRunTimeTest(ATestProc: TTestProc; ARepeatTimes: TSize_T): Int64;
var
  i: TSize_T;
  TotalTime: Int64;
  StopWatch: TStopWatch;
begin
  TotalTime := 0;

  for i := 1 to ARepeatTimes do
  begin
    StopWatch := TStopwatch.StartNew;
    ATestProc();
    StopWatch.Stop;
    TotalTime := TotalTime + StopWatch.ElapsedMilliseconds;
  end;
  Result := TotalTime div Int64(ARepeatTimes);
end;

end.
