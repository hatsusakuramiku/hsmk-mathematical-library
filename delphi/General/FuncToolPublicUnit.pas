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

{*这个单元提供一些通用的函数或过程，使用的所有非自定义单元都是Delphi提供的系统单元*}
unit FuncToolPublicUnit;

interface

uses
  {*Delphi系统单元*}
  System.SysUtils, System.Variants, System.Generics.Defaults,
  System.Classes, System.UITypes, System.Generics.Collections,
  {*自定义单元*}
  GeneralTypeUnit;

{String Function}
function StrIsEmpty(var Str: string): Boolean; overload;
function StrIsEmpty(const Str: string; var TrimedStr: string): Boolean; overload;
function StrTrimIsEmpty(const Str: string): Boolean;
function PosIndex(const SubStr, Str: string; Index: Integer; AIsOverlap: Boolean =
  False): Integer;
function LeftCut(const ASourceStr: string; const ALen: Integer): string;
function LeftCutBySplitter(const ASourceStr, ASplitter: string): string;
function RightCut(const ASourceStr: string; const ALen: Integer): string;
function RightCutBySplitter(const ASourceStr, ASplitter: string): string;
function QuotedStrSQL(const S: string): string;

{Array Function}
type
  TElemToStringFunc<T> = reference to function(AElem: T): string;
  TElemGenerator<T> = reference to function: T;
  TEachItemFunc<T> = reference to procedure(var AItem: T);

  TArrayUtils = class
  private
    // 因为在测试以确定MAXVALIDARRAYLEN的值时，只运行了BuildString这一个函数 ，
    // 所以这个值应该是个相当乐观的估计。实际调用时有可能出现数组长度小于MAXVALIDARRAYLEN
    // 仍出现栈溢出现象，因此建议仅在数组长度较小（5000以内）时使用此类提供的数组
    // 转字符串的方法
{$IFDEF CPUX86}
    const MAXVALIDARRAYLEN: Integer = $03D090;
{$ELSEIF DEFINED(CPUX64)}
    const MAXVALIDARRAYLEN: Integer = $07A120;
{$ELSE}
    const MAXVALIDARRAYLEN: Integer = $03D090;
{$ENDIF}
  public
    // Array to string
    class function GetMaxVaildArrayLen: Integer; static;
    class function BuildString<T>(AElemToStringFunc: TElemToStringFunc<T>; const
      AArray: array of T; const ASplitter: string; const APrefix: string; const ASuffix:
      string): string; static;
    class function IntArrayToString(AIntArr: array of Integer; const ASplitter: string =
      ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function IntArrayToStringF(const AFormat: string; AIntArr: array of Integer;
      const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string =
      ']'): string; static;
    class function FloatArrayToString(AFloatArr: array of Extended; const ASplitter:
      string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
      static;
    class function FloatArrayToStringF(const AFormat: string; AFloatArr: array of
      Extended; const ASplitter: string = ','; const APrefix: string = '['; const
      ASuffix: string = ']'): string; static;
    class function StringArrayToString(AStrArray: array of string; const ASplitter:
      string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
      static;
    class function ObjectListToString(AObjList: array of TObject; const ASplitter:
      string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
      static;
    // Generate Array
    class function GenerateArray<T>(const ALen: Integer; GetElemFunc:
      TElemGenerator<T>): TArray<T>; static;
    class function SplitStrToArray(const SrcStr, Splitter: string): TStringArray;
      static;
    // Convert
    class function ListToArray<T>(AList: TList<T>): TArray<T>; static;
    class function ArrayToList<T>(AArray: array of T): TList<T>; static;
    // Other
    class procedure ReverseAeery<T>(var AArray: array of T); static;
    class function IsMember<T>(AItem: T; AArray: array of T): Boolean; overload;
      static;
    class function IsMember<T>(AItem: T; AArray: array of T; CompareFunc:
      IComparer<T>): Boolean; overload; static;

    class procedure ForEach<T>(var AArray: array of T; AEachFunc: TEachItemFunc<T>);
      overload;
  end;

{类三元运算}
// 实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 部分重载已在System.Math中实现，为避免冲突，在此处实现其余重载
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: string): string;
  overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Pointer): Pointer;
  overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TObject): TObject;
  overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Char): Char; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: AnsiString): AnsiString;
  overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TDateTime): TDateTime;
  overload;

// 实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
procedure IfThen(var AResult: Integer; ACondition: Boolean; ATrueValue, AFalseValue:
  Integer); overload;
procedure IfThen(var AResult: string; ACondition: Boolean; ATrueValue, AFalseValue:
  string); overload;
procedure IfThen(var AResult: Extended; ACondition: Boolean; ATrueValue, AFalseValue:
  Extended); overload;
procedure IfThen(var AResult: Pointer; ACondition: Boolean; ATrueValue, AFalseValue:
  Pointer); overload;
procedure IfThen(var AResult: TObject; ACondition: Boolean; ATrueValue, AFalseValue:
  TObject); overload;
procedure IfThen(var AResult: Char; ACondition: Boolean; ATrueValue, AFalseValue: Char);
  overload;
procedure IfThen(var AResult: Int64; ACondition: Boolean; ATrueValue, AFalseValue:
  Int64); overload;
procedure IfThen(var AResult: Double; ACondition: Boolean; ATrueValue, AFalseValue:
  Double); overload;
procedure IfThen(var AResult: AnsiString; ACondition: Boolean; ATrueValue, AFalseValue:
  AnsiString); overload;
procedure IfThen(var AResult: TDateTime; ACondition: Boolean; ATrueValue, AFalseValue:
  TDateTime); overload;

{Color Function}

function RGB(const R, G, B: Byte): TColor;
function ARGB(const A, R, G, B: Byte): TColor;
function ColorToRRGGBBStr(AColor: TColor): string;
function ColorToAARRGGBBStr(AColor: TColor): string;
function AARRGGBBStrToColor(AStr: string; ADefaultColor: LongWord = $FFFFFFFF): TColor;
function RRGGBBStrToColor(AStr: string; ADefaultColor: LongWord = $FFFFFFFF): TColor;

{Other Function}
// 检查输入的值是否在范围内，如果在就返回原始值，如果不在就返回设定的默认值
function CheckInRange(AInput, AMin, AMax: Integer; ADefaultValue: Integer = -1):
  Integer; overload;
function CheckInRange(AInput, AMin, AMax: Int64; ADefaultValue: Int64 = -1): Int64;
  overload;
function CheckInRange(AInput, AMin, AMax: Single; ADefaultValue: Single = -1): Single;
  overload;
function CheckInRange(AInput, AMin, AMax: Double; ADefaultValue: Double = -1): Double;
  overload;
function CheckInRange(AInput, AMin, AMax: Extended; ADefaultValue: Extended = -1):
  Extended; overload;
function CheckInRange(AInput, AMin, AMax: NativeInt; ADefaultValue: NativeInt = 0):
  NativeInt; overload;
function CheckInRange(AInput, AMin, AMax: NativeUInt; ADefaultValue: NativeUInt = 0):
  NativeUInt; overload;
function CheckInRange(AInput, AMin, AMax: UInt64; ADefaultValue: UInt64 = 0): UInt64;
  overload;
function CheckInRange(AInput, AMin, AMax: Char; ADefaultValue: Char = #0): Char;
  overload;
function CheckInRange(AInput, AMin, AMax: Cardinal; ADefaultValue: Cardinal = 0):
  Cardinal; overload;
function CheckInRange(AInput, AMin, AMax: Byte; ADefaultValue: Byte = 0): Byte;
  overload;
function CheckInRange(AInput, AMin, AMax: Word; ADefaultValue: Word = 0): Word;
  overload;

implementation

uses
  System.Math, System.RTLConsts, ExceptionStrConstsUnit;

{String}
// 功能：判断输入的Str是否为空
// 参数：var Str: string  输入的字符串，其值为执行Trim后的值
// 返回值：True - 输入的Str为空；False - 输入的不为空
function StrIsEmpty(var Str: string): Boolean;
begin
  Str := Trim(Str);
  Result := Str = '';
end;

// 功能：判断输入的Str是否为空，如果不为空就将其值赋给TrimedStr
// 参数：
//    - const Str: string     输入的字符串
//    - var TrimedStr: string 接收结果返回，如果Str为空则不会改变其值
// 返回值：True - 输入的Str为空；False - 输入的不为空
function StrIsEmpty(const Str: string; var TrimedStr: string): Boolean;
var
  temp: string;
begin
  temp := Str;
  Result := StrIsEmpty(temp);
  if not Result then
    TrimedStr := temp;
end;

// 功能：判断输入的Str是否为空
// 参数：const Str: string  输入的字符串
// 返回值：True - 输入的Str为空；False - 输入的不为空
function StrTrimIsEmpty(const Str: string): Boolean;
begin
  Result := Trim(Str) = '';
end;

// 功能：在字符串 Str 中查找子字符串 SubStr，从指定的 Index 位置开始，并考虑是否允许重叠。
// 参数：
//   - SubStr: string          要查找的子字符串
//   - Str: string              要在其中查找的源字符串
//   - Index: Integer           查找的起始“计数”，表示要找到第几个匹配项。
//                              例如：Index = 1 表示查找第一个匹配项，Index = 2 表示查找第二个匹配项，以此类推。
//   - AIsOverlap: Boolean = False  是否允许子字符串重叠。
//                                  如果为 True，则每次查找都从上一次匹配位置的下一个字符开始。
//                                  如果为 False，则每次查找都从上一次匹配的结束位置的下一个字符开始。
// 返回值：
//   - Integer：找到的子字符串 SubStr 在源字符串 Str 中的起始位置（从 1 开始计数）。
//              如果找不到，或者参数无效，则返回 0。
function PosIndex(const SubStr, Str: string; Index: Integer; AIsOverlap: Boolean =
  False): Integer;
var
  iPos, iSubStrLen, iStrLen, iSplitLen: Integer;
begin
  Result := 0;
  iSubStrLen := Length(SubStr);
  iStrLen := Length(Str);

  if (iSubStrLen = 0) or (iStrLen = 0) or (Index < 1) or (Index > iStrLen) then
    Exit;

  iPos := 0;
  iSplitLen := IfThen(AIsOverlap, 1, iSubStrLen);

  while Index > 0 do
  begin
    iPos := Pos(SubStr, Str, iPos + iSplitLen);

    if iPos > 0 then
      Dec(Index)
    else
      Break;
  end;

  if Index = 0 then
    Result := iPos;
end;

{Array Function}
// 功能：生成指定长度的随机整数数组
// 参数：
//  - const ANum: Integer       生成的数组的长度
//  - const AMin: Integer = 0   元素取值的最小值
//  - const AMax: Integer = 100 元素取值的最大值
// 返回值类型：TIntegerArray 生成的随机整数数组
function GenerateRandomIntegerArray(const ANum: Integer; const AMin: Integer = 0; const
  AMax: Integer = 100): TIntegerArray;
var
  i: Integer;
begin
  if ANum < 0 then
    raise EInvalidArgument.CreateResFmt(@SParamIsNegative, ['ANum']);

  if AMin > AMax then
    raise EInvalidArgument.CreateResFmt(@sParamGreaterEqual, ['AMax', 'AMin']);

  SetLength(Result, ANum);
  for i := Low(Result) to High(Result) do
  begin
    Randomize;
    Result[i] := Random(AMax - AMin + 1) + AMin;
  end;

end;

// 功能：生成指定长度的随机实数数组
// 参数：
//  - const ANum: Integer       生成的数组的长度
//  - const AMin: Integer = 0.0   元素取值的最小值
//  - const AMax: Integer = 100.0 元素取值的最大值（取不到）
// 返回值类型：TIntegerArray 生成的随机实数数组
function GenerateRandomExtendedArray(const ANum: Integer; const AMin: Extended = 0.0;
  const AMax: Extended = 100.0): TExtendedArray;
var
  i: Integer;
begin
  if ANum < 0 then
    raise EInvalidArgument.CreateResFmt(@SParamIsNegative, ['ANum']);

  if AMin > AMax then
    raise EInvalidArgument.CreateResFmt(@sParamGreaterEqual, ['AMax', 'AMin']);
  ;

  SetLength(Result, ANum);
  for i := Low(Result) to High(Result) do
  begin
    Randomize;
    Result[i] := Random() * AMax + AMin;
  end;
end;

class function TArrayUtils.ArrayToList<T>(AArray: array of T): TList<T>;
var
  i: Integer;
begin
  Result := TList<T>.Create;
  for i := Low(AArray) to High(AArray) do
    Result.Add(AArray[i]);
end;

// class function BuildString<T>: 将动态数组按指定方式拼接成字符串
// 参数:
//   - AElemToStringFunc: TElemToStringFunc<T> - 将动态数组元素转换为字符串的函数委托
//   - const AArray: array of T                - 输入的动态数组
//   - const ASplitter: string                 - 元素之间的分隔符，默认为 ','
//   - const APrefix: string                   - 结果字符串的前缀，默认为 '['
//   - const ASuffix: string                   - 结果字符串的后缀，默认为 ']'
// 返回值: string - 拼接后的字符串
// 异常:
//   - Exception: 如果数组长度超过 GetMaxVaildArrayLen 定义的最大值，则抛出异常，防止栈溢出风险。
// 备注:
//   - 使用 TStringBuilder 来高效构建字符串，避免多次内存分配。
//   - 适用于将任何类型的数组（通过 AElemToStringFunc 转换）拼接成一个格式化的字符串。
// 示例:
//   var
//     sStr: string;
//   begin
//     sStr := TArrayUtils.BuildString<Integer>(
//                           function(AElem: Integer): string
//                           begin
//                             Result := '>' + IntToStr(AElem) + '<';
//                           end,
//                           [1, 2, 3, 4], ', ', '[', ']');
//   end;
//   // sStr 结果: '[>1<, >2<, >3<, >4<]'
class function TArrayUtils.BuildString<T>(AElemToStringFunc: TElemToStringFunc<T>; const
  AArray: array of T; const ASplitter: string; const APrefix: string; const ASuffix:
  string): string;
var
  StringBuilder: TStringBuilder;
  i, Count, LowIndex, HighIndex: Integer;
  ElemStr: string;
begin
  Count := Length(AArray);
  if Count > GetMaxVaildArrayLen then
    raise
      EArgumentOutOfRangeException.CreateFmt('数组长度(%d)超过最大可允许长度(%d)，可能造成栈溢出风险，请选用其他方法或自行实现！', [Count, GetMaxVaildArrayLen]);

  StringBuilder := TStringBuilder.Create;
  try
    StringBuilder.Append(APrefix);

    if Count = 0 then
    begin
      StringBuilder.Append(ASuffix);
    end
    else
    begin
      LowIndex := Low(AArray);
      HighIndex := High(AArray);

      for i := LowIndex to HighIndex do
      begin
        // 在此处需要频繁调用AElemToStringFunc，数组长度过大时可能造成栈溢出
        ElemStr := AElemToStringFunc(AArray[i]);
        StringBuilder.Append(ElemStr);

        if i < HighIndex then
          StringBuilder.Append(ASplitter);
      end;

      StringBuilder.Append(ASuffix);
    end;

    Result := StringBuilder.ToString;
  finally
    StringBuilder.Free;
  end;
end;

// 功能：将整数数组转换成字符串，可自定义前后缀和分隔符
// 参数：
//  - AIntArr: array of Integer     输入的整数数组
//  - const ASplitter: string = ',' 分隔符
//  - const APrefix: Char = '['     前缀
//  - const ASuffix: Char = ']'     后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.IntArrayToString([1, 2, 3, 4], ', ', '[', ']') -> '[1, 2, 3, 4]'
class function TArrayUtils.IntArrayToString(AIntArr: array of Integer; const ASplitter:
  string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
begin
  Result := BuildString<Integer>(
    function(AElem: Integer): string
    begin
      Result := IntToStr(AElem);
    end,
    AIntArr, ASplitter, APrefix, ASuffix);
end;

// 功能：将整数数组以指定格式转换成字符串，可自定义前后缀和分隔符
// 参数：
//  - AIntArr: array of Integer     输入的整数数组
//  - const AFormat: string         自定义格式，与FormatFloat的格式兼容
//  - const ASplitter: string = ',' 分隔符
//  - const APrefix: string = '['     前缀
//  - const ASuffix: string = ']'     后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.IntArrayToStringF('0.0', [1, 2, 3, 4], '0.0', ', ', '[', ']') -> '[1.0, 2.0, 3.0, 4.0]'
class function TArrayUtils.IntArrayToStringF(const AFormat: string; AIntArr: array of
  Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix:
  string = ']'): string;
begin
  Result := BuildString<Integer>(
    function(AElem: Integer): string
    begin
      Result := FormatFloat(AFormat, AElem);
    end,
    AIntArr, ASplitter, APrefix, ASuffix);
end;

// 功能：判断一个元素是否存在于一个动态数组中。
// 参数：
//   AItem: T - 要查找的元素。
//   AArray: array of T - 要在其中查找元素的动态数组。
//   CompareFunc: TGenericCompareFunc<T> - 用于比较两个元素的泛型比较函数。
//                当两个元素相等时，该函数应返回 0。
// 返回值：Boolean - 如果元素存在于数组中，则返回 True；否则返回 False。
class function TArrayUtils.IsMember<T>(AItem: T; AArray: array of T;
  CompareFunc: IComparer<T>): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not (Assigned(CompareFunc) and (Length(AArray) > 0)) then
    Exit;

  for i := Low(AArray) to High(AArray) do
  begin
    if CompareFunc.Compare(AItem, AArray[i]) = 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

// 功能：判断一个元素是否是泛型数组的成员。
// 参数：
//   - AItem: T                  要查找的元素。
//   - AArray: array of T        要搜索的泛型数组。
// 返回值类型：Boolean          如果元素是数组的成员，则返回 True；否则返回 False。
// 示例：
//   var
//     myArray: array of Integer;
//     isMember: Boolean;
//   begin
//     SetLength(myArray, 3);
//     myArray[0] := 1;
//     myArray[1] := 2;
//     myArray[2] := 3;
//     isMember := TArrayUtils.IsMember<Integer>(2, myArray); // isMember 将会是 True
//   end;
class function TArrayUtils.IsMember<T>(AItem: T; AArray: array of T): Boolean;
var
  i: Integer;
begin
  // 初始化结果为 False，假设元素不在数组中。
  Result := False;
  if Length(AArray) = 0 then
    Exit;

  // 循环遍历数组中的每一个元素。
  for i := Low(AArray) to High(AArray) do
  begin
    // 使用 TComparer<T>.Default.Compare 进行比较。
    // TComparer<T>.Default  提供了默认的比较器，它会根据 T 的类型使用合适的比较方法。
    // 对于基本类型，例如 Integer, String, Boolean，它使用 = 运算符。
    // 对于类，它使用 Equals 方法（如果已定义），或者比较引用。
    // Compare 方法返回 0 表示相等，负数表示 AItem 小于 AArray[i]，正数表示大于。
    if TComparer<T>.Default.Compare(AItem, AArray[i]) = 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

class function TArrayUtils.ListToArray<T>(AList: TList<T>): TArray<T>;
var
  i: Integer;
begin
  SetLength(Result, AList.Count);
  for i := 0 to AList.Count - 1 do
    Result[i] := AList[i];
end;

// 功能：TObject数组拼接字符串，可自定义前后缀和分隔符
// 参数：
//  - AObjList: array of TObject    输入的TObject数组
//  - const ASplitter: string = ',' 分隔符
//  - const APrefix: string = '['   前缀
//  - const ASuffix: string = ']'   后缀
// 返回值类型：string 转成的字符串
// 注意：数组元素转成字符串使用的是其自身的ToString方法
class function TArrayUtils.ObjectListToString(AObjList: array of TObject;
  const ASplitter, APrefix, ASuffix: string): string;
begin
  Result := BuildString<TObject>(
    function(AElem: TObject): string
    begin
      Result := AElem.ToString;
    end,
    AObjList, ASplitter, APrefix, ASuffix);
end;

// 功能：反转数组
// 参数：
//   - var AArray: array of T 待反转的数组
class procedure TArrayUtils.ReverseAeery<T>(var AArray: array of T);
var
  i, iMaxIndex: Integer;
  SwapBuffer: T;
begin
  iMaxIndex := High(AArray);
  for i := Low(AArray) to ((Low(AArray) + iMaxIndex) shr 1) do
  begin
    SwapBuffer := AArray[i];
    AArray[i] := AArray[iMaxIndex - i];
    AArray[iMaxIndex - i] := SwapBuffer;
  end;
end;

// 功能：将浮点数数组转换成字符串，可自定义前后缀和分隔符
// 参数：
//  - AIntArr: array of Extended      输入的浮点数数组
//  - const ASplitter: string = ','   分隔符
//  - const APrefix: string = '['     前缀
//  - const ASuffix: string = ']'     后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.FloatArrayToString([1.0, 2.0, 3.0, 4.0], ', ', '[', ']') -> '[1, 2, 3, 4]'
class function TArrayUtils.FloatArrayToString(AFloatArr: array of Extended; const
  ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'):
  string;
begin
  Result := BuildString<Extended>(
    function(AElem: Extended): string
    begin
      Result := FloatToStr(AElem);
    end,
    AFloatArr, ASplitter, APrefix, ASuffix);
end;

// 功能：将浮点数数组以指定格式转换成字符串，可自定义前后缀和分隔符
// 参数：
//  - AIntArr: array of Extended      输入的浮点数数组
//  - const AFormat: string           自定义格式，与FormatFloat的格式兼容
//  - const ASplitter: string = ','   分隔符
//  - const APrefix: string = '['     前缀
//  - const ASuffix: string = ']'     后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.FloatArrayToStringF('0.#', [1.0, 2.0, 3.0, 4.0], ', ', '[', ']') -> '[1, 2, 3, 4]'
class function TArrayUtils.FloatArrayToStringF(const AFormat: string; AFloatArr: array
  of Extended;
  const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string =
    ']'): string;
begin
  Result := BuildString<Extended>(
    function(AElem: Extended): string
    begin
      Result := FormatFloat(AFormat, AElem);
    end,
    AFloatArr, ASplitter, APrefix, ASuffix);
end;

class procedure TArrayUtils.ForEach<T>(var AArray: array of T;
  AEachFunc: TEachItemFunc<T>);
var
  i: Integer;
begin
  if not Assigned(AEachFunc) then
  begin
    raise EArgumentNilException.CreateResFmt(@SParamIsNil, ['AEachFunc'])
  end;

  for i := Low(AArray) to High(AArray) do
  begin
    AEachFunc(AArray[i]);
  end;
end;

//class function TArrayUtils.GetArraySortUtilsObject<T>(
//  ACompareFunc: TCompareFunction): TArraySortUtils<T>;
//begin
//  Result := TArraySortUtils<T>.Create(ACompareFunc);
//end;

// 功能：获取能支持的将数组转化成字符串的最大长度
class function TArrayUtils.GetMaxVaildArrayLen: Integer;
begin
  Result := TArrayUtils.MAXVALIDARRAYLEN;
end;

// 功能：将一个字符串按照指定的分割符分割成一个字符串数组。
// 参数：
//   - SrcStr: string      要分割的字符串。
//   - Splitter: string    分割符。
// 返回值类型：TStringArray (TArray<string>)  分割后的字符串数组。
// 示例：
//   var
//     myString: string;
//     myArray: TStringArray;
//     i: Integer;
//   begin
//     myString := 'apple,banana,cherry';
//     myArray := TArrayUtils.SplitStrToArray(myString, ',');
//     for i := 0 to High(myArray) do
//       ShowMessage(myArray[i]); // 显示 "apple", "banana", "cherry"
//   end;
class function TArrayUtils.SplitStrToArray(const SrcStr,
  Splitter: string): TStringArray;
var
  EndIndex, StartIndex: Integer;
  ResultList: TList<string>;
  SrcStrLen: Integer;
begin
  ResultList := TList<string>.Create;
  try
    SrcStrLen := Length(SrcStr);
    StartIndex := 1;

    while StartIndex <= SrcStrLen do
    begin
      EndIndex := Pos(Splitter, SrcStr, StartIndex);
      if EndIndex = 0 then
      begin
        if StartIndex <= SrcStrLen then
        begin
          ResultList.Add(Copy(SrcStr, StartIndex, SrcStrLen - StartIndex + 1));
        end;
        Break;
      end;

      ResultList.Add(Copy(SrcStr, StartIndex, EndIndex - StartIndex));

      StartIndex := EndIndex + Length(Splitter);
    end;

    Result := ListToArray<string>(ResultList);

  finally
    ResultList.Free;
  end;
end;

// 功能: 将字符串的数组拼接成一个字符串,可自行指定前缀、后缀、中间分隔符
// 参数：
//  - AStrArray: array of string   输入的字符串数组
//  - const ASplitter: string = ',' 分隔符
//  - const APrefix: string = '['   前缀
//  - const ASuffix: string = ']'   后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.StringArrayToString(['1.0', '2.0', '3.0', '4.0'], ', ', '[', ']') -> '[1, 2, 3, 4]'
class function TArrayUtils.StringArrayToString(AStrArray: array of string; const
  ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'):
  string;
var
  StringBuilder: TStringBuilder;
  i, Count, LowIndex, HighIndex: Integer;
begin
  Count := Length(AStrArray);
  if Count > GetMaxVaildArrayLen then
    raise Exception.Create('数组长度超过最大可允许长度，可能造成栈溢出风险，请选用其他方法或自行实现！');

  StringBuilder := TStringBuilder.Create;
  try
    StringBuilder.Append(APrefix);

    if Count = 0 then
    begin
      StringBuilder.Append(ASuffix);
    end
    else
    begin
      LowIndex := Low(AStrArray);
      HighIndex := High(AStrArray);

      for i := LowIndex to HighIndex - 1 do
      begin
        StringBuilder.Append(AStrArray[i]);
        StringBuilder.Append(ASplitter);
      end;

      StringBuilder.Append(AStrArray[HighIndex]);

      StringBuilder.Append(ASuffix);
    end;

    Result := StringBuilder.ToString;
  finally
    StringBuilder.Free;
  end;
end;

// 功能: 使用传入的元素生成函数，生成指定长度的数组
// 参数：
//  - const ALen: Integer             要生成的数组长度
//  - GetElemFunc: TElemGenerator<T>  生成数组元素的函数
// 返回值类型：TArray<T> 生成的数组
class function TArrayUtils.GenerateArray<T>(const ALen: Integer; GetElemFunc:
  TElemGenerator<T>): TArray<T>;
var
  i: Integer;
begin
  if ALen < 1 then
    Exit;

  if ALen > GetMaxVaildArrayLen then
    raise Exception.Create('数组长度超过最大可允许长度，可能造成栈溢出风险，请选用其他方法或自行实现！');

  SetLength(Result, ALen);
  for i := 0 to ALen - 1 do
  begin
    Result[i] := GetElemFunc;
  end;
end;

// 功能：从字符串的左侧截取指定长度的子字符串。
// 参数：
//   - const ASourceStr: string 源字符串；
//   - const ALen: Integer      要截取的长度。
// 返回：截取后的字符串，如果ALen <= 0则返回空字符串。
function LeftCut(const ASourceStr: string; const ALen: Integer): string;
begin
  if ALen <= 0 then
  begin
    Result := '';
    Exit;
  end;

  Result := Copy(ASourceStr, 1, Min(Length(ASourceStr), ALen));
end;

// 功能：从字符串的右侧截取指定长度的子字符串。
// 参数：
//   - const ASourceStr: string 源字符串；
//   - const ALen: Integer      要截取的长度。
// 返回：截取后的字符串，如果ALen <= 0则返回空字符串。
function RightCut(const ASourceStr: string; const ALen: Integer): string;
begin
  if ALen <= 0 then
  begin
    Result := '';
    Exit;
  end;

  Result := Copy(ASourceStr, Max(1, Length(ASourceStr) - ALen + 1),
    Min(Length(ASourceStr), ALen));
end;

// 功能：从字符串的第一个指定分隔符处开始，返回该分隔符之后的部分。
//       如果源字符串中不存在指定的分隔符，或者分隔符在字符串的开头，
//       则返回空字符串或剩余部分。
// 参数：
//   - const ASourceStr: string 源字符串；需要被处理的原始字符串。
//   - const ASplitter: string  分隔符。用于在源字符串中查找的分割字符串。
// 返回值：
//   - string：截取后的字符串，即第一个分隔符之后的部分。
//             如果源字符串为空、分隔符为空、分隔符比源字符串长，或者找不到分隔符，
//             则直接返回源字符串
function RightCutBySplitter(const ASourceStr, ASplitter: string): string;
var
  iStrLen, iSplitterLen, iPosIndex: Integer;
begin
  iStrLen := Length(ASourceStr);
  iSplitterLen := Length(ASplitter);
  Result := ASourceStr;

  if (iStrLen = 0) or (iSplitterLen = 0) or (iSplitterLen > iStrLen) then
  begin
    Exit;
  end;
  iPosIndex := Pos(ASplitter, ASourceStr);
  if iPosIndex <= 0 then
    Exit;

  Result := RightCut(ASourceStr, iStrLen - iPosIndex - iSplitterLen + 1);
end;

// 功能：对字符串进行 SQL 安全的引号包裹处理，确保字符串可以在 SQL 语句中安全地使用。
//       特别是处理了方括号 '[' 和 ']'，将它们转义并用方括号包裹。仅适用于SQL Server
// 参数：
//   - S: const string  待处理的原始字符串。
// 返回值：
//   - string           经过 SQL 安全处理后的字符串，前后会被加上方括号 '[' 和 ']'，
//                      并且原字符串中的 '[' 和 ']' 会被转义（再次插入一个 '[' 或 ']'）。
function QuotedStrSQL(const S: string): string;
var
  I: Integer;
begin
  Result := S;

  for I := Result.Length - 1 downto 0 do
    if Result.Chars[I] = '[' then
      Result := Result.Insert(I, '[');

  for I := Result.Length - 1 downto 0 do
    if Result.Chars[I] = ']' then
      Result := Result.Insert(I, ']');

  Result := '[' + Result + ']';
end;

// 功能：从字符串的第一个指定分隔符处开始，返回该分隔符之前的部分。
//       如果源字符串中不存在指定的分隔符，或者分隔符在字符串的末尾，
//       则返回空字符串或剩余部分。
// 参数：
//   - const ASourceStr: string 源字符串；需要被处理的原始字符串。
//   - const ASplitter: string  分隔符。用于在源字符串中查找的分割字符串。
// 返回值：
//   - string：截取后的字符串，即第一个分隔符之后的部分。
//             如果源字符串为空、分隔符为空、分隔符比源字符串长，或者找不到分隔符，
//             则直接返回源字符串
function LeftCutBySplitter(const ASourceStr, ASplitter: string): string;
var
  iStrLen, iSplitterLen, iPosIndex: Integer;
begin
  iStrLen := Length(ASourceStr);
  iSplitterLen := Length(ASplitter);
  Result := ASourceStr;

  if (iStrLen = 0) or (iSplitterLen = 0) or (iSplitterLen > iStrLen) then
  begin
    Exit;
  end;
  iPosIndex := Pos(ASplitter, ASourceStr);
  if iPosIndex <= 0 then
    Exit;

  Result := LeftCut(ASourceStr, iPosIndex - 1);
end;

{类三元运算}
// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Integer  条件为True时的返回值
//   - AFalseValue: Integer 条件为False时的返回值
//function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Integer): Integer; overload;
//begin
//  if ACondition then
//    Result := ATrueValue
//  else
//    Result := AFalseValue;
//end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: string   条件为True时的返回值
//   - AFalseValue: string  条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: string): string;
  overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean    判断条件
//   - ATrueValue: Extended  条件为True时的返回值
//   - AFalseValue: Extended 条件为False时的返回值
//function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Extended): Extended; overload;
//begin
//  if ACondition then
//    Result := ATrueValue
//  else
//    Result := AFalseValue;
//end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Pointer  条件为True时的返回值
//   - AFalseValue: Pointer 条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Pointer): Pointer;
  overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: TObject  条件为True时的返回值
//   - AFalseValue: TObject 条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TObject): TObject;
  overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Boolean  条件为True时的返回值
//   - AFalseValue: Boolean 条件为False时的返回值
//function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Boolean): Boolean; overload;
//begin
//  if ACondition then
//    Result := ATrueValue
//  else
//    Result := AFalseValue;
//end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Char     条件为True时的返回值
//   - AFalseValue: Char    条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Char): Char; overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean     判断条件
//   - ATrueValue: AnsiString  条件为True时的返回值
//   - AFalseValue: AnsiString 条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: AnsiString): AnsiString;
  overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean    判断条件
//   - ATrueValue: TDateTime  条件为True时的返回值
//   - AFalseValue: TDateTime 条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TDateTime): TDateTime;
  overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: Integer   需要赋值的变量
//   - ACondition: Boolean    判断条件
//   - ATrueValue: Integer    条件为True时的返回值
//   - AFalseValue: Integer   条件为False时的返回值
procedure IfThen(var AResult: Integer; ACondition: Boolean; ATrueValue, AFalseValue:
  Integer); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: string  需要赋值的变量
//   - ACondition: Boolean  判断条件
//   - ATrueValue: string   条件为True时的返回值
//   - AFalseValue: string  条件为False时的返回值
procedure IfThen(var AResult: string; ACondition: Boolean; ATrueValue, AFalseValue:
  string); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: Extended  需要赋值的变量
//   - ACondition: Boolean    判断条件
//   - ATrueValue: Extended   条件为True时的返回值
//   - AFalseValue: Extended  条件为False时的返回值
procedure IfThen(var AResult: Extended; ACondition: Boolean; ATrueValue, AFalseValue:
  Extended); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: Pointer   需要赋值的变量
//   - ACondition: Boolean    判断条件
//   - ATrueValue: Pointer    条件为True时的返回值
//   - AFalseValue: Pointer   条件为False时的返回值
procedure IfThen(var AResult: Pointer; ACondition: Boolean; ATrueValue, AFalseValue:
  Pointer); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: TObject   需要赋值的变量
//   - ACondition: Boolean    判断条件
//   - ATrueValue: TObject    条件为True时的返回值
//   - AFalseValue: TObject   条件为False时的返回值
procedure IfThen(var AResult: TObject; ACondition: Boolean; ATrueValue, AFalseValue:
  TObject); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: Char    需要赋值的变量
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Char     条件为True时的返回值
//   - AFalseValue: Char    条件为False时的返回值
procedure IfThen(var AResult: Char; ACondition: Boolean; ATrueValue, AFalseValue: Char);
  overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: Int64   需要赋值的变量
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Int64    条件为True时的返回值
//   - AFalseValue: Int64   条件为False时的返回值
procedure IfThen(var AResult: Int64; ACondition: Boolean; ATrueValue, AFalseValue:
  Int64); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: Double  需要赋值的变量
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Double   条件为True时的返回值
//   - AFalseValue: Double  条件为False时的返回值
procedure IfThen(var AResult: Double; ACondition: Boolean; ATrueValue, AFalseValue:
  Double); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: AnsiString  需要赋值的变量
//   - ACondition: Boolean      判断条件
//   - ATrueValue: AnsiString   条件为True时的返回值
//   - AFalseValue: AnsiString  条件为False时的返回值
procedure IfThen(var AResult: AnsiString; ACondition: Boolean; ATrueValue, AFalseValue:
  AnsiString); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: TDateTime 需要赋值的变量
//   - ACondition: Boolean    判断条件
//   - ATrueValue: TDateTime  条件为True时的返回值
//   - AFalseValue: TDateTime 条件为False时的返回值
procedure IfThen(var AResult: TDateTime; ACondition: Boolean; ATrueValue, AFalseValue:
  TDateTime); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

{Color Functions}

// 功能： 检查输入的字符串AHixStr的所有字符是否均满足十六进制
function IsAllCharFitHex(AHexStr: string): Boolean;
var
  i: Integer;
  c: Char;
begin
  Result := False;

  for c in UpperCase(AHexStr) do
  begin
    if not CharInSet(c, ['0'..'9', 'A'..'F']) then
      Exit;
  end;
  Result := True;
end;

// 功能： 将红、绿、蓝三个颜色分量组合成一个 TColor 值（不含透明度）。
// 备注： 该函数需要根据编译器宏（如 FMX/VCL）来确定颜色字节的存储顺序（RGB 或 BGR 顺序）。
// 参数:
//  - R Byte 红色分量（0-255）。
//  - G Byte 绿色分量（0-255）。
//  - B Byte 蓝色分量（0-255）。
// 返回值： TColor 表示组合后的颜色值。
function RGB(const R, G, B: Byte): TColor;
begin
{$IFNDEF FMX}
  Result := (R or (G shl 8) or (B shl 16)); // 格式: 00BBGGRR (Win32/VCL)
{$ELSE}
  Result := (B or (G shl 8) or (R shl 16)); // 格式: 00RRGGBB (FMX)
{$ENDIF}
end;

// 功能： 将透明度、红、绿、蓝四个颜色分量组合成一个 TColor 值（含透明度）。
// 备注： 该函数需要根据编译器宏来确定颜色字节的存储顺序（ARGB 或 ABGR 顺序），透明度 A 总是存储在高位（shl 24）。
// 参数:
//  - A Byte 透明度分量（Alpha，0-255）。
//  - R Byte 红色分量（0-255）。
//  - G Byte 绿色分量（0-255）。
//  - B Byte 蓝色分量（0-255）。
// 返回值： TColor 表示组合后的颜色值。
function ARGB(const A, R, G, B: Byte): TColor;
begin
{$IFNDEF FMX}
  Result := (R or (G shl 8) or (B shl 16) or (A shl 24)); // 格式: AABBGGRR (Win32/VCL)
{$ELSE}
  Result := (B or (G shl 8) or (R shl 16) or (A shl 24)); // 格式: AARRGGBB (FMX)
{$ENDIF}
end;

// 功能：将 TColor 类型的颜色值转换为 RRGGBB（红红绿绿蓝蓝）格式的十六进制字符串表示。
// TColor 在 Delphi 中通常是一个 LongWord (32位无符号整数)，其内部存储格式为 AARRGGBB（Alpha 叠加 红色 绿色 蓝色）。
// 这个函数将提取 R, G, B 三个分量，并按照 RRGGBB 的标准顺序组合成字符串。
// 参数：
//   - AColor: TColor              需要转换的颜色值。
// 返回值：
//   - string                     返回格式为 RRGGBB 的十六进制字符串，例如 'FF0000' 表示红色。
function ColorToRRGGBBStr(AColor: TColor): string;
var
  R, G, B: Byte;
  ColorValue: LongWord;
begin
  ColorValue := LongWord(AColor);
{$IFDEF FMX}
  R := (ColorValue and $00FF0000) shr 16;
  B := ColorValue and $000000FF;
{$ELSE}
  B := (ColorValue and $00FF0000) shr 16;
  R := ColorValue and $000000FF;
{$ENDIF}
  G := (ColorValue and $0000FF00) shr 8;
  Result := IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
end;

// 功能： 将 TColor 类型的值转换为 AARRGGBB 格式的十六进制字符串（包含透明度）。
// 参数:
//  - AColor TColor 待转换的颜色值，可能包含平台相关的R/B分量顺序。
// 返回值： string 格式为 AARRGGBB 的十六进制颜色字符串，例如 'FFFF0000' 代表不透明的红色。
function ColorToAARRGGBBStr(AColor: TColor): string;
var
  A, R, G, B: Byte;
  ColorValue: LongWord;
begin
  ColorValue := LongWord(AColor);
  // 注意：在 VCL (没有定义 FMX) 中，TColor 的低字节是 R，高字节是 B。
  // 在 FMX (定义了 FMX) 中，TColor 的低字节是 B，高字节是 R。
{$IFDEF FMX}
  R := (ColorValue and $00FF0000) shr 16;
  B := ColorValue and $000000FF;
{$ELSE}
  B := (ColorValue and $00FF0000) shr 16;
  R := ColorValue and $000000FF;
{$ENDIF}
  A := (ColorValue and $FF000000) shr 24; // 透明度总是最高字节
  G := (ColorValue and $0000FF00) shr 8; // 绿色分量总是次高字节

  Result := IntToHex(A, 2) + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
end;

// 功能： 将 AARRGGBB 格式的十六进制字符串转换为 TColor 类型的值。
// 参数:
//  - AStr string 待转换的 AARRGGBB 格式十六进制字符串。
//  - ADefaultColor LongWord $FFFFFFFF（默认值） 如果输入字符串无效（格式或长度不匹配），则返回此默认颜色值。
// 返回值： TColor 转换后的颜色值。如果转换失败，则返回 ADefaultColor。
function AARRGGBBStrToColor(AStr: string; ADefaultColor: LongWord = $FFFFFFFF): TColor;
var
  ColorString: string;
  A, R, G, B: Byte;
begin
  Result := ADefaultColor;
  ColorString := UpperCase(Trim(AStr));

  if Length(ColorString) = 8 then
  begin
    if IsAllCharFitHex(ColorString) then
    begin
      // 解析 AARRGGBB 字符串，每两个字符对应一个字节
      A := StrToIntDef('$' + Copy(ColorString, 1, 2), 0); // 透明度 A
      R := StrToIntDef('$' + Copy(ColorString, 3, 2), 0); // 红色 R
      G := StrToIntDef('$' + Copy(ColorString, 5, 2), 0); // 绿色 G
      B := StrToIntDef('$' + Copy(ColorString, 7, 2), 0); // 蓝色 B
      Result := ARGB(A, R, G, B);
    end;
  end;
end;

// 功能：将 RRGGBB（红红绿绿蓝蓝）格式的十六进制字符串转换为 TColor 类型的颜色值。
// 参数：
//   - AStr: string               输入的 RRGGBB 格式的十六进制字符串。
//   - ADefaultColor: LongWord = $FFFFFFFF  如果转换失败使用的默认值
// 返回值：
//   - TColor                     转换后的颜色值。如果输入无效（如非空白字符长度不为6，有非16进制字符等），则返回一个默认值ADefaultColor。
function RRGGBBStrToColor(AStr: string; ADefaultColor: LongWord = $FFFFFFFF): TColor;
var
  ColorString: string;
  R, G, B: Byte;
begin
  Result := ADefaultColor;
  ColorString := UpperCase(Trim(AStr));

  if Length(ColorString) = 6 then
  begin
    if IsAllCharFitHex(ColorString) then
    begin
      R := StrToIntDef('$' + Copy(ColorString, 1, 2), 0);
      G := StrToIntDef('$' + Copy(ColorString, 3, 2), 0);
      B := StrToIntDef('$' + Copy(ColorString, 5, 2), 0);
      Result := RGB(R, G, B);
    end;
  end;
end;

// 功能：比较输入的整数AInput是否在指定的范围[AMin, AMax]内，如果是就返回AInput，否则返回ADefaultValue
// 参数：
//   - AInput: Integer              输入的整数
//   - AMin: Integer                范围的左端点
//   - AMax: Integer                范围的右端
//   - ADefaultValue: Integer = -1  如果不在范围内返回的默认值
function CheckInRange(AInput, AMin, AMax: Integer; ADefaultValue: Integer = -1):
  Integer;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

// 其他类型的重载，内容与 Integer 版本相同，只是类型不同
function CheckInRange(AInput, AMin, AMax: Int64; ADefaultValue: Int64 = -1): Int64;
  overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Single; ADefaultValue: Single = -1): Single;
  overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Double; ADefaultValue: Double = -1): Double;
  overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Extended; ADefaultValue: Extended = -1):
  Extended; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: NativeInt; ADefaultValue: NativeInt = 0):
  NativeInt; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: NativeUInt; ADefaultValue: NativeUInt = 0):
  NativeUInt; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: UInt64; ADefaultValue: UInt64 = 0): UInt64;
  overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Char; ADefaultValue: Char = #0): Char;
  overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Cardinal; ADefaultValue: Cardinal = 0):
  Cardinal; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Byte; ADefaultValue: Byte = 0): Byte;
  overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Word; ADefaultValue: Word = 0): Word;
  overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

end.

