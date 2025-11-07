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

{*这个单元提供一些通用的函数或过程，使用的所有非自定义单元都是Delphi提供的系统单元*}
unit FuncToolPublicUnit;

interface

uses
  {*Delphi系统单元*}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections, System.TypInfo,
  {*自定义单元*}
  GeneralTypeUnit;

{Memory Function}
function MemCompare(const APData1, APData2: Pointer; const ASize: TSize_T): Boolean;
procedure MemSwap(const APData1, APData2: Pointer; const ASize: TSize_T); overload; inLine;
procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: TSize_T); overload; inLine;


{String Function}
function StrIsEmpty(var Str: string): Boolean; overload;
function StrIsEmpty(const Str: string; var TrimedStr: string): Boolean; overload;
function StrTrimIsEmpty(const Str: string): Boolean;
function PosIndex(const SubStr, Str: string; Index: Integer; AIsOverlap: Boolean = False): Integer;
function ReverseStringP(const ABaseStr: string): string;
function LeftCut(const ASourceStr: string; const ALen: Integer): string;
function LeftCutBySplitter(const ASourceStr, ASplitter: string): string;
function RightCut(const ASourceStr: string; const ALen: Integer): string;
function RightCutBySplitter(const ASourceStr, ASplitter: string): string;
function QuotedStrSQL(const S: string): string;

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
function LeftMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer; inLine;
function RightMovePtr(const ApBase: Pointer; const AOffset: TSize_T): Pointer; inLine;
function MovePtr(const APBase: Pointer; const AOffset: NativeInt): Pointer; inLine;

// 为方便调用，提供部分类型的比较函数
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

procedure OptimizedSort(ASortFunc: TSortFunction; const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction);

{TCompareFuncs}
type
  TCompareFuncs = class
  public
    class function CompareInteger(AFirst, ASecond: Integer): Integer; static; inline;
    class function CompareInt64(AFirst, ASecond: Int64): Integer; static; inline;
    class function CompareUInt64(AFirst, ASecond: UInt64): Integer; static; inline;
    class function CompareUInteger(AFirst, ASecond: Cardinal): Integer; static; inline;
    class function CompareSingle(AFirst, ASecond: Single): Integer; static; inline;
    class function CompareDouble(AFirst, ASecond: Double): Integer; static; inline;
    class function CompareExtended(AFirst, ASecond: Extended): Integer; static; inline;
  end;

{TArraySortUtils<T>}
type
  TGenericCompareFunc<T> = reference to function(AP1, AP2: T): Integer;
  // 对泛型数组进行排序的方法类
  TArraySortUtils<T> = class
  private
    FGenericCompareFunc: TGenericCompareFunc<T>;
    FCompareFunc: TCompareFunction;
    FTypeInfo: PTypeInfo;
    FReverseSort: Boolean;
    function GetTypeInfo: PTypeInfo;
    function GetCompareFunc: TCompareFunction;
    procedure SetFGenericCompareFunc(ACmpFunc: TGenericCompareFunc<T>);
    function GetFGenericCompareFunc: TGenericCompareFunc<T>;
    function AdjustRound(var ALeftEndPoint, ARightEndPoint: Integer; const AArray: array of T): Integer;
    function GetReverseSort: Boolean;
    procedure SetReverseSort(AFlag: Boolean);
  public
    property CompareFunc: TGenericCompareFunc<T> read GetFGenericCompareFunc write SetFGenericCompareFunc;
    property ReverseSort: Boolean read GetReverseSort write SetReverseSort;

    constructor Create(ACmpFunc: TGenericCompareFunc<T>); overload;
    constructor Create(); overload;
    destructor Destroy; override;

    procedure Sort(var AArray: array of T; AStartIndex, AEndIndex: Integer; ASortFunc: TSortFunction); overload;
    procedure Sort(var AArray: array of T; AStartIndex: Integer; ASortFunc: TSortFunction); overload;
    procedure Sort(var AArray: array of T; ASortFunc: TSortFunction); overload;
    procedure Sort(var AArray: array of T; AStartIndex, AEndIndex: Integer); overload;
    procedure Sort(var AArray: array of T; AStartIndex: Integer); overload;
    procedure Sort(var AArray: array of T); overload;
  end;

function GenerateRandomIntegerArray(const ANum: Integer; const AMin: Integer = 0; const AMax: Integer = 100): TIntegerArray;
function GenerateRandomExtendedArray(const ANum: Integer; const AMin: Extended = 0.0; const AMax: Extended = 100.0): TExtendedArray;

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
    class function BuildString<T>(AElemToStringFunc: TElemToStringFunc<T>; const AArray: array of T; const ASplitter: string; const APrefix: string; const ASuffix: string): string; static;
    class function IntArrayToString(AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function IntArrayToStringF(const AFormat: string; AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function FloatArrayToString(AFloatArr: array of Extended; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function FloatArrayToStringF(const AFormat: string; AFloatArr: array of Extended; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function StringArrayToString(AStrArray: array of string; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    class function ObjectListToString(AObjList: array of TObject; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string; static;
    // Generate Array
    class function GenerateArray<T>(const ALen: Integer; GetElemFunc: TElemGenerator<T>): TArray<T>; static;
    class function SplitStrToArray(const SrcStr, Splitter: string): TStringArray; static;
    // Convert
    class function ListToArray<T>(AList: TList<T>): TArray<T>; static;
    class function ArrayToList<T>(AArray: array of T): TList<T>; static;
    // Other
    class procedure ReverseAeery<T>(var AArray: array of T); static;
    class function IsMember<T>(AItem: T; AArray: array of T): Boolean; overload; static;
    class function IsMember<T>(AItem: T; AArray: array of T; CompareFunc: TGenericCompareFunc<T>): Boolean; overload; static;

    class Procedure ForEach<T>(var AArray: array of T; AEachFunc: TEachItemFunc<T>); overload;
  end;

{类三元运算}
// 实现类似C/C++的三元运算符的功能，如果ACondition为True就返回ATrueValue，否则返回AFalseValue
// 部分重载已在System.Math中实现，为避免冲突，在此处实现其余重载
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: string): string; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Pointer): Pointer; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TObject): TObject; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: Char): Char; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: AnsiString): AnsiString; overload;
function IfThen(ACondition: Boolean; ATrueValue, AFalseValue: TDateTime): TDateTime; overload;

// 实现类似C/C++的三元运算符的功能，如果ACondition为True就置AResult的值为ATrueValue，否则为AFalseValue
procedure IfThen(var AResult: Integer; ACondition: Boolean; ATrueValue, AFalseValue: Integer); overload;
procedure IfThen(var AResult: string; ACondition: Boolean; ATrueValue, AFalseValue: string); overload;
procedure IfThen(var AResult: Extended; ACondition: Boolean; ATrueValue, AFalseValue: Extended); overload;
procedure IfThen(var AResult: Pointer; ACondition: Boolean; ATrueValue, AFalseValue: Pointer); overload;
procedure IfThen(var AResult: TObject; ACondition: Boolean; ATrueValue, AFalseValue: TObject); overload;
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

{Color Function}

function ColorToRRGGBBStr(AColor: TColor): string;
function RRGGBBStrToColor(AStr: string; ADefaultColor: LongWord = $00FFFFFF): TColor;

{Other Function}
// 检查输入的值是否在范围内，如果在就返回原始值，如果不在就返回设定的默认值
function CheckInRange(AInput, AMin, AMax: Integer; ADefaultValue: Integer = -1): Integer; overload;
function CheckInRange(AInput, AMin, AMax: Int64; ADefaultValue: Int64 = -1): Int64; overload;
function CheckInRange(AInput, AMin, AMax: Single; ADefaultValue: Single = -1): Single; overload;
function CheckInRange(AInput, AMin, AMax: Double; ADefaultValue: Double = -1): Double; overload;
function CheckInRange(AInput, AMin, AMax: Extended; ADefaultValue: Extended = -1): Extended; overload;
function CheckInRange(AInput, AMin, AMax: NativeInt; ADefaultValue: NativeInt = 0): NativeInt; overload;
function CheckInRange(AInput, AMin, AMax: NativeUInt; ADefaultValue: NativeUInt = 0): NativeUInt; overload;
function CheckInRange(AInput, AMin, AMax: UInt64; ADefaultValue: UInt64 = 0): UInt64; overload;
function CheckInRange(AInput, AMin, AMax: Char; ADefaultValue: Char = #0): Char; overload;
function CheckInRange(AInput, AMin, AMax: Cardinal; ADefaultValue: Cardinal = 0): Cardinal; overload;
function CheckInRange(AInput, AMin, AMax: Byte; ADefaultValue: Byte = 0): Byte; overload;
function CheckInRange(AInput, AMin, AMax: Word; ADefaultValue: Word = 0): Word; overload;

procedure AdjustRange(var ALeftpoint: Integer; var ARightPoint: Integer; LegalLeftPoint, LegalRightPoint: Integer);
procedure CompareAndSwap(const APSmallerData, APBiggerData, APContext: Pointer; const ACompareFunc: TCompareFunction; const ASize: TSize_T);

implementation

uses
  System.Math, System.Generics.Defaults, System.Rtti, System.RTLConsts, ExceptionStrConstsUnit;


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
function PosIndex(const SubStr, Str: string; Index: Integer; AIsOverlap: Boolean = False): Integer;
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

// 功能：使用指针实现的翻转字符串
// 参数：const ABaseStr: string  待翻转的字符串
// 返回值类型：string 翻转后的字符串
function ReverseStringP(const ABaseStr: string): string;
begin
  Result := ABaseStr;
  ReverseArray(PChar(Result), Length(ABaseStr), SIZEOFCHAR);
end;

{TArraySortUtils<T>}

// 功能：调整排序的左右端点，确保它们在数组的有效范围内。
// 参数：
//   - var ALeftEndPoint: Integer  排序范围的左端点（会被修改）
//   - var ARightEndPoint: Integer  排序范围的右端点（会被修改）
//   - const AArray: array of T    待排序的数组
// 返回值类型：Integer  调整后的有效排序元素个数
function TArraySortUtils<T>.AdjustRound(var ALeftEndPoint, ARightEndPoint: Integer; const AArray: array of T): Integer;
begin
  if ALeftEndPoint > ARightEndPoint then
    MemSwap(@ALeftEndPoint, @ARightEndPoint, SIZEOFINTEGER);

  if ALeftEndPoint > High(AArray) then
    raise ERangeError.CreateFmt(sArgumentOutOfRange_Index, [ALeftEndPoint, High(AArray)]);

  ALeftEndPoint := Max(ALeftEndPoint, Low(AArray));
  ARightEndPoint := Min(ARightEndPoint, High(AArray));

  Result := ARightEndPoint - ALeftEndPoint + 1;
end;

class function TCompareFuncs.CompareDouble(AFirst,
  ASecond: Double): Integer;
begin
  Result := CompareValue(AFirst, ASecond);
end;

class function TCompareFuncs.CompareInt64(AFirst, ASecond: Int64): Integer;
begin
  Result := CompareValue(AFirst, ASecond);
end;

class function TCompareFuncs.CompareInteger(AFirst,
  ASecond: Integer): Integer;
begin
  Result := CompareValue(AFirst, ASecond);
end;

class function TCompareFuncs.CompareSingle(AFirst,
  ASecond: Single): Integer;
begin
  Result := CompareValue(AFirst, ASecond);
end;

class function TCompareFuncs.CompareUInt64(AFirst,
  ASecond: UInt64): Integer;
begin
  Result := CompareValue(AFirst, ASecond);
end;

class function TCompareFuncs.CompareUInteger(AFirst,
  ASecond: Cardinal): Integer;
begin
  Result := CompareInteger(AFirst, ASecond);
end;

class function TCompareFuncs.CompareExtended(AFirst, ASecond: Extended): Integer;
begin
  Result := CompareValue(AFirst, ASecond);
end;


// 构造函数（无参数）
// 初始化 TArraySortUtils<T> 对象。
constructor TArraySortUtils<T>.Create;
begin
  inherited Create(); // 调用父类的构造函数
  // FReverseSort := False; // 默认不进行反向排序（升序）
  SetReverseSort(False); // 使用 Setter 方法设置反向排序标志
end;

// 构造函数（带比较函数参数）
// 初始化 TArraySortUtils<T> 对象，并设置自定义的泛型比较函数。
// 参数：
//   - ACmpFunc: TGenericCompareFunc<T>  自定义的泛型比较函数
constructor TArraySortUtils<T>.Create(ACmpFunc: TGenericCompareFunc<T>);
begin
  inherited Create();
  FGenericCompareFunc := ACmpFunc;
  // FReverseSort := False;
  SetReverseSort(False);
end;

// 析构函数
// 清理 TArraySortUtils<T> 对象占用的资源。
destructor TArraySortUtils<T>.Destroy;
begin
  FTypeInfo := nil;
  FGenericCompareFunc := nil;
  FCompareFunc := nil;
  inherited Destroy; // 调用父类的析构函数
end;

// 功能：获取用于排序的通用比较函数指针
// 如果 FGenericCompareFunc 已赋值，则根据 FReverseSort 标志生成一个
// TCompareFunction 类型的函数指针。
// 返回值类型：TCompareFunction  通用的比较函数指针
function TArraySortUtils<T>.GetCompareFunc: TCompareFunction;
begin
  if not Assigned(FCompareFunc) then
  begin
    if FReverseSort then
    begin
      FCompareFunc := function(AFirst, ASecond, AContext: Pointer): Integer
                      var
                        FirstValue, SecondValue: TValue;
                        PTypeInfoForT: PTypeInfo;
                      begin
                        PTypeInfoForT := GetTypeInfo;
                        TValue.Make(AFirst, PTypeInfoForT, FirstValue);
                        TValue.Make(ASecond, PTypeInfoForT, SecondValue);
                        Result := TGenericCompareFunc<T>(AContext)(SecondValue.AsType<T>, FirstValue.AsType<T>);
                      end;
    end
    else
    begin
      FCompareFunc := function(AFirst, ASecond, AContext: Pointer): Integer
                      var
                        FirstValue, SecondValue: TValue;
                        PTypeInfoForT: PTypeInfo;
                      begin
                        PTypeInfoForT := GetTypeInfo;
                        TValue.Make(AFirst, PTypeInfoForT, FirstValue);
                        TValue.Make(ASecond, PTypeInfoForT, SecondValue);
                        Result := TGenericCompareFunc<T>(AContext)(FirstValue.AsType<T>, SecondValue.AsType<T>);
                      end;
    end;
  end;

  Result := FCompareFunc;
end;

// 功能：获取自定义的泛型比较函数
// 返回值类型：TGenericCompareFunc<T>  自定义的泛型比较函数指针
function TArraySortUtils<T>.GetFGenericCompareFunc: TGenericCompareFunc<T>;
begin
  // 如果没有提供自定义的泛型比较函数，则使用TComparer<T>提供的默认比较函数
  if not Assigned(FGenericCompareFunc) then
  begin
    Result := function(AP1, AP2: T): Integer
              begin
                Result := TComparer<T>.Default.Compare(AP1, AP2);
              end;
  end
  else
  begin
    Result := FGenericCompareFunc;
  end;
end;

// 功能：获取反向排序标志
// 返回值类型：Boolean  True 表示反向排序（降序），False 表示正向排序（升序）
function TArraySortUtils<T>.GetReverseSort: Boolean;
begin
  Result := FReverseSort;
end;

// 功能：获取 T 类型的类型信息指针
// 如果 FTypeInfo 为空，则会自动获取 T 的类型信息并缓存。
// 返回值类型：PTypeInfo  指向 T 类型的类型信息
function TArraySortUtils<T>.GetTypeInfo: PTypeInfo;
begin
  if not Assigned(FTypeInfo) then
    FTypeInfo := TypeInfo(T);
  Result := FTypeInfo;
end;

// 功能：设置自定义的泛型比较函数
// 参数：
//   - ACmpFunc: TGenericCompareFunc<T>  要设置的自定义泛型比较函数
procedure TArraySortUtils<T>.SetFGenericCompareFunc(
  ACmpFunc: TGenericCompareFunc<T>);
begin
  FGenericCompareFunc := ACmpFunc; // 保存传入的比较函数
end;

// 功能：设置反向排序标志
// 参数：
//   - AFlag: Boolean  True 表示启用反向排序（降序），False 表示禁用（升序）
procedure TArraySortUtils<T>.SetReverseSort(AFlag: Boolean);
begin
  FReverseSort := AFlag; // 更新反向排序标志
  // 如果已经生成了通用的比较函数，需要重新生成，所以将其释放
  if Assigned(FCompareFunc) then
    FCompareFunc := nil;
end;


// 功能：对数组进行排序
// 参数：
//   - var AArray: array of T  要排序的数组
//   - AStartIndex: Integer    排序的起始索引
//   - ASortFunc: TSortFunction  用于排序的算法函数（例如 IntroSort, QuickSort 等）
procedure TArraySortUtils<T>.Sort(var AArray: array of T; AStartIndex: Integer;
  ASortFunc: TSortFunction);
begin
  Sort(AArray, AStartIndex, High(AArray), ASortFunc);
end;

// 功能：对数组进行排序（指定整个范围）
// 参数：
//   - var AArray: array of T  要排序的数组
//   - ASortFunc: TSortFunction  用于排序的算法函数
procedure TArraySortUtils<T>.Sort(var AArray: array of T;
  ASortFunc: TSortFunction);
begin
  Sort(AArray, Low(AArray), High(AArray), ASortFunc);
end;

// 功能：对数组进行排序（使用默认的 QuickSort 算法，指定起始索引）
// 参数：
//   - var AArray: array of T  要排序的数组
//   - AStartIndex: Integer    排序的起始索引
procedure TArraySortUtils<T>.Sort(var AArray: array of T; AStartIndex: Integer);
begin
  Sort(AArray, AStartIndex, High(AArray));
end;

// 功能：对数组进行排序（使用默认的 QuickSort 算法，指定整个范围）
// 参数：
//   - var AArray: array of T  要排序的数组
procedure TArraySortUtils<T>.Sort(var AArray: array of T);
begin
  Sort(AArray, Low(AArray), High(AArray));
end;

// 功能：对数组进行排序（使用默认的 QuickSort 算法，指定起始和结束索引）
// 参数：
//   - var AArray: array of T  要排序的数组
//   - AStartIndex: Integer    排序的起始索引
//   - AEndIndex: Integer      排序的结束索引
procedure TArraySortUtils<T>.Sort(var AArray: array of T; AStartIndex,
  AEndIndex: Integer);
begin
  Sort(AArray, AStartIndex, AEndIndex, QuickSort);
end;

// 功能：对数组进行排序（核心排序方法）
// 参数：
//   - var AArray: array of T  要排序的数组
//   - AStartIndex: Integer    排序的起始索引
//   - AEndIndex: Integer      排序的结束索引
//   - ASortFunc: TSortFunction  用于排序的算法函数（例如 IntroSort）
procedure TArraySortUtils<T>.Sort(var AArray: array of T; AStartIndex,
  AEndIndex: Integer; ASortFunc: TSortFunction);
var
  iLen: Integer;
begin
  if Length(AArray) < 2 then
    Exit;
  if not Assigned(ASortFunc) then
    raise EArgumentNilException.CreateResFmt(@SParamIsNil, ['ASortFunc']); // "ASortFunc 不能为空"

  iLen := AdjustRound(AStartIndex, AEndIndex, AArray);

  OptimizedSort(ASortFunc, @AArray[AStartIndex], iLen, SizeOf(T), Pointer(GetFGenericCompareFunc()), GetCompareFunc());
  {$IFDEF DEBUG}
  Writeln(Format('排序是否成功？：%s', [IfThen(IsSorted(@AArray[AStartIndex], iLen, SizeOf(T), Pointer(GetFGenericCompareFunc()), GetCompareFunc()),
    '成功', '失败')]));
  {$ENDIF}
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
function GenerateRandomExtendedArray(const ANum: Integer; const AMin: Extended = 0.0; const AMax: Extended = 100.0): TExtendedArray;
var
  i: Integer;
begin
  if ANum < 0 then
    raise EInvalidArgument.CreateResFmt(@SParamIsNegative, ['ANum']);

  if AMin > AMax then
    raise EInvalidArgument.CreateResFmt(@sParamGreaterEqual, ['AMax', 'AMin']); ;

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
class function TArrayUtils.BuildString<T>(AElemToStringFunc: TElemToStringFunc<T>; const AArray: array of T; const ASplitter: string; const APrefix: string; const ASuffix: string): string;
var
  StringBuilder: TStringBuilder;
  i, Count, LowIndex, HighIndex: Integer;
  ElemStr: string;
begin
  Count := Length(AArray);
  if Count > GetMaxVaildArrayLen then
    raise EArgumentOutOfRangeException.CreateFmt('数组长度(%d)超过最大可允许长度(%d)，可能造成栈溢出风险，请选用其他方法或自行实现！', [Count, GetMaxVaildArrayLen]);

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
class function TArrayUtils.IntArrayToString(AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
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
class function TArrayUtils.IntArrayToStringF(const AFormat: string; AIntArr: array of Integer; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
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
  CompareFunc: TGenericCompareFunc<T>): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not (Assigned(CompareFunc) and (Length(AArray) > 0)) then
    Exit;

  for i := Low(AArray) to High(AArray) do
  begin
    if CompareFunc(AItem, AArray[i]) = 0 then
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
begin
  ReverseArray(@AArray[Low(AArray)], Length(AArray), SizeOf(T));
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
class function TArrayUtils.FloatArrayToStringF(const AFormat: string; AFloatArr: array of Extended;
  const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
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
class function TArrayUtils.StringArrayToString(AStrArray: array of string; const ASplitter: string = ','; const APrefix: string = '['; const ASuffix: string = ']'): string;
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
class function TArrayUtils.GenerateArray<T>(const ALen: Integer; GetElemFunc: TElemGenerator<T>): TArray<T>;
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

  Result := Copy(ASourceStr, Max(1, Length(ASourceStr) - ALen + 1), Min(Length(ASourceStr), ALen));
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
function MovePtr(const APBase: Pointer; const AOffset: NativeInt): Pointer; inLine;
begin
  Result := Pointer(NativeInt(APBase) + AOffset);
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
    TRealType.rtInt64: Result := CompareValue(PInt64(APData1)^, PInt64(APData2)^);
    TRealType.rtUInt64: Result := CompareValue(PUInt64(APData1)^, PUInt64(APData2)^);
    TRealType.rtSingle: Result := CompareValue(PSingle(APData1)^, PSingle(APData2)^);
    TRealType.rtDouble: Result := CompareValue(PDouble(APData1)^, PDouble(APData2)^);
    TRealType.rtExtedent: Result := CompareValue(PExtended(APData1)^, PExtended(APData2)^);
  else
    Result := CompareValue(PInteger(APData1)^, PInteger(APData2)^);
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
function UInt64CompareDesc(APData1, APData2, APContext: Pointer): Integer;
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
    if ACompareFunc(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase, (i + 1) * AElemSize), APContext) > 0 then
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
    if ACompareFunc(RightMovePtr(APBase, i * AElemSize), RightMovePtr(APBase, (i + 1) * AElemSize), APContext) > 0 then
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
  i, j: TSize_T;
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
      Move(RightMovePtr(APBase, i * AElemSize)^, pKey^, AElemSize);
      j := i;

      while (j >= 1) and (ACompareFunc(pKey, RightMovePtr(APBase, (j - 1) * AElemSize), APContext) < 0) do
      begin
        Move(RightMovePtr(APBase, (j - 1) * AElemSize)^, RightMovePtr(APBase, j * AElemSize)^, AElemSize);
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
        Move(RightMovePtr(APBase, i * AElemSize)^, pKey^, AElemSize);
        j := i;

        while (j >= 1) and (ACompareFunc(pKey, RightMovePtr(APBase, (j - 1) * AElemSize), APContext) < 0) do
        begin
          Move(RightMovePtr(APBase, (j - 1) * AElemSize)^, RightMovePtr(APBase, j * AElemSize)^, AElemSize);
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
procedure MergeSortBaseWithTemp(const APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext, ATemp: Pointer; ACompareFunc: TCompareFunction);
var
  iWidth, i, iLeft, iMid, irRight: TSize_T;
begin
    // 第一步：处理所有长度 <= MINSUBARRLEN 的段
  i := 0;
  while i < AElemNum do
  begin
    irRight := Min(i + MINSUBARRLEN - 1, AElemNum - 1);
    InsertionSort(RightMovePtr(APBase, i * AElemSize), irRight - i + 1, AElemSize, APContext, ACompareFunc);
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
  // 参考 System.Generics.Collections.TArray.Sort<T>实现
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
  maxDepth: Integer;
  procedure InternalIntrosort(const ABase: Pointer; const ACurrentElemNum, AElemSize: NativeInt; // ACurrentElemNum 指的是当前处理的子数组元素个数
    const APContext: Pointer; const ACompareFunc: TCompareFunction; const AL, AR: NativeInt; const ADepth: Integer);
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
    Exit; // 元素少于2个，无需排序

  // 计算最大递归深度（2*log2(n)，至少为1）
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
    (ACompareFunc(ASearchedElem, RightMovePtr(APBase, (AElemNum - 1) * AElemSize), APContext) > 0) then
    Exit(-1);

  if ACompareFunc(ASearchedElem, APBase, APContext) = 0 then
    Exit(0)
  else
  if ACompareFunc(ASearchedElem, RightMovePtr(APBase, (AElemNum - 1) * AElemSize), APContext) = 0 then
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
      Exit(iA)
    end
    else
    if ACompareFunc(ASearchedElem, RightMovePtr(APBase, iMiddle * AElemSize), APContext) < 0 then
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
  if not Assigned(APSmallerData) then
    raise EArgumentNilException.CreateResFmt(@SParamIsNil, ['APSmallerData']);
    
  if not Assigned(APBiggerData) then
    raise EArgumentNilException.CreateResFmt(@SParamIsNil, ['APBiggerData']);
    
  if not Assigned(ACompareFunc) then
    raise EArgumentNilException.CreateResFmt(@SParamIsNil, ['ACompareFunc']);

  if ACompareFunc(APSmallerData, APBiggerData, APContext) > 0 then
    MemSwap(APSmallerData, APBiggerData, ASize);
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

  B := (ColorValue and $00FF0000) shr 16;
  G := (ColorValue and $0000FF00) shr 8;
  R := ColorValue and $000000FF;
  Result := IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
end;

// 其他函数保持不变
function IsXDigit(AChar: Char): Boolean;
begin
  Result := CharInSet(AChar, ['0'..'9', 'A'..'F']);
end;

// 功能：检查一个字符串是否完全由十六进制字符组成（'0'-'9' 或 'A'-'F'）。
// 参数：
//   - const AStr: string      需要检查的字符串。
// 返回值：
//   - Boolean                  如果 AStr 的所有字符都是十六进制字符，则返回 True；否则返回 False。
function IsAllCharFitHex(const AStr: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AStr) do
  begin
    if not CharInSet(AStr[i], ['0'..'9', 'A'..'F']) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;


// 功能：将 RRGGBB（红红绿绿蓝蓝）格式的十六进制字符串转换为 TColor 类型的颜色值。
// 参数：
//   - AStr: string               输入的 RRGGBB 格式的十六进制字符串。
//   - ADefaultColor: LongWord = $00FFFFFF  如果转换失败使用的默认值
// 返回值：
//   - TColor                     转换后的颜色值。如果输入无效（如非空白字符长度不为6，有非16进制字符等），则返回一个默认值ADefaultColor。
function RRGGBBStrToColor(AStr: string; ADefaultColor: LongWord = $00FFFFFF): TColor;
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
function CheckInRange(AInput, AMin, AMax: Integer; ADefaultValue: Integer = -1): Integer;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

// 其他类型的重载，内容与 Integer 版本相同，只是类型不同
function CheckInRange(AInput, AMin, AMax: Int64; ADefaultValue: Int64 = -1): Int64; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Single; ADefaultValue: Single = -1): Single; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Double; ADefaultValue: Double = -1): Double; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Extended; ADefaultValue: Extended = -1): Extended; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: NativeInt; ADefaultValue: NativeInt = 0): NativeInt; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: NativeUInt; ADefaultValue: NativeUInt = 0): NativeUInt; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: UInt64; ADefaultValue: UInt64 = 0): UInt64; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Char; ADefaultValue: Char = #0): Char; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Cardinal; ADefaultValue: Cardinal = 0): Cardinal; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Byte; ADefaultValue: Byte = 0): Byte; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

function CheckInRange(AInput, AMin, AMax: Word; ADefaultValue: Word = 0): Word; overload;
begin
  Result := IfThen((AInput < AMin) or (AInput > AMax), ADefaultValue, AInput);
end;

// 功能：调整输入的左右端点，确保左端点不大于右端点，并且在合法的范围内
// 参数：
//   - ALeftpoint: Integer              待调整的左端点 (引用传递，会直接修改原值)
//   - ARightPoint: Integer             待调整的右端点 (引用传递，会直接修改原值)
//   - LegalLeftPoint: Integer          合法的左端点最小值
//   - LegalRightPoint: Integer         合法的右端点最大值
procedure AdjustRange(var ALeftpoint: Integer; var ARightPoint: Integer; LegalLeftPoint, LegalRightPoint: Integer);
begin
  if ALeftpoint > ARightPoint then
    MemSwap(@ALeftpoint, @ARightPoint, SIZEOFINTEGER);

  if LegalLeftPoint > LegalRightPoint then
    MemSwap(@LegalLeftPoint, @LegalRightPoint, SIZEOFINTEGER);

  if ALeftpoint > LegalRightPoint then
    raise EInvalidArgument.CreateResFmt(@sParamOutOfRangeInclusive, ['ALeftpoint', ALeftpoint, LegalLeftPoint, LegalRightPoint]);

  ALeftpoint := Max(ALeftpoint, LegalLeftPoint);

  ARightPoint := Min(ARightPoint, LegalRightPoint);
end;

end.

