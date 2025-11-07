{********************************************************************************}
{                        Copyright  2025 hatsusakuramiku                         }
{                                                                                }
{  Permission is hereby granted, free of charge, to any person obtaining a copy  }
{  of this software and associated documentation files (the "Software"), to deal }
{  in the Software without restriction, including without limitation the rights  }
{  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     }
{  copies of the Software, and to permit persons to whom the Software is         }
{  furnished to do so, subject to the following conditions:                      }
{                                                                                }
{  The above copyright notice and this permission notice shall be included in all}
{  copies or substantial portions of the Software.                               }
{                                                                                }
{  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    }
{  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      }
{  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   }
{  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        }
{  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, }
{  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE }
{  SOFTWARE.                                                                     }
{********************************************************************************}

{* Require Version >= Delphi XE4 *}
unit GeneralTypeUnit;

interface

type
  {Dynamic Array}
  TIntegerArray = TArray<Integer>; //array of Integer;
  TStringArray = TArray<String>;
  TExtendedArray = TArray<Extended>;
  TCardinalArray = TArray<Cardinal>;
  TInt64Array = TArray<Int64>;
  TPointerArray = TArray<Pointer>;
  TObjectArray = TArray<TObject>;

  {Base Type}
  TSize_T = NativeUInt;
  PTSize_T = ^TSize_T;

const
  SIZEOFCHAR = SizeOf(Char);
  SIZEOFINTEGER = SizeOf(Integer);
  SIZEOFEXTENDED = SizeOf(Extended);
  SIZEOFNATIVEUINT = SizeOf(NativeUInt);
  SIZEOFINT64 = SizeOf(Int64);
  SIZEOFTSIZE_T = SizeOf(NativeUInt);
  DEFAULTTEXTSPLITTER: string = AnsiChar(255);

implementation

end.
