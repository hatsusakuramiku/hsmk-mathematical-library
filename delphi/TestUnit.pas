unit TestUnit;

interface
uses
  GeneralTypeUnit, FunctionToolUnit, System.Diagnostics, System.SysUtils,
  Winapi.Windows, Winapi.Messages;

{Sort Functions Test}

type
  TSortFuncStruct = record
    PBase: Pointer;                 // 待排序数组
    ElemNum: SIZE_T;                // 待排序元素个数
    ElemSize: SIZE_T;              // 元素大小（字节数）
    PContext: Pointer;              // 额外参数（在比较函数中使用）
    CompareFunc: TCompareFunction;  // 比较函数 TCompareFunction = function(APData1, APData2, APContext: Pointer): Integer;
  end;

function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct): Int64; overload;
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: SIZE_T): Int64; overload;
function SortFuctRunTimeTest(ASortFunc: array of TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: SIZE_T): TInt64Array; overload;


implementation

{Sort Functions Test}

//功能：根据输入的TSortFunction和TSortFuncStruct测试完成一次完全排序的执行时间
//参数：
//  - ASortFunc: TSortFunction 排序函数
//  - ASortStruct: TSortFuncStruct 用于测试排序的结构体，包含了待排序的数组、比较函数等
//返回值：Int64  完成一次完全排序执行的时间，单位ms
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct): Int64;
var
  StopWatch: TStopWatch;
  TestData: Pointer;
  TotalDataSize: SIZE_T;
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
    OptimizedSort(ASortFunc, TestData, ASortStruct.ElemNum, ASortStruct.ElemSize,
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
//  - ARepeatTimes: SIZE_T 排序重复次数
//返回值：Int64  完成ARepeatTimes次完全排序的平均执行时间，单位ms
function SortFuctRunTimeTest(ASortFunc: TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: SIZE_T): Int64;
var
  i: SIZE_T;
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
//  - ARepeatTimes: SIZE_T 排序重复次数
//返回值：TInt64Array(array of Int64)  多个函数分别对同一个数组完成ARepeatTimes次完全排序的平均执行时间，单位ms
function SortFuctRunTimeTest(ASortFunc: array of TSortFunction; ASortStruct: TSortFuncStruct; ARepeatTimes: SIZE_T): TInt64Array;
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

end.
