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

unit ArrayHelperUnit;

interface

uses
  System.Classes, System.SysUtils, System.RTLConsts, System.Generics.Defaults,
  System.Generics.Collections;

/// <summary>
/// Generic callback procedure type for processing array elements without return value.
/// </summary>
/// <typeparam name="T">Element type.</typeparam>
/// <param name="AValue">The element being processed.</param>
type
  TCallBackProc<T> = reference to procedure(AValue: T);

/// <summary>
/// Generic callback function type for transforming array elements.
/// </summary>
/// <typeparam name="T">Element type.</typeparam>
/// <param name="AValue">The input element to transform.</param>
/// <returns>The transformed element.</returns>
  TCallBackFunc<T> = reference function(AValue: T): T;

/// <summary>
/// Helper class extending TArray with common array manipulation operations.
/// </summary>
  TArrayHelper = class helper for TArray
  public
    /// <summary>
    /// Iterates through each element and executes the callback procedure.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to iterate.</param>
    /// <param name="AProc">Callback procedure to execute on each element.</param>
    class procedure ForEach<T>(AValueArray: array of T; AProc: TCallBackProc<T>); overload;

    /// <summary>
    /// Iterates through each element, applies the transform function, and replaces the element.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to iterate (var, will be modified).</param>
    /// <param name="AFunc">Transform function to apply to each element.</param>
    class procedure ForEach<T>(var AValueArray: array of T; AFunc: TCallBackFunc<T>); overload;

    /// <summary>
    /// Appends an element to the end of a dynamic array.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The dynamic array to append to (var).</param>
    /// <param name="AValue">The element to append.</param>
    class procedure Append<T>(var AValueArray: TArray<T>; AValue: T);

    /// <summary>
    /// Adds an element to the end of a dynamic array (alias for Append).
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The dynamic array to add to (var).</param>
    /// <param name="AValue">The element to add.</param>
    class procedure Add<T>(var AValueArray: TArray<T>; AValue: T);

    /// <summary>
    /// Deletes the element at the specified index.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The dynamic array to delete from (var).</param>
    /// <param name="AIndex">Index of element to delete (0-based).</param>
    /// <remarks>
    /// If array is empty, sets length to 0 and returns.
    /// If AIndex is outside valid range [Low, High], raises EArgumentOutOfRangeException.
    /// Elements after AIndex are shifted left.
    /// </remarks>
    class procedure Delete<T>(var AValueArray: TArray<T>; AIndex: Integer);

    /// <summary>
    /// Inserts an element at the specified index.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The dynamic array to insert into (var).</param>
    /// <param name="AValue">Element to insert.</param>
    /// <param name="AIndex">Index to insert at (0-based). Valid range: [Low, High+1].</param>
    /// <remarks>
    /// If AIndex is outside valid range, raises EArgumentOutOfRangeException.
    /// Elements from AIndex onward are shifted right.
    /// </remarks>
    class procedure Insert<T>(var AValueArray: TArray<T>; AValue: T; AIndex: Integer);

    /// <summary>
    /// Reverses the order of elements in the array.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to reverse (var).</param>
    class procedure Reverse<T>(var AValueArray: array of T);

    /// <summary>
    /// Finds the first index of a matching element using default comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to search.</param>
    /// <param name="AValue">Element to find.</param>
    /// <returns>Index of first match, or -1 if not found.</returns>
    class function IndexOf<T>(AValueArray: array of T; AValue: T): Integer; overload;

    /// <summary>
    /// Finds the first index of a matching element using custom comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to search.</param>
    /// <param name="AValue">Element to find.</param>
    /// <param name="ACompare">Custom comparer function.</param>
    /// <returns>Index of first match, or -1 if not found.</returns>
    class function IndexOf<T>(AValueArray: array of T; AValue: T; ACompare: IComparer<T>): Integer; overload;

    /// <summary>
    /// Checks if an element exists in the array using custom comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to search.</param>
    /// <param name="AValue">Element to find.</param>
    /// <param name="ACompare">Custom comparer function.</param>
    /// <returns>True if element is found.</returns>
    class function IsMember<T>(AValueArray: array of T; AValue: T; ACompare: IComparer<T>): Boolean; overload;

    /// <summary>
    /// Checks if an element exists in the array using default comparer.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to search.</param>
    /// <param name="AValue">Element to find.</param>
    /// <returns>True if element is found.</returns>
    class function IsMember<T>(AValueArray: array of T; AValue: T): Boolean; overload;

    /// <summary>
    /// Frees all object elements in the array (from end to beginning).
    /// </summary>
    /// <typeparam name="T">Must be a class type.</typeparam>
    /// <param name="AValueArray">The array of objects to free (var).</param>
    class procedure FreeAllItems<T: class>(var AValueArray: array of T);

    /// <summary>
    /// Returns a new array with duplicate elements removed.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The source array.</param>
    /// <param name="AEqualityComparer">Comparer for determining uniqueness.</param>
    /// <returns>New array with unique elements.</returns>
    class function BaseUnique<T>(AValueArray: array of T; const AEqualityComparer: IEqualityComparer<T>): TArray<T>;

    /// <summary>
    /// Removes duplicate elements from the array in-place.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to deduplicate (var).</param>
    /// <param name="AEqualityComparer">Comparer for determining uniqueness.</param>
    class procedure Unique<T>(var AValueArray: TArray<T>; const AEqualityComparer: IEqualityComparer<T>);

    /// <summary>
    /// Converts the array to a string representation.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The array to convert.</param>
    /// <param name="AToStringFunc">Function to convert each element to string.</param>
    /// <param name="APrefix">String prefix (default '[').</param>
    /// <param name="Splitter">Element separator (default ',').</param>
    /// <param name="Suffix">String suffix (default ']').</param>
    /// <param name="AIgnoreSpace">Not used (保留参数 for compatibility).</param>
    /// <returns>String representation like '[elem1,elem2,elem3]'.</returns>
    class function ToString<T>(const AValueArray: array of T; AToStringFunc: TFunc<T, string>;
      const APrefix: string = '['; const Splitter: string = ','; const Suffix: string = ']'; AIgnoreSpace: Boolean = True): string;

    /// <summary>
    /// Converts an open array to a dynamic array.
    /// </summary>
    /// <typeparam name="T">Element type.</typeparam>
    /// <param name="AValueArray">The source open array.</param>
    /// <returns>New TArray<T> with same contents.</returns>
    class function DynamicArrayConvert<T>(const AValueArray: array of T): TArray<T>;
  end;

/// <summary>
/// Checks if a value is within a specified range.
/// </summary>
/// <param name="AValue">Value to check.</param>
/// <param name="AMin">Minimum value of range.</param>
/// <param name="AMax">Maximum value of range.</param>
/// <param name="AIsIncludeBound">
///   <para>
///     - True: Inclusive range [AMin, AMax]
///   </para>
///   <para>
///     - False: Exclusive range (AMin, AMax)
///   </para>
/// </param>
/// <returns>True if AValue is within the range.</returns>
function InRange(const AValue, AMin, AMax: Integer; AIsIncludeBound: Boolean = True): Boolean;

implementation

uses
  System.TypInfo, System.StrUtils;

{ TArrayHelper }

class procedure TArrayHelper.ForEach<T>(AValueArray: array of T; AProc: TCallBackProc<T>);
var
  i: Integer;
begin
  for i := Low(AValueArray) to High(AValueArray) do
  begin
    AProc(AValueArray[i]);
  end;
end;

class procedure TArrayHelper.Add<T>(var AValueArray: TArray<T>; AValue: T);
begin
  Append<T>(AValueArray, AValue);
end;

class procedure TArrayHelper.Append<T>(var AValueArray: TArray<T>; AValue: T);
begin
  SetLength(AValueArray, Length(AValueArray) + 1);
  AValueArray[High(AValueArray)] := AValue;
end;

class procedure TArrayHelper.Delete<T>(var AValueArray: TArray<T>; AIndex: Integer);
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
    Move(AValueArray[AIndex + 1], AValueArray[AIndex], (High(AValueArray) - AIndex) * SizeOf(T));
  end;

  SetLength(AValueArray, Length(AValueArray) - 1);
end;

class function TArrayHelper.DynamicArrayConvert<T>(const AValueArray: array of T): TArray<T>;
var
  i: Integer;
begin
  SetLength(Result, Length(AValueArray));
  for i := 0 to Length(AValueArray) - 1 do
    Result[i] := AValueArray[i];
end;

class procedure TArrayHelper.ForEach<T>(var AValueArray: array of T; AFunc: TCallBackFunc<T>);
var
  i: Integer;
begin
  for i := Low(AValueArray) to High(AValueArray) do
  begin
    AValueArray[i] := AFunc(AValueArray[i]);
  end;
end;

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

class function TArrayHelper.IndexOf<T>(AValueArray: array of T; AValue: T): Integer;
begin
  Result := IndexOf<T>(AValueArray, AValue, TComparer<T>.Default);
end;

class function TArrayHelper.IndexOf<T>(AValueArray: array of T; AValue: T; ACompare: IComparer<T>): Integer;
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

class procedure TArrayHelper.Insert<T>(var AValueArray: TArray<T>; AValue: T; AIndex: Integer);
begin
  if not InRange(AIndex, Low(AValueArray), High(AValueArray) + 1) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);

  SetLength(AValueArray, Length(AValueArray) + 1);

  if AIndex < High(AValueArray) then
    Move(AValueArray[AIndex], AValueArray[AIndex + 1], (High(AValueArray) - AIndex) * SizeOf(T));

  AValueArray[AIndex] := AValue;
end;

class function TArrayHelper.IsMember<T>(AValueArray: array of T; AValue: T; ACompare: IComparer<T>): Boolean;
begin
  Result := IndexOf<T>(AValueArray, AValue, ACompare) >= 0;
end;

class function TArrayHelper.IsMember<T>(AValueArray: array of T; AValue: T): Boolean;
begin
  Result := IsMember<T>(AValueArray, AValue, TComparer<T>.Default);
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

class function TArrayHelper.ToString<T>(const AValueArray: array of T; AToStringFunc: TFunc<T, string>;
  const APrefix: string = '['; const Splitter: string = ','; const Suffix: string = ']'; AIgnoreSpace: Boolean = True): string;
var
  Value: T;
  LList: TList<string>;
begin
  LList := TList<string>.Create;
  try
    if not Assigned(AToStringFunc) then
      raise Exception.Create('AToStringFunc Not Assigned!');

    for Value in AValueArray do
      LList.Add(AToStringFunc(Value));

    Result := APrefix + string.Join(Splitter, LList.ToArray) + Suffix;
  finally
    LList.Free;
  end;
end;

class procedure TArrayHelper.Unique<T>(var AValueArray: TArray<T>; const AEqualityComparer: IEqualityComparer<T>);
begin
  AValueArray := BaseUnique<T>(AValueArray, AEqualityComparer);
end;

class function TArrayHelper.BaseUnique<T>(AValueArray: array of T; const AEqualityComparer: IEqualityComparer<T>): TArray<T>;
var
  LDictionary: TDictionary<T, Boolean>;
  TempList: TList<T>;
  i, iLen: Integer;
  Temp: T;
begin
  iLen := Length(AValueArray);
  if iLen <= 1 then
  begin
    SetLength(Result, iLen);
    if iLen > 0 then
      Result[0] := AValueArray[Low(AValueArray)];
    Exit;
  end;

  LDictionary := TDictionary<T, Boolean>.Create(AEqualityComparer);
  TempList := TList<T>.Create;
  try
    for i := Low(AValueArray) to High(AValueArray) do
    begin
      Temp := AValueArray[i];
      if not LDictionary.ContainsKey(Temp) then
      begin
        LDictionary.Add(Temp, True);
        TempList.Add(Temp);
      end;
    end;
    Result := TempList.ToArray;
  finally
    TempList.Free;
    FreeAndNil(LDictionary);
  end;
end;

function InRange(const AValue, AMin, AMax: Integer; AIsIncludeBound: Boolean = True): Boolean;
begin
  if AIsIncludeBound then
    Result := (AValue >= AMin) and (AValue <= AMax)
  else
    Result := (AValue > AMin) and (AValue < AMax);
end;

end.