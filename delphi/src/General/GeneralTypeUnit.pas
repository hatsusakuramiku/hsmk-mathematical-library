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

{ Require Version >= Delphi XE4 (Delphi 10.0) }

unit GeneralTypeUnit;

interface

/// <summary>
/// Common type definitions and constants for the library.
/// </summary>
type
  /// <summary>
  /// Dynamic array of Integer.
  /// </summary>
  TIntegerArray = TArray<Integer>;

  /// <summary>
  /// Dynamic array of string.
  /// </summary>
  TStringArray = TArray<string>;

  /// <summary>
  /// Dynamic array of Extended (high-precision floating point).
  /// </summary>
  TExtendedArray = TArray<Extended>;

  /// <summary>
  /// Dynamic array of Cardinal (unsigned 32-bit integer).
  /// </summary>
  TCardinalArray = TArray<Cardinal>;

  /// <summary>
  /// Dynamic array of Int64 (signed 64-bit integer).
  /// </summary>
  TInt64Array = TArray<Int64>;

  /// <summary>
  /// Dynamic array of Pointer.
  /// </summary>
  TPointerArray = TArray<Pointer>;

  /// <summary>
  /// Dynamic array of TObject.
  /// </summary>
  TObjectArray = TArray<TObject>;

  /// <summary>
  /// Size type equivalent to NativeUInt.
  /// </summary>
  TSize_T = NativeUInt;

  /// <summary>
  /// Pointer to TSize_T.
  /// </summary>
  PTSize_T = ^TSize_T;

const
  /// <summary>
  /// Size of Char type in bytes.
  /// </summary>
  SIZEOFCHAR = SizeOf(Char);

  /// <summary>
  /// Size of Integer type in bytes.
  /// </summary>
  SIZEOFINTEGER = SizeOf(Integer);

  /// <summary>
  /// Size of Extended type in bytes.
  /// </summary>
  SIZEOFEXTENDED = SizeOf(Extended);

  /// <summary>
  /// Size of NativeUInt type in bytes.
  /// </summary>
  SIZEOFNATIVEUINT = SizeOf(NativeUInt);

  /// <summary>
  /// Size of Int64 type in bytes.
  /// </summary>
  SIZEOFINT64 = SizeOf(Int64);

  /// <summary>
  /// Size of TSize_T type in bytes.
  /// </summary>
  SIZEOFTSIZE_T = SizeOf(NativeUInt);

  /// <summary>
  /// Default text splitter character (255 in ANSI).
  /// </summary>
  DEFAULTTEXTSPLITTER: string = AnsiChar(255);

implementation

end.