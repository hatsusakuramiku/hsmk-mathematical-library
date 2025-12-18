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

{* 这个单元提供一个TArray的Helper *}
unit ArrayHelperUnit;

interface

uses
  System.Classes, System.SysUtils, System.RTLConsts,
  System.Generics.Defaults, System.Generics.Collections, GeneralTypeUnit;

type
  // TCallBackProc<T>: 泛型回调过程类型。
  //   - AValue: T - 传递给回调过程的值。
  //   - 作用：用于在不返回任何值的情况下，对数组中的每个元素执行某个操作。
  TCallBackProc<T> = reference to procedure(AValue: T);

  // TCallBackFunc<T>: 泛型回调函数类型。
  //   - AValue: T - 传递给回调函数的输入值。
  //   - 返回值: T - 回调函数处理后的返回值。
  //   - 作用：用于在对数组中的每个元素执行某个操作后，返回处理后的新值，并用新值替换原值。
  TCallBackFunc<T> = reference to function(AValue: T): T;

  // TArrayHelper: 扩展 TArray 的类助手。
  //   - 提供了一系列常用的数组操作方法，并且都是泛型的，可以处理各种类型的数组。
  //   - 这些方法都是类方法，可以直接通过类名调用，非常方便。
  TArrayHelper = class helper for TArray
  public
    class procedure ForEach<T>(AValueArray: array of T; AProc: TCallBackProc<T>);
      overload;
    class procedure ForEach<T>(var AValueArray: array of T; AFunc: TCallBackFunc<T>);
      overload;
    class procedure Append<T>(var AValueArray: TArray<T>; AValue: T);
    class procedure Add<T>(var AValueArray: TArray<T>; AValue: T);
    class procedure Delete<T>(var AValueArray: TArray<T>; AIndex: Integer);
    class procedure Insert<T>(var AValueArray: TArray<T>; AValue: T; AIndex: Integer);
    class procedure Reverse<T>(var AValueArray: array of T);
    class function IndexOf<T>(AValueArray: array of T; AValue: T): Integer; overload;
    class function IndexOf<T>(AValueArray: array of T; AValue: T; ACompare:
      IComparer<T>): Integer; overload;
    class function IsMember<T>(AValueArray: array of T; AValue: T; ACompare:
      IComparer<T>): Boolean; overload;
    class function IsMember<T>(AValueArray: array of T; AValue: T): Boolean; overload;
    class procedure FreeAllItems<T: class>(var AValueArray: array of T);
  end;

function InRange(const AValue, AMin, AMax: Integer; AIsIncludeBound: Boolean = True):
  Boolean;

implementation

// 引入可能用到的单元，这里似乎是用来处理字符串资源的。
uses
  FuncToolPublicUnit, System.TypInfo;

{ TArrayHelper }

// 功能: 对传入数组中的每一个参数依次执行回调函数AProc
// 参数：
//   - AValueArray: array of T  要处理的数组
//   - AProc: TCallBackProc<T>  对元素执行的回调函数
class procedure TArrayHelper.ForEach<T>(AValueArray: array of T;
  AProc: TCallBackProc<T>);
var
  i: Integer;
begin
  for i := Low(AValueArray) to High(AValueArray) do
  begin
    AProc(AValueArray[i]);
  end;
end;

// 功能: 在传入的数组末尾追加一个元素
// 参数：
//   - var AValueArray: TArray<T>  要处理的数组
//   - AValue: T  追加的元素
class procedure TArrayHelper.Add<T>(var AValueArray: TArray<T>; AValue: T);
begin
  Append<T>(AValueArray, AValue);
end;

// 功能: 在传入的数组末尾追加一个元素
// 参数：
//   - var AValueArray: TArray<T>  要处理的数组
//   - AValue: T  追加的元素
class procedure TArrayHelper.Append<T>(var AValueArray: TArray<T>; AValue: T);
begin
  SetLength(AValueArray, Length(AValueArray) + 1);
  AValueArray[High(AValueArray)] := AValue;
end;

// 功能: 删除传入的数组中指定索引位置的元素
// 参数：
//   - var AValueArray: TArray<T>  要处理的数组
//   - AIndex: Integer  要删除的元素的索引位置
// 说明：
//      1. 如果数组长度已经为0，直接返回
//      2. 如果索引无效，即 AIndex < Low(AValueArray) or AIndex > High(AValueArray)
//         会抛出 EArgumentOutOfRangeException异常
class procedure TArrayHelper.Delete<T>(var AValueArray: TArray<T>;
  AIndex: Integer);
begin
  if Length(AValueArray) < 1 then
  begin
    SetLength(AValueArray, 0);
    Exit;
  end;

  if not InRange(AIndex, Low(AValueArray), High(AValueArray)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);

  if AIndex < High(AValueArray) then
  begin
    Move(AValueArray[AIndex + 1], AValueArray[AIndex], (High(AValueArray) - AIndex) *
      SizeOf(T));
  end;

  SetLength(AValueArray, Length(AValueArray) - 1);
end;

// 功能: 对传入数组中的每一个参数依次执行回调函数AProc，并将执行AProc的返回值赋给数组元素
// 参数：
//   - var AValueArray: array of T  要处理的数组
//   - AProc: TCallBackFunc<T>  对元素执行的回调函数
class procedure TArrayHelper.ForEach<T>(var AValueArray: array of T;
  AFunc: TCallBackFunc<T>);
var
  i: Integer;
begin
  for i := Low(AValueArray) to High(AValueArray) do
  begin
    AValueArray[i] := AFunc(AValueArray[i]);
  end;
end;

// 功能: 从后往前依次释放数组中的对象元素
class procedure TArrayHelper.FreeAllItems<T>(var AValueArray: array of T);
var
  i: Integer;
begin
  for i := High(AValueArray) downto Low(AValueArray) do
  begin
    if Assigned(AValueArray[i]) then
      AValueArray[i].Free;
  end;
end;

// 功能: 在传入的数组中从第一个元素开始，找到第一个与指定元素相等的元素的位置
// 参数：
//   - AValueArray: array of T  要处理的数组
//   - AValue: T 要进行比对的元素
// 返回值：Integer 找到的元素在数组中的索引，如果没有找到就返回值-1
class function TArrayHelper.IndexOf<T>(AValueArray: array of T;
  AValue: T): Integer;
var
  Comparer: IComparer<T>;
begin
  Comparer := TComparer<T>.Default;
  try
    Result := IndexOf<T>(AValueArray, AValue, TComparer<T>.Default);
  finally
    FreeAndNil(Comparer);
  end;
end;

// 功能: 在传入的数组中从第一个元素开始，找到第一个与指定元素相等的元素的位置
// 参数：
//   - AValueArray: array of T  要处理的数组
//   - AValue: T 要进行比对的元素
//   - ACompare: IComparer<T> 用于进行比较的函数接口
// 返回值：Integer 找到的元素在数组中的索引，如果没有找到就返回值-1
class function TArrayHelper.IndexOf<T>(AValueArray: array of T; AValue: T;
  ACompare: IComparer<T>): Integer;
var
  i: Integer;
begin
  Result := -1;

  if Length(AValueArray) = 0 then
    Exit;

  if not Assigned(ACompare) then
    raise EArgumentNilException.CreateResFmt(@SParamIsNil, ['ACompare']);

  for i := Low(AValueArray) to High(AValueArray) do
  begin
    if ACompare.Compare(AValueArray[i], AValue) = 0 then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

// 功能: 在传入的数组中指定索引位置插入一个新元素，原位置及其之后的元素均后移一位
// 参数：
//   - var AValueArray: TArray<T>  要处理的数组
//   -  AValue: T 要插入的元素
//   - AIndex: Integer  要插入的元素的索引位置
// 说明：
//      1. 如果索引无效，即 AIndex < Low(AValueArray) or AIndex > High(AValueArray) + 1
//         会抛出 EArgumentOutOfRangeException异常
class procedure TArrayHelper.Insert<T>(var AValueArray: TArray<T>; AValue: T;
  AIndex: Integer);
begin
  if not InRange(AIndex, Low(AValueArray), High(AValueArray) + 1) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);

  SetLength(AValueArray, Length(AValueArray) + 1);

  if AIndex < High(AValueArray) then
    Move(AValueArray[AIndex], AValueArray[AIndex + 1], (High(AValueArray) - AIndex) *
      SizeOf(T));

  AValueArray[AIndex] := AValue;
end;

// 功能: 检查传入的值是否在指定数组中
// 参数：
//   - var AValueArray: TArray<T>  要处理的数组
//   -  AValue: T 检查的值
//   - ACompare: IComparer<T>  用于比较的接口
class function TArrayHelper.IsMember<T>(AValueArray: array of T; AValue: T;
  ACompare: IComparer<T>): Boolean;
begin
  Result := IndexOf<T>(AValueArray, AValue, ACompare) >= 0;
end;

// 功能: 检查传入的值是否在指定数组中
// 参数：
//   - var AValueArray: TArray<T>  要处理的数组
//   -  AValue: T 检查的值
class function TArrayHelper.IsMember<T>(AValueArray: array of T;
  AValue: T): Boolean;
begin
  Result := IsMember<T>(AValueArray, AValue, TComparer<T>.Default);
end;

// 功能: 将传入的数组进行翻转
// 参数：
//   - var AValueArray: array of T  要处理的数组
class procedure TArrayHelper.Reverse<T>(var AValueArray: array of T);
var
  i: Integer;
  temp: T;
begin
  if Length(AValueArray) < 2 then
  begin
    Exit;
  end;

  for i := Low(AValueArray) to ((High(AValueArray) + Low(AValueArray)) shr 1) do
  begin
    temp := AValueArray[i];
    AValueArray[i] := AValueArray[High(AValueArray) - i];
    AValueArray[High(AValueArray) - i] := temp;
  end;
end;

// 功能: 检查一个整数值是否在指定的最小值和最大值范围内。
// 参数：
//   - AValue: const Integer - 要检查的整数值。
//   - AMin: const Integer - 范围的最小值。
//   - AMax: const Integer - 范围的最大值。
//   - AIsIncludeBound: Boolean = True 是否包含边界
// 返回值：
//   - Boolean - 如果 AValue 在 [AMin, AMax] 范围内，则返回 True，否则返回 False。
function InRange(const AValue, AMin, AMax: Integer; AIsIncludeBound: Boolean = True):
  Boolean;
begin
  if AIsIncludeBound then
    Result := (AValue >= AMin) and (AValue <= AMax)
  else
    Result := (AValue > AMin) and (AValue < AMax);
end;

end.

