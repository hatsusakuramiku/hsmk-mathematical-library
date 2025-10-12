unit FunctionToolUnit;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Forms, GeneralTypeUnit, System.UITypes, System.Generics.Collections;

{Message}
function MessBox(AMsg: string; ACaption: string = '提示'; AFlags: LongInt = mb_OK or mb_IconHand): Integer;

{Math}
function MyAvg(const AExtendedArr: array of Extended): Extended;
function MySum(const AExtendedArr: array of Extended): Extended;
// Max 函数 - 按类型大小从小到大排序
function Max(const AInt1, AInt2: Integer): Integer; overload;
function Max(const AInt1, AInt2: UInt32): UInt32; overload;
function Max(const AInt1, AInt2: NativeInt): NativeInt; overload;
function Max(const AInt1, AInt2: Int64): Int64; overload;
function Max(const AInt1, AInt2: UInt64): UInt64; overload;
function Max(const AInt1, AInt2: NativeUInt): NativeUInt; overload;

// Min 函数 - 按类型大小从小到大排序
function Min(const AInt1, AInt2: Integer): Integer; overload;
function Min(const AInt1, AInt2: UInt32): UInt32; overload;
function Min(const AInt1, AInt2: NativeInt): NativeInt; overload;
function Min(const AInt1, AInt2: Int64): Int64; overload;
function Min(const AInt1, AInt2: UInt64): UInt64; overload;
function Min(const AInt1, AInt2: NativeUInt): NativeUInt; overload;

{Memory Function}
function MemCompare(const APData1, APData2: Pointer; const ASize: TSize_T): Boolean;
procedure MemSwap(const APData1, APData2: Pointer; const ASize: TSize_T); overload;
procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: TSize_T); overload;

{String}
// 非指针实现
function ReverseString(const ABaseStr: string): string;
function MyStringReplace(const ABaseStr, AOldPattern, ANewPattern: string; AFlags: TReplaceFlags): string;
function MyStringSplit(const ABaseStr, ASplitter: string; AIsIgnoreCase: Boolean = False):TStringArray;
function GetFirstItem(var ABaseStr: string; const ASplitter: string; AIsIgnoreCase: Boolean = False): string;
function GetLastItem(const ABaseStr: string; const ASplitter: string; AIsIgnoreCase: Boolean = False): string;

// 指针实现，注意，使用下面的函数时需要确保输入的所有string类型的参数都不能含有#0，否则可能出现非预期结果或未知异常
function ReverseStringP(const ABaseStr: string): string;
function MemcmpStrChars(const APStr1, APStr2: Pointer; const ACharCount: TSize_T): Boolean;
function MemcmpTextChars(const APStr1, APStr2: Pointer; const ACharCount: TSize_T): Boolean;
function MySameStr(const APStr1, APStr2: Pointer; const ASize: TSize_T): Boolean;
function MySameText(const APStr1, APStr2: Pointer; const ASize: TSize_T): Boolean;
function GetStrFirstItem(var ABaseStr: string; ASplitter: string): string;
function GetTextFirstItem(var ABaseStr: string; ASplitter: string): string;
function GetFirstItemP(var ABaseStr: string; ASplitter: string; AIsIgnoreCase: Boolean = False): string;
function MyStrSplit(const ABaseStr, ASplitter: string): TStringArray;
function MyTextSplit(const ABaseStr, ASplitter: string): TStringArray;
function MyStringSplitP(const ABaseStr, ASplitter: string; AIsIgnoreCase: Boolean = False):TStringArray;
function MyStringReplaceP_Faster(const ABaseStr, AOldPattern, ANewPattern: string; AFlags: TReplaceFlags = []): string;
function MyStringReplaceP(const ABaseStr, AOldPattern, ANewPattern: string; AFlags: TReplaceFlags = []): string;

{Array Function}
function GenerateRandomIntegerArray(const ANum: Integer; const AMin: Integer = 0; const AMax: Integer = 100): TIntegerArray;
function GenerateRandomExtendedArray(const ANum: Integer; const AMin: Extended = 0.0; const AMax: Extended = 100.0): TExtendedArray;

type
  TGetterFunc<T> = reference to function(Index: Integer; AArray: array of T): string;

type
  TArrayUtils = class
  private
    class function BuildString<T>(AGetter: TGetterFunc<T>; AArray: array of T; const ASplitter: string; const APrefix: string; const ASuffix: string): string; static;
    class procedure CopyAndMove(var Result: string; var iResultLen, iCurrentPos: Integer; var pStr: PChar; const ASourceStr: string); static;
    class procedure EnsureCapacity(var Result: string; var iResultLen, iCurrentPos: Integer; ANeededLen: Integer; var pStr: PChar); static;
  public
    class function IntArrayToString(AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function IntArrayToStringF(const AFormat: string; AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function FloatArrayToString(AFloatArr: array of Extended; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function FloatArrayToStringF(const AFormat: string; AFloatArr: array of Extended; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function StringListToString(AStrList: array of string; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function ObjectListToString(AObjList: array of TObject; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
  end;


function LeftCut(const ASourceStr: string; const ALen: Integer): string;
function RightCut(const ASourceStr: string; const ALen: Integer): string;

type
  TCheckFunction = reference to function(const APCheckedData, AContext: Pointer): Boolean;

 function CheckArrayAllElemAreVaild(const APBase, AContext: Pointer; const AElemNum, AElemSize: TSize_T; const ACheckFunc: TCheckFunction): Boolean; overload;
 function CheckArrayAllElemAreVaild(const AArray: array of Integer; const AContext: Pointer; ACheckFunc: TCheckFunction): Boolean; overload;

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
TCompareFunction = reference to function(APData1, APData2, APContext: Pointer): Integer;
TSortFunction = procedure(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

const MINSUBARRLEN: TSize_T = 8; //最小子数组长度，在下面较复杂的排序中，若待排
                                 //序长度小于这个数将使用简单排序（如插入排序等）

// 辅助函数，在此处列出可供外部调用的辅助函数
// 为性能与效率考虑，多个函数或过程中都频繁使用的辅助函数不会对输入参数进行校验
// 无参数校验
function GetPtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;
function LeftMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;
function RightMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;

type
  TRealType = (rtInt, rtInt64, rtUInt64, rtSingle, rtDouble, rtExtedent);
// 整型
function IntegerCompareAsc(APData1, APData2, APContext: Pointer): Integer;
function IntegerCompareDesc(APData1, APData2, APContext: Pointer): Integer;
function Int64CompareAsc(APData1, APData2, APContext: Pointer): Integer;
function Int64CompareDesc(APData1, APData2, APContext: Pointer): Integer;
function UInt64CompareAsc(APData1, APData2, APContext: Pointer): Integer;
function UInt64CompareDesc(APData1, APData2, APContext: Pointer): Integer;

// 浮点型
function ExtendedCompareAsc(APData1, APData2, APContext: Pointer): Integer;
function ExtendedCompareDesc(APData1, APData2, APContext: Pointer): Integer;
function SingleCompareAsc(APData1, APData2, APContext: Pointer): Integer;
function SingleCompareDesc(APData1, APData2, APContext: Pointer): Integer;
function DoubleCompareAsc(APData1, APData2, APContext: Pointer): Integer;
function DoubleCompareDesc(APData1, APData2, APContext: Pointer): Integer;

// 有参数校验
function IsSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;
procedure ReverseArray(const APBase: Pointer; AElemNum, AElemSize: TSize_T);
function IsReverseSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;
procedure OptimizedSort(ASortFunc: TSortFunction; const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

// 排序函数
procedure BubbleSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure InsertionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure SelectionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure ShellSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure MergeSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure HeapSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure HybridSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure QuickSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
procedure IntroSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

{类三元运算}
// 实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Integer): Integer; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: string): string; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Extended): Extended; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Pointer): Pointer; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TObject): TObject; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Boolean): Boolean; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Char): Char; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Int64): Int64; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Double): Double; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: AnsiString): AnsiString; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TDateTime): TDateTime; overload;

// 实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
procedure IfThen(var AResult: Integer; ACondition: Boolean; ATrueValue, AFalseValue: Integer); overload;
procedure IfThen(var AResult: string; ACondition: Boolean; ATrueValue, AFalseValue: string); overload;
procedure IfThen(var AResult: Extended; ACondition: Boolean; ATrueValue, AFalseValue: Extended); overload;
procedure IfThen(var AResult: Pointer; ACondition: Boolean; ATrueValue, AFalseValue: Pointer); overload;
procedure IfThen(var AResult: TObject; ACondition: Boolean; ATrueValue, AFalseValue: TObject); overload;
procedure IfThen(var AResult: Boolean; ACondition: Boolean; ATrueValue, AFalseValue: Boolean); overload;
procedure IfThen(var AResult: Char; ACondition: Boolean; ATrueValue, AFalseValue: Char); overload;
procedure IfThen(var AResult: Int64; ACondition: Boolean; ATrueValue, AFalseValue: Int64); overload;
procedure IfThen(var AResult: Double; ACondition: Boolean; ATrueValue, AFalseValue: Double); overload;
procedure IfThen(var AResult: AnsiString; ACondition: Boolean; ATrueValue, AFalseValue: AnsiString); overload;
procedure IfThen(var AResult: TDateTime; ACondition: Boolean; ATrueValue, AFalseValue: TDateTime); overload;

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
  TSearchFunction = function(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;

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
  // 返回值: TIntegerArray 为空：没有找到符合条件的元素，不为空：找到的所有符合条件的元素的索引（从0开始）数组
  TSearchsFunction = function(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TIntegerArray;

//对完全有序数组查找，此处函数只能用于完全有序的数组
function BinarySearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;
function BinarySearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TIntegerArray;

//通用查找
function SequentialSearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;
function SequentialSearchEx(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction; AOffset: Cardinal = 0): Integer;
function SequentialSearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TIntegerArray;

{Other Function}
procedure CompareAndSwap(const APSmallerData, APBiggerData, APContext: Pointer; const ACompareFunc: TCompareFunction; const ASize: TSize_T);
function ColorToRRGGBBStr(AColor: TColor): string;
function RRGGBBStrToColor(AStr: string): TColor;
implementation

uses
  System.Math;

{Message}
// 功能：显示消息对话框，提供统一的消息提示接口
// 参数：
//   - AMsg: string      要显示的消息内容
//   - ACaption: string  对话框标题（默认为"提示"）
//   - AFlags: LongInt   对话框样式标志（默认为确定按钮+错误图标）
// 返回值：无
function MessBox(AMsg: string; ACaption: string = '提示'; AFlags: LongInt = mb_OK or mb_IconHand): Integer;
begin
  Result := Application.MessageBox(PChar(AMsg), PChar(ACaption), AFlags);
end;


{Math}
// 功能：计算浮点数数组的平均值
// 参数：
//   - const AExtendedArr: array of Extended  待计算的浮点数数组
// 返回值：Extended  数组的平均值，空数组返回0.0
function MyAvg(const AExtendedArr: array of Extended): Extended;
begin
  Result := 0.0;
  if Length(AExtendedArr) <> 0 then
  begin
    Result := MySum(AExtendedArr) / Length(AExtendedArr);
  end;
end;

// 功能：计算浮点数数组的总和
// 参数：
//   - const AExtendedArr: array of Extended  待求和的浮点数数组
// 返回值：Extended  数组元素的总和，空数组返回0.0
function MySum(const AExtendedArr: array of Extended): Extended;
var
  i: Integer;
begin
  Result := 0.0;
  if Length(AExtendedArr) <> 0 then
  begin
    for i := Low(AExtendedArr) to High(AExtendedArr) do
      Result := Result + AExtendedArr[i];
  end;
end;

// ==================== Max/Min 函数实现 - 按类型大小从小到大排序 ====================
// 这些函数实现了高效的Max和Min操作，使用位运算避免条件分支，提高性能
// 特点：
// 1. 无分支实现：使用位运算替代if-else判断，避免分支预测失误
// 2. 类型安全：为不同整数类型提供重载版本
// 3. 跨平台：NativeInt/NativeUInt根据CPU架构自动选择32位或64位实现
// 4. 高性能：位运算比条件判断更快，特别是在现代CPU上

// 获取两个Integer类型数值中的最大值（无分支实现）
// 参数：
//   AInt1 - 第一个整数
//   AInt2 - 第二个整数
// 返回值：两个整数中的较大值
// 实现原理：使用位运算避免条件分支，提高性能
function Max(const AInt1, AInt2: Integer): Integer; overload;
begin
  Result := (AInt1 and (not ((AInt1 - AInt2) shr 31))) or (AInt2 and (((AInt1 - AInt2) shr 31)));
end;

// 获取两个UInt32类型数值中的最大值（无分支实现）
// 参数：
//   AInt1 - 第一个无符号32位整数
//   AInt2 - 第二个无符号32位整数
// 返回值：两个无符号整数中的较大值
// 实现原理：使用位运算避免条件分支，提高性能
function Max(const AInt1, AInt2: UInt32): UInt32; overload;
begin
  Result := AInt1 - ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 31));
end;

// 获取两个NativeInt类型数值中的最大值（无分支实现）
// 参数：
//   AInt1 - 第一个原生整数（32位或64位）
//   AInt2 - 第二个原生整数（32位或64位）
// 返回值：两个原生整数中的较大值
// 实现原理：根据CPU架构自动选择32位或64位位运算，避免条件分支
function Max(const AInt1, AInt2: NativeInt): NativeInt; overload;
begin
{$IFDEF CPUX64}
  Result := (AInt1 and (not ((AInt1 - AInt2) shr 63))) or (AInt2 and (((AInt1 - AInt2) shr 63)));
{$ELSE}
  Result := (AInt1 and (not ((AInt1 - AInt2) shr 31))) or (AInt2 and (((AInt1 - AInt2) shr 31)));
{$ENDIF}
end;

// 获取两个Int64类型数值中的最大值（无分支实现）
// 参数：
//   AInt1 - 第一个64位有符号整数
//   AInt2 - 第二个64位有符号整数
// 返回值：两个64位整数中的较大值
// 实现原理：使用64位位运算避免条件分支，提高性能
function Max(const AInt1, AInt2: Int64): Int64; overload;
begin
  Result := (AInt1 and (not ((AInt1 - AInt2) shr 63))) or (AInt2 and (((AInt1 - AInt2) shr 63)));
end;

// 获取两个UInt64类型数值中的最大值（无分支实现）
// 参数：
//   AInt1 - 第一个64位无符号整数
//   AInt2 - 第二个64位无符号整数
// 返回值：两个64位无符号整数中的较大值
// 实现原理：使用64位位运算避免条件分支，提高性能
function Max(const AInt1, AInt2: UInt64): UInt64; overload;
begin
  Result := AInt1 - ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 63));
end;

// 获取两个NativeUInt类型数值中的最大值（无分支实现）
// 参数：
//   AInt1 - 第一个原生无符号整数（32位或64位）
//   AInt2 - 第二个原生无符号整数（32位或64位）
// 返回值：两个原生无符号整数中的较大值
// 实现原理：根据CPU架构自动选择32位或64位位运算，避免条件分支
function Max(const AInt1, AInt2: NativeUInt): NativeUInt; overload;
begin
{$IFDEF CPUX64}
  Result := AInt1 - ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 63));
{$ELSE}
  Result := AInt1 - ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 31));
{$ENDIF}
end;


// 获取两个Integer类型数值中的最小值（无分支实现）
// 参数：
//   AInt1 - 第一个整数
//   AInt2 - 第二个整数
// 返回值：两个整数中的较小值
// 实现原理：使用位运算避免条件分支，提高性能
function Min(const AInt1, AInt2: Integer): Integer; overload;
begin
  Result := (AInt2 and (((AInt1 - AInt2) shr 31))) or (AInt1 and (not ((AInt1 - AInt2) shr 31)));
end;

// 获取两个UInt32类型数值中的最小值（无分支实现）
// 参数：
//   AInt1 - 第一个无符号32位整数
//   AInt2 - 第二个无符号32位整数
// 返回值：两个无符号整数中的较小值
// 实现原理：使用位运算避免条件分支，提高性能
function Min(const AInt1, AInt2: UInt32): UInt32; overload;
begin
  Result := AInt2 + ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 31));
end;

// 获取两个NativeInt类型数值中的最小值（无分支实现）
// 参数：
//   AInt1 - 第一个原生整数（32位或64位）
//   AInt2 - 第二个原生整数（32位或64位）
// 返回值：两个原生整数中的较小值
// 实现原理：根据CPU架构自动选择32位或64位位运算，避免条件分支
function Min(const AInt1, AInt2: NativeInt): NativeInt; overload;
begin
{$IFDEF CPUX64}
  Result := (AInt2 and (((AInt1 - AInt2) shr 63))) or (AInt1 and (not ((AInt1 - AInt2) shr 63)));
{$ELSE}
  Result := (AInt2 and (((AInt1 - AInt2) shr 31))) or (AInt1 and (not ((AInt1 - AInt2) shr 31)));
{$ENDIF}
end;

// 获取两个Int64类型数值中的最小值（无分支实现）
// 参数：
//   AInt1 - 第一个64位有符号整数
//   AInt2 - 第二个64位有符号整数
// 返回值：两个64位整数中的较小值
// 实现原理：使用64位位运算避免条件分支，提高性能
function Min(const AInt1, AInt2: Int64): Int64; overload;
begin
  Result := (AInt2 and (((AInt1 - AInt2) shr 63))) or (AInt1 and (not ((AInt1 - AInt2) shr 63)));
end;

// 获取两个UInt64类型数值中的最小值（无分支实现）
// 参数：
//   AInt1 - 第一个64位无符号整数
//   AInt2 - 第二个64位无符号整数
// 返回值：两个64位无符号整数中的较小值
// 实现原理：使用64位位运算避免条件分支，提高性能
function Min(const AInt1, AInt2: UInt64): UInt64; overload;
begin
  Result := AInt2 + ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 63));
end;

// 获取两个NativeUInt类型数值中的最小值（无分支实现）
// 参数：
//   AInt1 - 第一个原生无符号整数（32位或64位）
//   AInt2 - 第二个原生无符号整数（32位或64位）
// 返回值：两个原生无符号整数中的较小值
// 实现原理：根据CPU架构自动选择32位或64位位运算，避免条件分支
function Min(const AInt1, AInt2: NativeUInt): NativeUInt; overload;
begin
{$IFDEF CPUX64}
  Result := AInt2 + ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 63));
{$ELSE}
  Result := AInt2 + ((AInt1 - AInt2) and ((AInt1 - AInt2) shr 31));
{$ENDIF}
end;


{Memory Function}
// 功能：内存比较函数，逐字节比较两块内存区域是否相同
// 参数：
//   - const APStr1: Pointer  指向第一块内存区域的指针
//   - const APStr2: Pointer  指向第二块内存区域的指针
//   - const ASize: TSize_T    要比较的字节数
// 返回值：Boolean  True表示两块内存完全相同，False表示存在差异
function MemCompare(const APData1, APData2: Pointer; const ASize: TSize_T): Boolean;
{$IF defined(POSIX)}
begin
  Result := memcmp(APData1, APData2, ASize) = 0;
end;
{$ELSE}
var
  iCurrentOffSet, NativeUIntSize: TSize_T;
  Source1Ptr, Source2Ptr: PByte;
begin
  if (APData1 = nil) or (APData2 = nil)then
  begin
    raise Exception.Create('APStr1 与 APStr2不能为nil');
  end;

  if (APData1 = APData2) or (ASize = 0) then
  begin
    Result := True;
    Exit;
  end;

  NativeUIntSize := SizeOf(TSize_T);
{$POINTERMATH ON}
  Source1Ptr := PByte(APData1);
  Source2Ptr := PByte(APData2);
  if ASize <= NativeUIntSize then
  begin
    case ASize of
      1: Result := PByte(Source1Ptr)[0] = PByte(Source2Ptr)[0];
      2: Result := PWord(Source1Ptr)[0] = PWord(Source2Ptr)[0];
      3: Result := (PWord(Source1Ptr)[0] = PWord(Source2Ptr)[0])
        and (PByte(Source1Ptr)[2] = PByte(Source2Ptr)[2]);
      4: Result := (PInteger(Source1Ptr)[0] = PInteger(Source2Ptr)[0]);
      5: Result := (PInteger(Source1Ptr)[0] = PInteger(Source2Ptr)[0])
        and (PByte(Source1Ptr)[4] = PByte(Source2Ptr)[4]);
      6: Result := (PInteger(Source1Ptr)[0] = PInteger(Source2Ptr)[0])
        and (PWord(Source1Ptr)[2] = PWord(Source2Ptr)[2]);
      7: Result := (PInteger(Source1Ptr)[0] = PInteger(Source2Ptr)[0])
        and (PWord(Source1Ptr)[2] = PWord(Source2Ptr)[2])
        and (PByte(Source1Ptr)[6] = PByte(Source2Ptr)[6]);
      8: Result := PNativeUInt(Source1Ptr)[0] = PNativeUInt(Source2Ptr)[0];
    end;
  end
  else
  begin
    iCurrentOffSet := 0;
    Result := True;
    while iCurrentOffSet + NativeUIntSize <= ASize do
    begin
      if PNativeUInt(Source1Ptr + iCurrentOffSet)^ <> PNativeUInt(Source2Ptr + iCurrentOffSet)^ then
      begin
        Result := False;
        Exit;
      end;
      Inc(iCurrentOffSet, NativeUIntSize);
    end;

    if iCurrentOffSet < ASize then
      Result := MemCompare(Source1Ptr + iCurrentOffSet, Source2Ptr + iCurrentOffSet, ASize - iCurrentOffSet);
  end;
{$POINTERMATH OFF}
end;
{$ENDIF}

// 功能：交换两个指针指向的内存区域的内容，以字节为单位b进行交换
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
//    Move
  end;
end;

// 功能：交换两个指针指向的内存区域的内容，以字节为单位进行交换
// 参数：
//   - const APStr1: Pointer  指向第一块内存区域的指针
//   - const APStr2: Pointer  指向第二块内存区域的指针
//   - const ASwapBuffer: Pointer  指向临时内存的指针
//   - const ASize: TSize_T    要交换的字节数
procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: TSize_T); overload;
{$IF defined(POSIX)}
begin
  if ASize > 0 then
  begin
    memmove(ASwapBuffer, AData1, ASize);
    memmove(AData1, AData2, ASize);
    memmove(AData2, ASwapBuffer, ASize);
  end;
end;
{$ELSEIF defined(PUREPASCAL)}
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
      1: begin
           SwapBufferPtr[0] := Source1Ptr[0];
           Source1Ptr[0] := Source2Ptr[0];
           Source2Ptr[0] := SwapBufferPtr[0];
         end;
      2: begin
           PWord(SwapBufferPtr)[0] := PWord(Source1Ptr)[0];
           PWord(Source1Ptr)[0] := PWord(Source2Ptr)[0];
           PWord(Source2Ptr)[0] := PWord(SwapBufferPtr)[0];
         end;
      3: begin
           PWord(SwapBufferPtr)[0] := PWord(Source1Ptr)[0];
           PWord(Source1Ptr)[0] := PWord(Source2Ptr)[0];
           PWord(Source2Ptr)[0] := PWord(SwapBufferPtr)[0];
           
           SwapBufferPtr[0] := Source1Ptr[2];
           Source1Ptr[2] := Source2Ptr[2];
           Source2Ptr[2] := SwapBufferPtr[0];           
         end; 
      4: begin
           PInteger(SwapBufferPtr)[0] := PInteger(Source1Ptr)[0];
           PInteger(Source1Ptr)[0] := PInteger(Source2Ptr)[0];
           PInteger(Source2Ptr)[0] := PInteger(SwapBufferPtr)[0];
         end;
      5: begin
           PInteger(SwapBufferPtr)[0] := PInteger(Source1Ptr)[0];
           PInteger(Source1Ptr)[0] := PInteger(Source2Ptr)[0];
           PInteger(Source2Ptr)[0] := PInteger(SwapBufferPtr)[0];
           
           SwapBufferPtr[0] := Source1Ptr[4];
           Source1Ptr[4] := Source2Ptr[4];
           Source2Ptr[4] := SwapBufferPtr[0];           
         end; 
      6: begin
           PInteger(SwapBufferPtr)[0] := PInteger(Source1Ptr)[0];
           PInteger(Source1Ptr)[0] := PInteger(Source2Ptr)[0];
           PInteger(Source2Ptr)[0] := PInteger(SwapBufferPtr)[0];
           
           PWord(SwapBufferPtr)[0] := PWord(Source1Ptr)[2];
           PWord(Source1Ptr)[2] := PWord(Source2Ptr)[2];
           PWord(Source2Ptr)[2] := PWord(SwapBufferPtr)[0];          
         end; 
      7: begin
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
      8: begin
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
{$ELSE !PUREPASCAL}
{$IFDEF CPUX86}
begin
  Move(AData1^, ASwapBuffer^, ASize);
  Move(AData2^, AData1^, ASize);
  Move(ASwapBuffer^, AData2^, ASize);
end;
{$ENDIF CPUX86}
{$ENDIF !PUREPASCAL}


{String}

// 功能：翻转输入的字符串，如abc->cba
// 参数：const ABaseStr: string 需要被翻转的字符串
// 返回值类型：string 翻转后的字符串
function ReverseString(const ABaseStr: string): string;
var
  i, j: Integer;
  Temp: Char;
  ResultStr: string;
begin
  ResultStr := ABaseStr; // 复制输入字符串
  i := Low(ResultStr);
  j := High(ResultStr);

  while i < j do
  begin
    Temp := ResultStr[i];
    ResultStr[i] := ResultStr[j];
    ResultStr[j] := Temp;
    Inc(i);
    Dec(j);
  end;

  Result := ResultStr;
end;

// 功能：字符串替换，兼容StringReplace
// 参数：
//  - const ABaseStr: string    源字符串
//  - const AOldPattern: string 旧子串
//  - const ANewPattern: string 新子串
//  - AFlags: TReplaceFlags = [] 与StringReplace兼容的参数，rfReplaceAll：全部替换,
//                               rfIgnoreCase：忽略大小写
// 返回值类型：string：替换后的字符串
function MyStringReplace(const ABaseStr, AOldPattern, ANewPattern: string; AFlags: TReplaceFlags): string;
var
  sTempStr: string;
  iPosSplitter: Integer;
  bIsIgnoreCase, bIsReplaceall: Boolean;
begin
  if (Length(ABaseStr) < 1) or (Length(AOldPattern) < 1)then
    Exit('');

  Result := '';
  sTempStr := ABaseStr;
  bIsIgnoreCase := rfIgnoreCase in AFlags;
  bIsReplaceAll := rfReplaceAll in AFlags;

  if bIsIgnoreCase and SameText(AOldPattern, ANewPattern) then
    Exit(ABaseStr)
  else
  if SameStr(AOldPattern, ANewPattern) then
    Exit(ABaseStr);

  while sTempStr <> '' do
  begin
    if bIsIgnoreCase then
      iPosSplitter := Pos(LowerCase(AOldPattern), LowerCase(sTempStr))
    else
      iPosSplitter := Pos(AOldPattern, sTempStr);

    if iPosSplitter > 0 then
    begin
      // 如果找到了分隔符：
      // 1. 将分隔符之前的部分作为和ANewPattern添加到结果
      Result := Result + Copy(sTempStr, 1, iPosSplitter - 1) + ANewPattern;

      // 2. 修改 ABaseStr，移除已提取的部分（包括分隔符本身）
      sTempStr := Copy(sTempStr, iPosSplitter + Length(AOldPattern), Length(sTempStr) - iPosSplitter - Length(AOldPattern) + 1);
    end
    else
    begin
      // 如果没有找到分隔符：则将剩余的sTempStr加到结果上
      Result := Result + sTempStr;
      sTempStr := '';
    end;

    if not bIsReplaceAll then
    begin
      Result := Result + sTempStr;
      Break;
    end;
  end;

end;


// 功能：将字符串通过分隔符进行分割
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
//  - AIsIgnoreCase: Boolean = False 是否区分分隔符大小写，True：不区分，False：区分
// 返回值类型：TStringArray 依次序分割出的项目的数组
function MyStringSplit(const ABaseStr, ASplitter: string; AIsIgnoreCase: Boolean = False): TStringArray;
var
  sTempStr: string; // 用于复制ABaseStr
  sTemp: string; // 用于存储从 ABaseStr 中提取出的第一个项目
begin
  SetLength(Result, 0);

  // 如果源字符串为空，直接返回空数组
  if Length(ABaseStr) < 1 then
    Exit;

  // 如果分隔符为空，则整个源字符串被视为一个单独的项
  if Length(ASplitter) < 1 then
  begin
    SetLength(Result, 1);
    Result[0] := ABaseStr; // 将源字符串添加到结果数组
    Exit;
  end;

  sTempStr := ABaseStr; // 复制一份源字符串，因为 GetFirstItem 会修改它

  // 循环查找并提取分隔符前的部分
  while sTempStr <> '' do
  begin
    sTemp := GetFirstItem(sTempStr, ASplitter, AIsIgnoreCase); // 提取第一个项目
    if sTemp <> '' then
    begin
      SetLength(Result, Length(result) + 1);
      Result[High(Result) + 1] :=  sTemp;
    end;
  end;
end;

// 功能：从一个字符串中提取第一个由指定分隔符分隔出的项目。
//       同时，它会修改传入的 ABaseStr，移除已提取的部分。
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
//  - AIsIgnoreCase: Boolean = False  是否区分大小写，True：不区分，False：区分
// 返回值类型：string 第一个由指定分隔符分隔出的项目
function GetFirstItem(var ABaseStr: string; const ASplitter: string; AIsIgnoreCase: Boolean = False): string;
var
  iPosSplitter: Integer; // 记录分隔符在 ABaseStr 中的位置
begin
  Result := ''; // 初始化结果为空

  // 如果源字符串或分隔符为空，则无法进行有效分割，直接返回
  if Length(ABaseStr) < 1 then
    Exit;

  // 查找 ASplitter 在 ABaseStr 中第一次出现的位置
  if AIsIgnoreCase then
    iPosSplitter := Pos(LowerCase(ASplitter), LowerCase(ABaseStr))
  else
    iPosSplitter := Pos(ASplitter, ABaseStr);

  if iPosSplitter > 0 then
  begin
    // 如果找到了分隔符：
    // 1. 提取分隔符之前的部分作为结果
    Result := Copy(ABaseStr, 1, iPosSplitter - 1);

    // 2. 修改 ABaseStr，移除已提取的部分（包括分隔符本身）
    ABaseStr := Copy(ABaseStr, iPosSplitter + Length(ASplitter), Length(ABaseStr) - iPosSplitter - Length(ASplitter) + 1);
  end
  else
  begin
    // 如果没有找到分隔符：
    Result := ABaseStr;
    ABaseStr := '';
  end;
  end;

// 功能：从一个字符串中提取由最后一个指定分隔符分隔出的后面的项目。
//       同时，它会修改传入的 ABaseStr，移除已提取的部分。
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
//  - AIsIgnoreCase: Boolean = False  是否区分大小写，True：不区分，False：区分
// 返回值类型：string 第一个由指定分隔符分隔出的项目
function GetLastItem(const ABaseStr: string; const ASplitter: string; AIsIgnoreCase: Boolean = False): string;
var
  sTemp: string;
begin
  sTemp := ReverseString(ABaseStr);
  Result := ReverseString(GetFirstItem(sTemp, ReverseString(ASplitter), AIsIgnoreCase));
end;

// 功能：使用指针实现的翻转字符串
// 参数：const ABaseStr: string  待翻转的字符串
// 返回值类型：string 翻转后的字符串
function ReverseStringP(const ABaseStr: string): string;
//var
//  pLeftPtr, pRightPtr: PChar;
//  iLen: TSize_T;
//begin
//  iLen := Length(ABaseStr);
//  if iLen < 2 then
//    Exit(ABaseStr);
//
//  //防止控制台程序在某些情况出现修改Result时同步修改了ABaseStr
//  SetLength(Result, iLen);
//  Result := Copy(ABaseStr, 1, iLen);
//
//  pLeftPtr := PChar(Result);
//  pRightPtr := GetPtr(pLeftPtr, (iLen - 1) * SizeOf(Char));
//
//  while pLeftPtr < pRightPtr do
//  begin
//    MemSwap(pLeftPtr, pRightPtr, SizeOf(Char));
//    Inc(pLeftPtr);
//    Dec(pRightPtr);
//  end;
//end;
begin
  Result := ReverseArray(PChar(ABaseStr), Length(ABaseStr), SIZEOFCHAR);
end;

// 功能：逐字符比较两个字符串是否相等，区分大小写。
//       这个函数时作为辅助函数使用的，因此不会对输入的参数进行校验，要实现相同
//       的功能请使用MySameStr
// 参数：
//  - const APStr1: Pointer    指向第一个被比较的字符串的指针
//  - const APStr2: Pointer    指向第二个被比较的字符串的指针
//  - const CharCount: TSize_T 需要比较的字符的个数
// 返回值类型：Boolean True：两个字符相等，False：两个字符串不等
function MemcmpStrChars(const APStr1, APStr2: Pointer; const ACharCount: TSize_T): Boolean;
var
  i: TSize_T;
  p1, p2: PChar;
begin
  Result := True;
  p1 := PChar(APStr1);
  p2 := PChar(APStr2);

  for i := 0 to ACharCount - 1 do
  begin
    if p1[i] <> p2[i] then
    begin
      Result := False;
      Break;
    end;
  end;
end;

// 功能：逐字符比较两个字符串是否相等，不区分大小写
//       这个函数时作为辅助函数使用的，因此不会对输入的参数进行校验，要实现相同
//       的功能请使用MySameText
// 参数：
//  - const APStr1: Pointer    指向第一个被比较的字符串的指针
//  - const APStr2: Pointer    指向第二个被比较的字符串的指针
//  - const CharCount: TSize_T 需要比较的字符的个数
// 返回值类型：Boolean True：两个字符相等，False：两个字符串不等
function MemcmpTextChars(const APStr1, APStr2: Pointer; const ACharCount: TSize_T): Boolean;
var
  i: TSize_T;
  p1, p2: PChar;
begin
  Result := True;
  p1 := PChar(APStr1);
  p2 := PChar(APStr2);

  for i := 0 to ACharCount - 1 do
  begin
    if CompareText(p1[i], p2[i]) <> 0 then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

// 功能：判断两个 Pointer 指向的字符串（长度为 Size）是否完全相同（区分大小写）。
// 参数：
//  - const APStr1: Pointer    指向第一个被比较的字符串的指针
//  - const APStr2: Pointer    指向第二个被比较的字符串的指针
//  - const ASize: TSize_T 需要比较的字符的个数
// 返回值类型：Boolean True：两个字符相等，False：两个字符串不等
function MySameStr(const APStr1, APStr2: Pointer; const ASize: TSize_T): Boolean;
begin
  Result := True;
  if (APStr1 = APStr2) or (ASize = 0) then
    Exit;

  if (APStr1 = nil) or (APStr2 = nil) then
  begin
    Result := False;
    Exit;
  end;

  Result := MemcmpStrChars(APStr1, APStr2, ASize);
end;

// 功能：判断两个 Pointer 指向的字符串（长度为 Size）是否相同（不区分大小写）。
// 参数：
//  - const APStr1: Pointer    指向第一个被比较的字符串的指针
//  - const APStr2: Pointer    指向第二个被比较的字符串的指针
//  - const ACharCount: TSize_T 需要比较的字符的个数
// 返回值类型：Boolean True：两个字符相等，False：两个字符串不等
function MySameText(const APStr1, APStr2: Pointer; const ASize: TSize_T): Boolean;
begin
  Result := True;
  if (APStr1 = APStr2) or (ASize = 0) then
    Exit;

  if (APStr1 = nil) or (APStr2 = nil) then
  begin
    Result := False;
    Exit;
  end;

  Result := MemcmpTextChars(APStr1, APStr2, ASize);
end;


// 功能：从一个字符串中提取第一个由指定分隔符分隔出的项目。
//       同时，它会修改传入的 ABaseStr，移除已提取的部分。(区分分隔符大小写)
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
// 返回值类型：string 第一个由指定分隔符分隔出的项目
function GetStrFirstItem(var ABaseStr: string; ASplitter: string): string;
var
  pPtrBase, pPtrSplitter: PChar;
  i, iBaseStrLen, iSplitterLen: Integer;
begin
  Result := '';
  if Length(ABaseStr) = 0 then
    Exit
  else if Length(ASplitter) = 0 then
  begin
    Result := ABaseStr;
    Exit;
  end;

  pPtrBase := PChar(ABaseStr);
  pPtrSplitter := PChar(ASplitter);
  iBaseStrLen := Length(ABaseStr);
  iSplitterLen := Length(ASplitter);
  i := 0;
  while iSplitterLen + i <= iBaseStrLen do
  begin
    if MySameStr(pPtrBase, pPtrSplitter, iSplitterLen) then
    begin
      if i <> 0 then
      begin
        SetLength(Result, i);
        Move(ABaseStr[1], Result[1], i * SizeOf(Char));
        Inc(pPtrBase, iSplitterLen);
        ABaseStr := pPtrBase;
        Exit;
      end;

    end;
    Inc(pPtrBase);
    Inc(i);
  end;

  Result := ABaseStr;
  ABaseStr := '';
end;

// 功能：从一个字符串中提取第一个由指定分隔符分隔出的项目。
//       同时，它会修改传入的 ABaseStr，移除已提取的部分。(不区分分隔符大小写)
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
// 返回值类型：string 第一个由指定分隔符分隔出的项目
function GetTextFirstItem(var ABaseStr: string; ASplitter: string): string;
var
  pPtrBase, pPtrSplitter: PChar;
  i, iBaseStrLen, iSplitterLen: Integer;
begin
  Result := '';
  if Length(ABaseStr) = 0 then
    Exit
  else if Length(ASplitter) = 0 then
  begin
    Result := ABaseStr;
    Exit;
  end;

  pPtrBase := PChar(ABaseStr);
  pPtrSplitter := PChar(ASplitter);
  iBaseStrLen := Length(ABaseStr);
  iSplitterLen := Length(ASplitter);
  i := 0;
  while iSplitterLen + i <= iBaseStrLen do
  begin
    if MySameText(pPtrBase, pPtrSplitter, iSplitterLen) then
    begin
      if i <> 0 then
      begin
        SetLength(Result, i);
        Move(ABaseStr[1], Result[1], i * SizeOf(Char));
        Inc(pPtrBase, iSplitterLen);
        ABaseStr := pPtrBase;
        Exit;
      end;

    end;
    Inc(pPtrBase);
    Inc(i);
  end;

  Result := ABaseStr;
  ABaseStr := '';
end;

// 功能：从一个字符串中提取第一个由指定分隔符分隔出的项目。
//       同时，它会修改传入的 ABaseStr，移除已提取的部分。
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
//  - AIsIgnoreCase: Boolean = False  是否区分大小写，True：不区分，False：区分
// 返回值类型：string 第一个由指定分隔符分隔出的项目
function GetFirstItemP(var ABaseStr: string; ASplitter: string; AIsIgnoreCase: Boolean = False): string;
begin
  if AIsIgnoreCase then
    Result := GetTextFirstItem(ABaseStr, ASplitter)
  else
    Result := GetStrFirstItem(ABaseStr, ASplitter);
end;


// 将字符串通过分隔符进行分割，区分大小写
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
// 返回值类型：TStringArray 依次序分割出的项目的数组
function MyStrSplit(const ABaseStr, ASplitter: string): TStringArray;
var
  sTemp, sTempSplited: string;
  iTempLen: Integer;
begin
  iTempLen := Length(ABaseStr);
  if iTempLen = 0 then
  begin
    SetLength(Result, 0);
    Exit;
  end
  else if Length(ASplitter) = 0 then
  begin
    SetLength(Result, 1);
    Result[0] := ABaseStr;
    Exit;
  end;
  sTemp := ABaseStr;
  while sTemp <> '' do
  begin
    sTempSplited := GetStrFirstItem(sTemp, ASplitter);
    if sTempSplited <> '' then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := sTempSplited;
    end;
  end;

end;

// 功能：使用纯指针实现字符串替换，兼容StringReplace，不过会额外申请一部分BUffer，
//       建议在字符串长度不少于十万时使用
// 参数：
//  - const ABaseStr: string     原字符串
//  - const AOldPattern: string  旧的子串
//  - const ANewPattern: string  新的子串
//  - AFlags: TReplaceFlags = [] 与StringReplace兼容的参数，rfReplaceAll：全部替换,
//                               rfIgnoreCase：忽略大小写
// 返回值类型：string 替换后的字符串
function MyStringReplaceP_Faster(const ABaseStr, AOldPattern, ANewPattern: string; AFlags: TReplaceFlags = []): string;
var
  pBase, pOld: PChar;
  iBaseLen, iOldLen, iNewLen, iRemainLen, iResultLen, i: Integer;
  bIgnoreCase, bReplaceAll: Boolean;
begin
  iBaseLen := Length(ABaseStr);
  iOldLen := Length(AOldPattern);
  iNewLen := Length(ANewPattern);
  bIgnoreCase := rfIgnoreCase in AFlags;
  bReplaceAll := rfReplaceAll in AFlags;

  if bIgnoreCase and SameText(AOldPattern, ANewPattern) then
    Exit(ABaseStr)
  else
  if SameStr(AOldPattern, ANewPattern) then
    Exit(ABaseStr);

  if (iBaseLen = 0) or (iOldLen = 0) then
    Exit(ABaseStr);

  // 预估最大长度（最坏情况：每个字符都被替换）
  SetLength(Result, iBaseLen * (iNewLen div iOldLen + 1));
  pBase := PChar(ABaseStr);
  pOld := PChar(AOldPattern);
  i := 1;
  iResultLen := 0;

  while (pBase^ <> #0) do
  begin
    // 判断当前位置是否匹配
    if ((not bIgnoreCase and MySameStr(pBase, pOld, iOldLen)) or (bIgnoreCase and MySameText(pBase, pOld, iOldLen))) then
    begin
      // 写入新串
      Move(PChar(ANewPattern)^, Result[i], iNewLen * SizeOf(Char));
      Inc(i, iNewLen);
      Inc(iResultLen, iNewLen);
      Inc(pBase, iOldLen);

      if not bReplaceAll then
      begin
        // 只替换一次，剩下的直接拷贝
        iRemainLen := StrLen(pBase);
        if iRemainLen > 0 then
        begin
          Move(pBase^, Result[i], iRemainLen * SizeOf(Char));
        end;
        Break;
      end;
    end
    else
    begin
      Result[i] := pBase^;
      Inc(i);
      Inc(pBase);
      Inc(iResultLen);
    end;
  end;

  SetLength(Result, iResultLen);
end;

// 功能：字符串替换，兼容StringReplace，在字符串长度不少于十万时调用MyStringReplaceP_Faster
// 参数：
//  - const ABaseStr: string     原字符串
//  - const AOldPattern: string  旧的子串
//  - const ANewPattern: string  新的子串
//  - AFlags: TReplaceFlags = [] 与StringReplace兼容的参数，rfReplaceAll：全部替换,
//                               rfIgnoreCase：忽略大小写
// 返回值类型：string 替换后的字符串
function MyStringReplaceP(const ABaseStr, AOldPattern, ANewPattern: string; AFlags: TReplaceFlags = []): string;
var
  sTemp, sTemp2: string;
  bIsIgnoreCase, bIsReplaceAll: Boolean;
begin
  if (Length(ABaseStr) < 1) or (Length(AOldPattern) < 1) then
    Exit;
  if Length(ABaseStr) > 100000 then
    Exit(MyStringReplaceP_Faster(ABaseStr, AOldPattern, ANewPattern, AFlags));

  Result := '';
  sTemp := ABaseStr;
  bIsIgnoreCase := rfIgnoreCase in AFlags;
  bIsReplaceAll := rfReplaceAll in AFlags;

  if bIsIgnoreCase and SameText(AOldPattern, ANewPattern) then
    Exit(ABaseStr)
  else
  if SameStr(AOldPattern, ANewPattern) then
    Exit(ABaseStr);

  while sTemp <> '' do
  begin
    if bIsIgnoreCase then
      sTemp2 := GetTextFirstItem(sTemp, AOldPattern)
    else
      sTemp2 := GetStrFirstItem(sTemp, AOldPattern);

    if sTemp <> '' then
      Result := Result + sTemp2 + ANewPattern
    else
      Result := Result + sTemp2;

    if not bIsReplaceAll then
    begin
      Result := Result + sTemp;
      Break;
    end;

  end;

end;


// 功能：将字符串通过分隔符进行分割，不区分大小写
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
// 返回值类型：TStringArray 依次序分割出的项目的数组
function MyTextSplit(const ABaseStr, ASplitter: string): TStringArray;
var
  sTemp, sTempSplited: string;
  iTempLen: Integer;
begin
  iTempLen := Length(ABaseStr);
  if iTempLen = 0 then
  begin
    SetLength(Result, 0);
    Exit;
  end
  else if Length(ASplitter) = 0 then
  begin
    SetLength(Result, 1);
    Result[0] := ABaseStr;
    Exit;
  end;
  sTemp := ABaseStr;
  while sTemp <> '' do
  begin
    sTempSplited := GetTextFirstItem(sTemp, ASplitter);
    if sTempSplited <> '' then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := sTempSplited;
    end;
  end;

end;

// 功能：使用指针实现的字符串分解
// 参数：
//  - var ABaseStr: string    传入的源字符串
//  - ASplitter: string       分隔符
//  - AIsIgnoreCase: Boolean = False  是否区分大小写，True：不区分，False：区分
// 返回值类型：TStringArray 依次序分割出的项目的数组
function MyStringSplitP(const ABaseStr, ASplitter: string; AIsIgnoreCase: Boolean = False):TStringArray;
begin
  if AIsIgnoreCase then
    Result := MyTextSplit(ABaseStr, ASplitter)
  else
    Result := MyStrSplit(ABaseStr, ASplitter);

end;

{Array Function}
// 功能：生成指定长度的随机整数数组
// 参数：
//  - const ANum: Integer       生成的数组的长度
//  - const AMin: Integer = 0   元素取值的最小值
//  - const AMax: Integer = 100 元素取值的最大值
// 返回值类型：TIntegerArray 生成的随机整数数组
function GenerateRandomIntegerArray(const ANum: Integer; const AMin: Integer = 0; const AMax: Integer = 100): TIntegerArray;
var
  i: Integer;
begin
  if (ANum < 0) or (AMin > AMax) then
    raise Exception.Create('ANum必须是一个非负整数，并且AMax不能小于AMin！');

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
function GenerateRandomExtendedArray(const ANum: Integer; const AMin: Extended = 0.0; const AMax: Extended = 100.0): TExtendedArray;
var
  i: Integer;
begin
  if (ANum < 0) or (AMin > AMax) then
    raise Exception.Create('ANum必须是一个非负整数，并且AMax不能小于AMin！');

  SetLength(Result, ANum);
  for i := Low(Result) to High(Result) do
  begin
    Randomize;
    Result[i] := Random() * AMax + AMin;
  end;
end;

// 功能：BuildString的辅助函数，用于为结果字符串动态扩容
class procedure TArrayUtils.EnsureCapacity(var Result: string; var iResultLen, iCurrentPos: Integer; ANeededLen: Integer; var pStr: PChar);
var
  iOldPos: Integer;
begin
  if ANeededLen > iResultLen then
  begin
    iOldPos := pStr - PChar(Result); // 保存当前位置偏移
    iResultLen := Max(ANeededLen, iResultLen * 2); // 扩容策略
    SetLength(Result, iResultLen);
    pStr := PChar(Result) + iOldPos; // 重新计算指针位置
  end;
end;

// 功能：BuildString的辅助函数，用于将由动态数组元素转成的字符串写入结果字符串
class procedure TArrayUtils.CopyAndMove(var Result: string; var iResultLen, iCurrentPos: Integer; var pStr: PChar; const ASourceStr: string);
var
  iLen: Integer;
begin
  iLen := Length(ASourceStr);
  if iLen > 0 then
  begin
    EnsureCapacity(Result, iResultLen, iCurrentPos, iCurrentPos + iLen, pStr);
    Move(PChar(ASourceStr)^, pStr^, iLen * SizeOf(Char));
    Inc(pStr, iLen);
    Inc(iCurrentPos, iLen);
  end;
end;

// 功能：输入的动态数组按指定方式拼接成字符串，可自定义前后缀和分隔符
// 参数：
//  - AGetter: TGetterFunc<T>       将动态数组中的元素转成字符串的函数，须自行定义
//  - AIntArr: array of T           输入的动态数组
//  - const ASplitter: string = ',' 分隔符
//  - const APrefix: Char = '['     前缀
//  - const ASuffix: Char = ']'     后缀
// 返回值类型：string 转成的字符串
// 示例：
//  var
//    sStr: string;
//  begin
//  sStr := TArrayUtils.BuildString<Integer>(
//                        function(Index: Integer; AArray: array of Integer): string
//                        begin
//                          Result := IntToStr(AArray[Index]);
//                        end,
//                        [1, 2, 3, 4], ', ', '[', ']');
//  end;
//  sStr -> '[1, 2, 3, 4]'
class function TArrayUtils.BuildString<T>(AGetter: TGetterFunc<T>; AArray: array of T; const ASplitter: string; const APrefix: string; const ASuffix: string): string;
var
  i, iCurrentPos, iResultLen, iSpLen, iPreLen, iSuLen, ACount: Integer;
  pStr: PChar;
begin
  ACount := Length(AArray);
  if ACount = 0 then
  begin
    Result := APrefix + ASuffix;
    Exit;
  end;
  iSpLen := Length(ASplitter);
  iPreLen := Length(APrefix);
  iSuLen := Length(ASuffix);
  // 初始容量估算：每个字符串假设平均20个字符
  iResultLen := ACount * (20 + iSpLen) + iPreLen + iSuLen;
  SetLength(Result, iResultLen);
  pStr := PChar(Result);
  iCurrentPos := 0;
  // 添加前缀
  CopyAndMove(Result, iResultLen, iCurrentPos, pStr, APrefix);
  // 处理元素
  for i := 0 to ACount - 1 do
  begin
    CopyAndMove(Result, iResultLen, iCurrentPos, pStr, AGetter(i, AArray));
    // 不是最后一个元素才添加分隔符
    if i < ACount - 1 then
      CopyAndMove(Result, iResultLen, iCurrentPos, pStr, ASplitter);
  end;
  // 添加后缀
  CopyAndMove(Result, iResultLen, iCurrentPos, pStr, ASuffix);
  // 调整最终长度
  SetLength(Result, iCurrentPos);
end;


// 功能：将整数数组转换成字符串，可自定义前后缀和分隔符
// 参数：
//  - AIntArr: array of Integer     输入的整数数组
//  - const ASplitter: string = ',' 分隔符
//  - const APrefix: Char = '['     前缀
//  - const ASuffix: Char = ']'     后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.IntArrayToString([1, 2, 3, 4], ', ', '[', ']') -> '[1, 2, 3, 4]'
class function TArrayUtils.IntArrayToString(AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
begin
  Result := BuildString<Integer>(
              function(Index: Integer; AArray: array of Integer): string
              begin
                Result := IntToStr(AArray[Index]);
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
class function TArrayUtils.IntArrayToStringF(const AFormat: string; AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
begin
  Result := BuildString<Integer>(
              function(Index: Integer; AArray: array of Integer): string
              begin
                Result := FormatFloat(AFormat, AArray[Index]);
              end,
              AIntArr, ASplitter, APrefix, ASuffix);
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
              function(Index: Integer; AArray: array of TObject): string
              begin
                Result := AArray[Index].ToString;
              end,
              AObjList, ASplitter, APrefix, ASuffix);
end;

// 功能：将浮点数数组转换成字符串，可自定义前后缀和分隔符
// 参数：
//  - AIntArr: array of Extended      输入的浮点数数组
//  - const ASplitter: string = ','   分隔符
//  - const APrefix: string = '['     前缀
//  - const ASuffix: string = ']'     后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.FloatArrayToString([1.0, 2.0, 3.0, 4.0], ', ', '[', ']') -> '[1, 2, 3, 4]'
class function TArrayUtils.FloatArrayToString(AFloatArr: array of Extended; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
begin
  Result := BuildString<Extended>(
              function(Index: Integer; AArray: array of Extended): string
              begin
                Result := FloatToStr(AArray[Index]);
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
class function TArrayUtils.FloatArrayToStringF(const AFormat: string; AFloatArr: array of Extended;
  const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
begin
  Result := BuildString<Extended>(
              function(Index: Integer; AArray: array of Extended): string
              begin
                Result := FormatFloat(AFormat, AArray[Index]);
              end,
              AFloatArr, ASplitter, APrefix, ASuffix);
end;


// 功能: 将字符串的数组拼接成一个字符串,可自行指定前缀、后缀、中间分隔符
// 参数：
//  - AStrList: array of string   输入的字符串数组
//  - const ASplitter: string = ',' 分隔符
//  - const APrefix: string = '['   前缀
//  - const ASuffix: string = ']'   后缀
// 返回值类型：string 转成的字符串
// 示例：TArrayUtils.StringListToString(['1.0', '2.0', '3.0', '4.0'], ', ', '[', ']') -> '[1, 2, 3, 4]'
class function TArrayUtils.StringListToString(AStrList: array of string; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
begin
  Result := BuildString<string>(
              function(Index: Integer; AArray: array of string): string
              begin
                Result := AArray[Index];
              end,
              AStrList, ASplitter, APrefix, ASuffix);
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

  Result := Copy(ASourceStr, Max(1, Length(ASourceStr) - ALen + 1), Min(Length(ASourceStr), ALen));
end;


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
function CheckArrayAllElemAreVaild(const APBase, AContext: Pointer; const AElemNum, AElemSize: TSize_T; const ACheckFunc: TCheckFunction): Boolean; overload;
var
  i: TSize_T;
begin
  Result := False;

  if not(Assigned(APBase) and (AElemSize > 0) and (AElemNum > 0) and Assigned(ACheckFunc)) then
    Exit;

  for i := 0 to AElemNum - 1 do
  begin
    if not ACheckFunc(GetPtr(APBase, i * AElemSize), AContext) then
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
function CheckArrayAllElemAreVaild(const AArray: array of Integer; const AContext: Pointer; ACheckFunc: TCheckFunction): Boolean; overload;
var
  i: integer;
begin
  Result := False;

  if not Assigned(ACheckFunc) then
    Exit;

  for i  := Low(AArray) to High(AArray) do
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
  
// 创建一个指定大小的Buffer
procedure CreateMemSwapBuffer(ABufferSize: TSize_T);
begin
  MemSwapBufferSize := ABufferSize;
  MemSwapBuffer := AllocMem(MemSwapBufferSize);
end;

// 释放申请的Buffer空间
procedure DestoryMemSwapBuffer;
begin
  FreeMem(MemSwapBuffer, MemSwapBufferSize);
  MemSwapBuffer := nil;
  MemSwapBufferSize := 0;
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
function GetPtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer;
begin
  Result := Pointer(TSize_T(ApBase) + AOffset);
end;

// 功能：将指针向左移动指定个字节
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
  Result := GetPtr(ApBase, AOffset);
end;

// 功能：实数比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - ARealType: TRealType = TRealType.rtInt 比较的实数类型，默认为Integer
//  返回值：Integer
//    - 1  APData1 > APData2
//    - 0   APData1 = APData2
//    - -1   APData1 < APData2
function RealCmpBase(APData1, APData2: Pointer; ARealType: TRealType = TRealType.rtInt): Integer;
begin
  case ARealType of
    TRealType.rtInt: Result := CompareValue(PInteger(APData1)^, PInteger(APData2)^);
    TRealType.rtInt64: Result := CompareValue(PInt64(APData1)^, PInt64(APData2)^);
    TRealType.rtUInt64: Result := CompareValue(PUInt64(APData1)^, PUInt64(APData2)^);
    TRealType.rtSingle: Result := CompareValue(PSingle(APData1)^, PSingle(APData2)^);
    TRealType.rtDouble: Result := CompareValue(PDouble(APData1)^, PDouble(APData2)^);
    TRealType.rtExtedent: Result := CompareValue(PExtended(APData1)^, PExtended(APData2)^);
  else
    raise Exception.Create('Error Message');
  end;
end;

// 功能：整数数组升序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 < APData2
//    - 0   APData1 = APData2
//    - 1   APData1 > APData2
function IntegerCompareAsc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData1, APData2);
end;

// 功能：整数数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 > APData2
//    - 0   APData1 = APData2
//    - 1   APData1 < APData2
function IntegerCompareDesc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData2, APData1);
end;

// 功能：整数数组升序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 < APData2
//    - 0   APData1 = APData2
//    - 1   APData1 > APData2
function Int64CompareAsc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData1, APData2, TRealType.rtInt64);
end;

// 功能：整数数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 > APData2
//    - 0   APData1 = APData2
//    - 1   APData1 < APData2
function Int64CompareDesc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData2, APData1, TRealType.rtInt64);
end;

// 功能：整数数组升序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 < APData2
//    - 0   APData1 = APData2
//    - 1   APData1 > APData2
function UInt64CompareAsc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData1, APData2, TRealType.rtUInt64);
end;

// 功能：整数数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 > APData2
//    - 0   APData1 = APData2
//    - 1   APData1 < APData2
function UnInt64CompareDesc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData2, APData1, TRealType.rtUInt64);
end;

// 功能：浮点数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 > APData2
//    - 0   APData1 = APData2
//    - 1   APData1 < APData2
function ExtendedCompareAsc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData1, APData2, TRealType.rtExtedent);
end;

// 功能：浮点数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 < APData2
//    - 0   APData1 = APData2
//    - 1   APData1 > APData2
function ExtendedCompareDesc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData2, APData1, TRealType.rtExtedent);
end;

// 功能：浮点数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 > APData2
//    - 0   APData1 = APData2
//    - 1   APData1 < APData2
function SingleCompareAsc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData1, APData2, TRealType.rtSingle);
end;

// 功能：浮点数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 < APData2
//    - 0   APData1 = APData2
//    - 1   APData1 > APData2
function SingleCompareDesc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData2, APData1, TRealType.rtSingle);
end;

// 功能：浮点数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 > APData2
//    - 0   APData1 = APData2
//    - 1   APData1 < APData2
function DoubleCompareAsc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData1, APData2, TRealType.rtDouble);
end;

// 功能：浮点数组降序比较函数
//  参数：
//    - APData1: Pointer   指向第一个被比较参数的指针
//    - APData2: Pointer   指向第二个被比较参数的指针
//    - APContext: Pointer 指向额外参数的指针
//  返回值：Integer
//    - -1  APData1 < APData2
//    - 0   APData1 = APData2
//    - 1   APData1 > APData2
function DoubleCompareDesc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := RealCmpBase(APData2, APData1, TRealType.rtDouble);
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
  if (APBase = nil) or (AElemNum <= 1) or (AElemSize = 0) then
    Exit;

  // 设置左右指针
  pLeft := APBase;
  pRight := GetPtr(APBase, (AElemNum - 1) * AElemSize);

  // 从两端向中间交换元素
  CreateMemSwapBuffer(AElemSize);
  try
    for i := 0 to (AElemNum div 2) - 1 do
    begin
      MemSwapFaster(pLeft, pRight);
      pLeft := GetPtr(pLeft, AElemSize);     // 左指针右移
      pRight := LeftMovePtr(pRight, AElemSize);  // 右指针左移（注意负偏移）
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
function IsReverseSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;
var
  i: TSize_T;
begin
  Result := True;

  // 参数有效性检查
  if (APBase = nil) or (AElemNum <= 1) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit(False);

  // 检查每相邻两个元素是否都是逆序的
  for i := 0 to AElemNum - 2 do
  begin
    if ACompareFunc(GetPtr(APBase, i * AElemSize), GetPtr(APBase, (i + 1) * AElemSize), APContext) > 0 then
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
procedure OptimizedSort(ASortFunc: TSortFunction; const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
begin
  // 参数有效性检查
  if (APBase = nil) or (AElemNum <= 1) or (AElemSize = 0) or (not Assigned(ACompareFunc)) or (not Assigned(ASortFunc)) then
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
function IsSorted(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean;
var
  i: TSize_T;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit(False);

  for i := 0 to AElemNum - 2 do
  begin
    if ACompareFunc(GetPtr(APBase, i * AElemSize), GetPtr(APBase, (i + 1) * AElemSize), APContext) > 0 then
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
//    aIntegerArr: TIntegerArray;
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
procedure BubbleSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  bFlag: Boolean;
  i, j: Integer;
  PData1, PData2: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效

  CreateMemSwapBuffer(AElemSize);
  try
    for i := 0 to AElemNum - 1 do
    begin
      bFlag := False;

      for j := 0 to AElemNum - 2 - i do
      begin
        PData1 := GetPtr(APBase, j * AElemSize);
        PData2 := GetPtr(APBase, (j + 1) * AElemSize);
        if ACompareFunc(PData1, PData2, APContext) > 0 then
        begin
          MemSwapFaster(PData1, PData2);
//          MemSwap(PData1, PData2, AElemSize);
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
//    aIntegerArr: TIntegerArray;
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
procedure InsertionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i, j: TSize_T;
  pKey: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效

  pKey := AllocMem(AElemSize);
  try
    for i := 1 to AElemNum - 1 do
    begin
      Move(GetPtr(APBase, i * AElemSize)^, pKey^, AElemSize);
      j := i;

      while (j >= 1) and (ACompareFunc(pKey, GetPtr(APBase, (j - 1) * AElemSize), APContext) < 0) do
      begin
        Move(GetPtr(APBase, (j - 1) * AElemSize)^, GetPtr(APBase, j * AElemSize)^, AElemSize);
        Dec(j);
      end;

      Move(pKey^, GetPtr(APBase, j * AElemSize)^, AElemSize)

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
//    aIntegerArr: TIntegerArray;
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
procedure SelectionSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i, j, iMinIndex: TSize_T;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效

  CreateMemSwapBuffer(AElemSize);
  try
    for i := 0 to AElemNum - 2 do
    begin
      iMinIndex := i;

      for j := i + 1 to AElemNum - 1 do
      begin
        if ACompareFunc(GetPtr(APBase, j * AElemSize), GetPtr(APBase, iMinIndex * AElemSize), APContext) < 0 then
          iMinIndex := j;
      end;

      if iMinIndex <> i then
        MemSwapFaster(GetPtr(APBase, i * AElemSize), GetPtr(APBase, iMinIndex * AElemSize));
    end;
  finally
    DestoryMemSwapBuffer;
  end;
end;

// 功能：生成Hibbard增量序列
//  参数：ALength: Integer 需要排序的元素数量
//  返回值：TIntegerArray 生成的Hibbard增量序列,[1, 3, 7, 15, 31, 63,...]
function GetHibbardStepArr(ALength: Integer): TIntegerArray;
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
//    aIntegerArr: TIntegerArray;
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
procedure ShellSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i, j, k: TSize_T;
  aHibbardStepArr: TIntegerArray;
  pKey: Pointer;
begin
  if (not Assigned(APBase)) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit; // 无需排序或参数无效
  aHibbardStepArr := GetHibbardStepArr(AElemNum);
  pKey := AllocMem(AElemSize);
  try
    for k := Low(aHibbardStepArr) to High(aHibbardStepArr) do
    begin
      for i := aHibbardStepArr[k] to AElemNum - 1 do
      begin
        Move(GetPtr(APBase, i * AElemSize)^, pKey^, AElemSize);
        j := i;

        while (j >= 1) and (ACompareFunc(pKey, GetPtr(APBase, (j - 1) * AElemSize), APContext) < 0) do
        begin
          Move(GetPtr(APBase, (j - 1) * AElemSize)^, GetPtr(APBase, j * AElemSize)^, AElemSize);
          Dec(j);
        end;

        Move(pKey^, GetPtr(APBase, j * AElemSize)^, AElemSize)

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
      LeftChildPtr := GetPtr(APBase, LeftChildIndex * AElemSize);
      CurrentNodePtr := GetPtr(APBase, LargestIndex * AElemSize);
      if ACompareFunc(LeftChildPtr, CurrentNodePtr, APContext) > 0 then
      begin
        LargestIndex := LeftChildIndex;
      end;
    end;

    // 检查右子节点是否存在且是否比当前最大节点大
    if (RightChildIndex < AElemNum) then
    begin
      RightChildPtr := GetPtr(APBase, RightChildIndex * AElemSize);
      CurrentNodePtr := GetPtr(APBase, LargestIndex * AElemSize); // 重新获取当前最大节点指针
      if ACompareFunc(RightChildPtr, CurrentNodePtr, APContext) > 0 then
      begin
        LargestIndex := RightChildIndex;
      end;
    end;

    // 如果最大节点不是当前节点，则交换它们
    if LargestIndex <> CurrentIndex then
    begin
      CurrentNodePtr := GetPtr(APBase, CurrentIndex * AElemSize);
      LargestNodePtr := GetPtr(APBase, LargestIndex * AElemSize);
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
//    aIntegerArr: TIntegerArray;
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
procedure HeapSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  i: TSize_T;
  LastNodePtr, RootNodePtr: Pointer;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
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
      LastNodePtr := GetPtr(APBase, i * AElemSize);
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
procedure MergeSortBase(const APBase: Pointer; AStart, AMid, AEnd, AElemSize: TSize_T; APContext, ATemp: Pointer; ACompareFunc: TCompareFunction);
var
  pLeftPtr, pRightPtr, pTempCurrent: Pointer;
  iLeftIndex, iRightIndex, iTempIndex: TSize_T;
begin

  iLeftIndex := AStart;      // 当前处理的左边子数组的元素索引
  iRightIndex := AMid + 1;   // 当前处理的右边子数组的元素索引
  iTempIndex := 0;           // 临时数组的当前写入索引

  while (iLeftIndex <= AMid) and (iRightIndex <= AEnd) do
  begin
    pLeftPtr := GetPtr(APBase, iLeftIndex * AElemSize);
    pRightPtr := GetPtr(APBase, iRightIndex * AElemSize);
    pTempCurrent := GetPtr(ATemp, iTempIndex * AElemSize);

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
    pTempCurrent := GetPtr(ATemp, iTempIndex * AElemSize);
    Move(GetPtr(APBase, iLeftIndex * AElemSize)^, pTempCurrent^, AElemSize);
    Inc(iLeftIndex);
    Inc(iTempIndex);
  end;

  while iRightIndex <= AEnd do
  begin
    pTempCurrent := GetPtr(ATemp, iTempIndex * AElemSize);
    Move(GetPtr(APBase, iRightIndex * AElemSize)^, pTempCurrent^, AElemSize);
    Inc(iRightIndex);
    Inc(iTempIndex);
  end;

  // 将临时数组的内容复制回原数组
  Move(ATemp^, GetPtr(APBase, AStart * AElemSize)^, iTempIndex * AElemSize);
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
procedure MergeSortBaseWithTemp(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext, ATemp: Pointer; ACompareFunc: TCompareFunction);
var
  iWidth, i, iLeft, iMid, irRight: TSize_T;
begin
    // 第一步：处理所有长度 <= MINSUBARRLEN 的段
  i := 0;
  while i < AElemNum do
  begin
    irRight := Min(i + MINSUBARRLEN - 1, AElemNum - 1);
    InsertionSort(GetPtr(APBase, i * AElemSize), irRight - i + 1, AElemSize, APContext, ACompareFunc);
//  SelectionSort(GetPtr(APBase, i * AElemSize), irRight - i + 1, AElemSize, APContext, ACompareFunc);
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
        MergeSortBase(APBase, iLeft, iMid, irRight, AElemSize, APContext, ATemp, ACompareFunc);
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
//    aIntegerArr: TIntegerArray;
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
//    aIntegerArr: TIntegerArray;
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

// 功能：未经优化的快速排序，使用数组中间的元素作为初始支点
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
//    aIntegerArr: TIntegerArray;
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
procedure QuickSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  L, R: TSize_T;
  // 参考 System.Generics.Collections.TArray.Sort<T>实现
  procedure InternalQuickSort(const ABase: Pointer; const AElemNum, AElemSize: TSize_T; const APContext: Pointer; const ACompareFunc: TCompareFunction; const AL, AR: TSize_T);
  var
    I, J: TSize_T;
    pivotPtr, tempPtr: Pointer;
  begin
    if (AR - AL) <= 0 then
      Exit;  // 子数组长度为1或0，退出

    I := AL;
    J := AR;
    // 选择pivot：中间元素
    pivotPtr := RightMovePtr(ABase, ((AL + AR) shr 1) * AElemSize);

    repeat
      // 找到左边第一个 >= pivot 的元素
      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, I * AElemSize), pivotPtr, APContext) < 0) do
        Inc(I);

      // 找到右边第一个 <= pivot 的元素
      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, J * AElemSize), pivotPtr, APContext) > 0) do
        if J <> 0 then
          Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          // 交换元素
          MemSwap(RightMovePtr(ABase, I * AElemSize), RightMovePtr(ABase, J * AElemSize), AElemSize);
        end;
        Inc(I);
        if J <> 0 then
          Dec(J);
      end;
    until I > J;

    // 递归排序左子数组
    if AL < J then
      InternalQuickSort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, AL, J);

    // 递归排序右子数组
    if I < AR then
      InternalQuickSort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, I, AR);
  end;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  // 调用内部递归函数，初始L=0, R=AElemNum-1
  InternalQuickSort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, 0, AElemNum - 1);
end;

// 功能：优化的快速排序，使用数组中间的元素作为初始支点
// 参数：
//   - const APBase: Pointer           指向待排序的数组的指针
//   - AElemNum: TSize_T                需要排序的元素个数
//   - AElemSize: TSize_T               需要排序的元素所占空间的大小（以字节大小计）
//   - APContext: Pointer              指向一个额外参数的指针，在比较函数里使用
//   - ACompareFunc: TCompareFunction  用于比较待排序数组中任两个元素的大小以确定
//                                     排序依据，若第一个参数大于第二个参数时返回
//                                     正数则为升序，否则为降序，须调用者自行实现
// 说明：基于内省排序修改 ，当分区元素不大于MINSUBARRLEN时使用插入排序完成。如果递归深度超过阈值则会使用HybridSort代替完成排序
//      经过简单测试，当数组长度不超过1E7时不会超过递归深度阈值。相较于QuickSort要快大约10%
// 使用示例：
//  var
//    aIntegerArr: TIntegerArray;
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
procedure IntroSort(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);
var
  L, R: Integer;
  maxDepth: Integer;  // 最大递归深度阈值

  procedure InternalIntrosort(const ABase: Pointer; const AElemNum, AElemSize: TSize_T;
    const APContext: Pointer; const ACompareFunc: TCompareFunction; const AL, AR: Integer; const ADepth: Integer);
  var
    I, J: Integer;
    pivotPtr, leftPtr, rightPtr: Pointer;
  begin
    if AL >= AR then
      Exit;

    if AR - AL + 1 <= MINSUBARRLEN then
    begin
      InsertionSort(ABase, AR - AL + 1, AElemSize, APContext, ACompareFunc);
      Exit;
    end;

    if ADepth > maxDepth then
    begin
      HybridSort(ABase, AElemNum, AElemSize, APContext, ACompareFunc);  // 切换到混合排序
      Exit;
    end;

    I := AL;
    J := AR;
    pivotPtr := RightMovePtr(ABase, ((AL + AR) shr 1) * AElemSize);
    repeat
      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, I * AElemSize), pivotPtr, APContext) < 0) do Inc(I);
      while (I <= J) and (ACompareFunc(RightMovePtr(ABase, J * AElemSize), pivotPtr, APContext) > 0) do Dec(J);
      if I <= J then
      begin
        if I <> J then
          MemSwap(RightMovePtr(ABase, I * AElemSize), RightMovePtr(ABase, J * AElemSize), AElemSize);
        Inc(I);
        Dec(J);
      end;
    until I > J;

    // 递归左边
    InternalIntrosort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, AL, J, ADepth + 1);
    // 递归右边
    InternalIntrosort(ABase, AElemNum, AElemSize, APContext, ACompareFunc, I, AR, ADepth + 1);
  end;
begin
  if (APBase = nil) or (AElemNum = 0) or (AElemSize = 0) or (not Assigned(ACompareFunc)) then
    Exit;

  // 计算最大深度：通常2 * log2(AElemNum)
  maxDepth := 2 * Trunc(Log2(AElemNum));

  InternalIntrosort(APBase, AElemNum, AElemSize, APContext, ACompareFunc, 0, Integer(AElemNum) - 1, 0);
end;

{类三元运算}
// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Integer  条件为True时的返回值
//   - AFalseValue: Integer 条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Integer): Integer; overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: string   条件为True时的返回值
//   - AFalseValue: string  条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: string): string; overload;
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
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Extended): Extended; overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Pointer  条件为True时的返回值
//   - AFalseValue: Pointer 条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Pointer): Pointer; overload;
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
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TObject): TObject; overload;
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
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Boolean): Boolean; overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

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
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Int64    条件为True时的返回值
//   - AFalseValue: Int64   条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Int64): Int64; overload;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 参数：
//   - ACondition: Boolean  判断条件
//   - ATrueValue: Double   条件为True时的返回值
//   - AFalseValue: Double  条件为False时的返回值
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Double): Double; overload;
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
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: AnsiString): AnsiString; overload;
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
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TDateTime): TDateTime; overload;
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
procedure IfThen(var AResult: Integer; ACondition: Boolean; ATrueValue, AFalseValue: Integer); overload;
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
procedure IfThen(var AResult: string; ACondition: Boolean; ATrueValue, AFalseValue: string); overload;
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
procedure IfThen(var AResult: Extended; ACondition: Boolean; ATrueValue, AFalseValue: Extended); overload;
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
procedure IfThen(var AResult: Pointer; ACondition: Boolean; ATrueValue, AFalseValue: Pointer); overload;
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
procedure IfThen(var AResult: TObject; ACondition: Boolean; ATrueValue, AFalseValue: TObject); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
end;

// 功能：实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
// 参数：
//   - var AResult: Boolean   需要赋值的变量
//   - ACondition: Boolean    判断条件
//   - ATrueValue: Boolean    条件为True时的返回值
//   - AFalseValue: Boolean   条件为False时的返回值
procedure IfThen(var AResult: Boolean; ACondition: Boolean; ATrueValue, AFalseValue: Boolean); overload;
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
procedure IfThen(var AResult: Char; ACondition: Boolean; ATrueValue, AFalseValue: Char); overload;
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
procedure IfThen(var AResult: Int64; ACondition: Boolean; ATrueValue, AFalseValue: Int64); overload;
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
procedure IfThen(var AResult: Double; ACondition: Boolean; ATrueValue, AFalseValue: Double); overload;
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
procedure IfThen(var AResult: AnsiString; ACondition: Boolean; ATrueValue, AFalseValue: AnsiString); overload;
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
procedure IfThen(var AResult: TDateTime; ACondition: Boolean; ATrueValue, AFalseValue: TDateTime); overload;
begin
  if ACondition then
    AResult := ATrueValue
  else
    AResult := AFalseValue;
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

  if (ACompareFunc(ASearchedElem, APBase, APContext) < 0) or
    (ACompareFunc(ASearchedElem, GetPtr(APBase, (AElemNum - 1) * AElemSize), APContext) > 0) then
    Exit(-1);

  if ACompareFunc(ASearchedElem, APBase, APContext) = 0 then
    Exit(0)
  else
  if ACompareFunc(ASearchedElem, GetPtr(APBase, (AElemNum - 1) * AElemSize), APContext) = 0 then
  Exit(AElemNum - 1);

  iA := 0;
  iB := AElemNum - 1;
  iMiddle := GetHalf(iA + iB);
  while (iMiddle > iA) and (iMiddle < iB) do
  begin
    if ACompareFunc(ASearchedElem, GetPtr(APBase, iMiddle * AElemSize), APContext) = 0 then
    begin
      iA := Max(iMiddle - 1, 0);
      while True do
      begin
        if ACompareFunc(ASearchedElem, GetPtr(APBase, iA * AElemSize), APContext) <> 0 then
        begin
          Inc(iA);
          Break;
        end;

        Dec(iA);
      end;
      Exit(iA)
    end
    else
    if ACompareFunc(ASearchedElem, GetPtr(APBase, iMiddle * AElemSize), APContext) < 0 then
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
// 返回值: TIntegerArray 为空：没有找到符合条件的元素，不为空：找到的所有符合条件的元素的索引（从0开始）数组
function BinarySearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TIntegerArray;
var
  iMiddle, iB, i: Integer;
begin
  iMiddle := BinarySearch(APBase, AElemNum, AElemSize, APContext, ASearchedElem, ACompareFunc);
  if iMiddle < 0 then
  begin
    SetLength(Result, 0);
    Exit;
  end;

  iB := Min(iMiddle + 1, AElemNum - 1);
  while iB <= AElemNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, GetPtr(APBase, iB * AElemSize), APContext) <> 0 then
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
function SequentialSearch(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): Integer;
begin
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not Assigned(ACompareFunc) then
    Exit(-1);

  for Result := 0 to AElemNum - 1 do
    if ACompareFunc(ASearchedElem, GetPtr(APBase, Result * AElemSize), APContext) = 0 then
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
function SequentialSearchEx(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction; AOffset: Cardinal = 0): Integer;
var
  i: TSize_T;
begin
  Result := -1;

  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not Assigned(ACompareFunc) then
    Exit(-1);

  for i := 0 to AElemNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, GetPtr(APBase, i * AElemSize), APContext) = 0 then
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
// 返回值: TIntegerArray 为空：没有找到符合条件的元素，不为空：找到的所有符合条件的元素的索引（从0开始）数组
function SequentialSearchs(const APBase: Pointer; AElemNum, AElemSize: TSize_T; const APContext, ASearchedElem: Pointer; ACompareFunc: TCompareFunction): TIntegerArray;
var
  iIndex, iTemp: Integer;
begin
  SetLength(Result, 0);
  if not Assigned(APBase) or (AElemNum = 0) or (AElemSize = 0) or not Assigned(ACompareFunc) then
    Exit;

  iTemp := 1;
  for iIndex := 0 to AElemNum - 1 do
  begin
    if ACompareFunc(ASearchedElem, GetPtr(APBase, iIndex * AElemSize), APContext) = 0 then
    begin
      SetLength(Result, iTemp);
      Inc(iTemp);
      Result[High(Result)] := iIndex;
    end;
  end;

end;

{Other Function}
// 功能：比较两个指针指向的变量的“大小”，若APSmallerData比APBiggerData“大”就交换它们指向的内存的内容
// 参数：
//   - const APSmallerData: Pointer         指向应当较小的变量的指针
//   - const APBiggerData: Pointer          指向应当较大的变量的指针
//   - const APContext: Pointer             比较函数的额外参数
//   - const ACompareFunc: TCompareFunction 用于比较两个元素的大小，若第一个参数大于第二个参数则返回正数，
//                                          须调用者自行实现
//   - const ASize: TSize_T: Pointer        指针指向的变量的内存大小（以字节计）
procedure CompareAndSwap(const APSmallerData, APBiggerData, APContext: Pointer; const ACompareFunc: TCompareFunction; const ASize: TSize_T);
begin
  if not (Assigned(APSmallerData) and Assigned(APBiggerData) and Assigned(ACompareFunc)) then
    raise Exception.Create('APSmallerData 与 APBiggerData 和 ACompareFunc必须有效');

  if ACompareFunc(APSmallerData, APBiggerData, APContext) > 0 then
    MemSwap(APSmallerData, APBiggerData, ASize);
end;

// 功能：将颜色转成以RRGGBB表示的字符串
function ColorToRRGGBBStr(AColor: TColor): string;
var
  R, G, B: Byte;
  ColorValue: LongWord; // TColor 在内部是 LongWord (32位整数)
begin
  ColorValue := LongWord(AColor);

  R := (ColorValue shr 16) and $FF;
  G := (ColorValue shr 8) and $FF;
  B := ColorValue and $FF;

  Result := IntToHex(B, 2) + IntToHex(G, 2) + IntToHex(R, 2);
end;

function IsXDigit(AChar: Char): Boolean;
begin
  Result := CharInSet(AChar, ['0'..'9', 'A'..'F']);
end;

function IsAllCharFitHex(const AStr: string): Boolean;
var
  StrP: PChar;
  i: Integer;
begin
  StrP := PChar(AStr);
  Result := False;
  for i := 0 to Length(AStr) - 1 do
  begin
    if not CharInSet(StrP^, ['0'..'9', 'A'..'F']) then
      Exit;
  end;
  Result := True;  
end;

// 功能：将以RRGGBB表示的字符串转成颜色
function RRGGBBStrToColor(AStr: string): TColor;
var
  ColorString: string;
  R, G, B: Byte;
begin
  ColorString := UpperCase(Trim(AStr)); // 转换为大写，方便处理

  ColorString := Copy(ColorString, Max(0, Length(ColorString) - 6), 6);

  // 检查是否都是十六进制字符 (0-9, A-F)
  if not IsAllCharFitHex(ColorString) then
  begin
    Exit;
  end;

  R := StrToIntDef('$' + Copy(ColorString, 1, 2), 0);

  G := StrToIntDef('$' + Copy(ColorString, 3, 2), 0);

  B := StrToIntDef('$' + Copy(ColorString, 5, 2), 0);

  Result := RGB(R, G, B);

end;

end.
