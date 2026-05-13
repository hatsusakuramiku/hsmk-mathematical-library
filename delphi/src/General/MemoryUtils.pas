{******************************************************************************}
{                       Copyright 2025 hatsusakuramiku                         }
{                                                                              }
{                              MIT LICENSE                                     }
{ Permission is hereby granted, free of charge, to any person obtaining a copy }
{ of this software and associated documentation files (the "Software"), to deal }
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
{ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE }
{ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN   }
{ THE SOFTWARE.                                                                }
{******************************************************************************}

{ Require Version >= Delphi XE4 (Delphi 10.0) }

unit MemoryUtils;

interface

uses
  System.SysUtils;

/// <summary>
/// Reverses the byte order in a buffer.
/// </summary>
/// <param name="Buffer">The buffer to reverse.</param>
/// <param name="Count">Number of bytes to reverse.</param>
procedure ReverseByte(var Buffer; Count: NativeUInt);

/// <summary>
/// Reverses the order of elements in a buffer.
/// </summary>
/// <param name="Buffer">The buffer containing elements to reverse.</param>
/// <param name="Count">Number of elements.</param>
/// <param name="ItemSize">Size of each element in bytes.</param>
/// <remarks>
/// Swaps elements from both ends toward the center.
/// Supports arbitrary element sizes. Does not work with managed types (String, Interface, etc.).
/// </remarks>
procedure ReverseArray(var Buffer; Count: NativeUInt; ItemSize: NativeUInt);

/// <summary>
/// Compares two memory blocks byte by byte.
/// </summary>
/// <param name="APData1">Pointer to the first memory block.</param>
/// <param name="APData2">Pointer to the second memory block.</param>
/// <param name="ASize">Number of bytes to compare.</param>
/// <returns>True if the memory blocks are identical, False otherwise.</returns>
function MemCompare(const APData1, APData2: Pointer; const ASize: NativeUInt): Boolean;

/// <summary>
/// Swaps two memory blocks using a temporary buffer allocated internally.
/// </summary>
/// <param name="APData1">Pointer to the first memory block.</param>
/// <param name="APData2">Pointer to the second memory block.</param>
/// <param name="ASize">Size in bytes to swap.</param>
procedure MemSwap(const APData1, APData2: Pointer; const ASize: NativeUInt); overload; inline;

/// <summary>
/// Swaps two memory blocks using a caller-provided temporary buffer.
/// </summary>
/// <param name="AData1">Pointer to the first memory block.</param>
/// <param name="AData2">Pointer to the second memory block.</param>
/// <param name="ASwapBuffer">Pointer to a temporary buffer of at least ASize bytes.</param>
/// <param name="ASize">Size in bytes to swap.</param>
procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: NativeUInt); overload; inline;

implementation

procedure ReverseByte(var Buffer; Count: NativeUInt);
{$IFDEF CPUX86}
asm
        PUSH    ESI
        PUSH    EDI

        MOV     ESI, EAX
        MOV     ECX, EDX
        MOV     EDI, ESI
        ADD     EDI, ECX
        DEC     EDI

        SHR     ECX, 1
@Loop:
        TEST    ECX, ECX
        JZ      @Done

        MOV     AL, [ESI]
        MOV     DL, [EDI]
        MOV     [ESI], DL
        MOV     [EDI], AL

        INC     ESI
        DEC     EDI
        DEC     ECX
        JMP     @Loop

@Done:
        POP     EDI
        POP     ESI
end;
{$ELSE}
{$POINTERMATH ON}
var
  PStart, PEnd: PByte;
  HalfCount: NativeUInt;
  Temp: Byte;
begin
  PStart := @Buffer;
  PEnd := PByte(@Buffer) + Count - 1;
  HalfCount := Count shr 1;
  while HalfCount > 0 do
  begin
    Temp := PStart[0];
    PStart[0] := PEnd[0];
    PEnd[0] := Temp;
    Inc(PStart);
    Dec(PEnd);
    Dec(HalfCount);
  end;
end;
{$POINTERMATH OFF}
{$ENDIF}

procedure ReverseArray(var Buffer; Count: NativeUInt; ItemSize: NativeUInt);
{$POINTERMATH ON}
var
  PStart, PEnd: PByte;
  I: NativeUInt;
  Temp: Pointer;
begin
  if (Count < 2) or (ItemSize = 0) then
    Exit;

  PStart := @Buffer;
  PEnd := PByte(@Buffer) + (Count - 1) * ItemSize;
  Temp := AllocMem(ItemSize);
  try
    for I := 0 to (Count shr 1) - 1 do
    begin
      Move(PStart^, Temp^, ItemSize);
      Move(PEnd^, PStart^, ItemSize);
      Move(Temp^, PEnd^, ItemSize);
      Inc(PStart, ItemSize);
      Dec(PEnd, ItemSize);
    end;
  finally
    FreeMem(Temp);
  end;
end;
{$POINTERMATH OFF}

function MemCompare(const APData1, APData2: Pointer; const ASize: NativeUInt): Boolean;
begin
  Result := CompareMem(APData1, APData2, ASize);
end;

procedure MemSwap(const APData1, APData2: Pointer; const ASize: NativeUInt); overload;
var
  pTemp: Pointer;
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

procedure MemSwap(const AData1, AData2, ASwapBuffer: Pointer; ASize: NativeUInt); overload;
{$IF defined(PUREPASCAL) OR defined(FMX)}
{$POINTERMATH ON}
var
  Source1Ptr, Source2Ptr, SwapBufferPtr: PByte;
  ByteOffset: NativeUInt;
  TempNativeInt, NativeIntSize: NativeUInt;
begin
  if ASize = 0 then
    Exit;

  Source1Ptr := PByte(AData1);
  Source2Ptr := PByte(AData2);
  SwapBufferPtr := PByte(ASwapBuffer);
  NativeIntSize := SizeOf(NativeUInt);

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
      for ByteOffset := 0 to ASize - 1 do
      begin
        SwapBufferPtr[ByteOffset] := Source1Ptr[ByteOffset];
        Source1Ptr[ByteOffset] := Source2Ptr[ByteOffset];
        Source2Ptr[ByteOffset] := SwapBufferPtr[ByteOffset];
      end;
    end
  else
  begin
    ByteOffset := 0;
    while ByteOffset + NativeIntSize <= ASize do
    begin
      TempNativeInt := PNativeInt(Source1Ptr + ByteOffset)^;
      PNativeInt(Source1Ptr + ByteOffset)^ := PNativeInt(Source2Ptr + ByteOffset)^;
      PNativeInt(Source2Ptr + ByteOffset)^ := TempNativeInt;
      Inc(ByteOffset, NativeIntSize);
    end;

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

end.