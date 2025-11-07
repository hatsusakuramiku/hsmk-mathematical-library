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

unit ArrayHelperUnit;

interface

uses
  System.Classes, System.SysUtils, System.RTLConsts,
  System.Generics.Defaults, System.Generics.Collections, GeneralTypeUnit;

type
  TCallBackProc<T> = reference to procedure(AValue: T);
  TCallBackFunc<T> = reference to function(AValue: T): T;

  TArrayHelper = class helper for TArray
    class procedure ForEach<T>(AValueArray: array of T; AProc: TCallBackProc<T>); overload;
    class procedure ForEach<T>(var AValueArray: array of T; AFunc: TCallBackFunc<T>); overload;
    class procedure Append<T>(var AValueArray: array of T; AValue: T);
    class procedure Add<T>(var AValueArray: array of T; AValue: T);
    class procedure Delete<T>(var AValueArray: array of T; AIndex: Integer);
    class procedure Insert<T>(var AValueArray: array of T; AValue: T; AIndex: Integer);
    class procedure Reverse<T>(var AValueArray: array of T);
  end;

function InRange(const AValue, AMin, AMax: Integer): Boolean;

implementation

uses
  FuncToolPublicUnit;

{ TArrayHelper }

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

class procedure TArrayHelper.Add<T>(var AValueArray: array of T; AValue: T);
begin
  Append(AValueArray, AValue);
end;

class procedure TArrayHelper.Append<T>(var AValueArray: array of T; AValue: T);
begin
  SetLength(AValueArray, Length(AValueArray) + 1);
  AValueArray[High(AValueArray)] := AValue;
end;

class procedure TArrayHelper.Delete<T>(var AValueArray: array of T;
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
    Move(AValueArray[AIndex + 1], AValueArray[AIndex], (High(AValueArray) - AIndex) * SizeOf(T));
  SetLength(AValueArray, Length(AValueArray) - 1);
end;

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

class procedure TArrayHelper.Insert<T>(var AValueArray: array of T; AValue: T;
  AIndex: Integer);
var
  i: Integer;
begin

  if not InRange(AIndex, Low(AValueArray), High(AValueArray)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);

  SetLength(AValueArray, Length(AValueArray) + 1);

  if AIndex < High(AValueArray) then
    Move(AValueArray[AIndex], AValueArray[AIndex + 1], (High(AValueArray) - AIndex) * SizeOf(T));

  AValueArray[AIndex] := AValue;
end;

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

function InRange(const AValue, AMin, AMax: Integer): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

end.

