# Delphi Mathematical Library

A Delphi (Pascal) mathematical library providing generic sorting algorithms, array operations, and utility functions.

## Requirements

- **Delphi XE4** or higher (Delphi 10.0+)
- Platform support: Windows, macOS, Linux (via FMX or PurePascal)

## Project Structure

```
delphi/
├── src/
│   ├── General/           # Core utilities
│   │   ├── ExceptionStrConstsUnit.pas  # Exception message constants
│   │   ├── GeneralTypeUnit.pas         # Common type definitions
│   │   ├── MemoryUtils.pas             # Memory operation utilities
│   │   └── RTTIMethodUtilsUnit.pas      # RTTI dynamic method utilities
│   ├── Array/             # Array operations
│   │   └── ArrayHelperUnit.pas          # TArrayHelper generic class
│   └── Sort/              # Sorting algorithms
│       ├── SortFunctionToolUnit.pas     # Generic sorting with IDataAccessor
│       └── CLikeFunctionToolsUnit.pas    # C-like pointer-based sorting
└── delphi.gitignore       # Git ignore rules
```

## Modules

### General Types (`GeneralTypeUnit`)

Common type definitions and constants.

```pascal
uses
  GeneralTypeUnit;

var
  IntArray: TIntegerArray;
  StrArray: TStringArray;
  ExtArray: TExtendedArray;
```

**Types:**
- `TIntegerArray` - Dynamic array of Integer
- `TStringArray` - Dynamic array of string
- `TExtendedArray` - Dynamic array of Extended
- `TCardinalArray` - Dynamic array of Cardinal
- `TInt64Array` - Dynamic array of Int64
- `TPointerArray` - Dynamic array of Pointer
- `TObjectArray` - Dynamic array of TObject

**Constants:**
- `SIZEOFCHAR`, `SIZEOFINTEGER`, `SIZEOFEXTENDED`, `SIZEOFINT64`, etc.

### Array Helper (`ArrayHelperUnit`)

Generic helper class for TArray with common operations.

```pascal
uses
  ArrayHelperUnit, System.Generics.Defaults;

var
  Arr: TArray<Integer>;
begin
  // Append/Add elements
  TArrayHelper.Append<Integer>(Arr, 10);
  TArrayHelper.Add<Integer>(Arr, 20);

  // Iterate with callback
  TArrayHelper.ForEach<Integer>(Arr, procedure(AValue: Integer)
  begin
    WriteLn(AValue);
  end);

  // Transform in-place
  TArrayHelper.ForEach<Integer>(Arr, function(AValue: Integer): Integer
  begin
    Result := AValue * 2;
  end);

  // Find index
  Idx := TArrayHelper.IndexOf<Integer>(Arr, 10);

  // Delete at index
  TArrayHelper.Delete<Integer>(Arr, 0);

  // Reverse
  TArrayHelper.Reverse<Integer>(Arr);

  // Check membership
  if TArrayHelper.IsMember<Integer>(Arr, 5) then
    WriteLn('Found');
end;
```

**Methods:**
- `ForEach<T>(AValueArray: array of T; AProc: TCallBackProc<T>)` - Iterate and execute callback
- `ForEach<T>(var AValueArray: array of T; AFunc: TCallBackFunc<T>)` - Transform elements in-place
- `Append<T>(var AValueArray: TArray<T>; AValue: T)` - Add element to end
- `Add<T>(var AValueArray: TArray<T>; AValue: T)` - Alias for Append
- `Delete<T>(var AValueArray: TArray<T>; AIndex: Integer)` - Delete at index
- `Insert<T>(var AValueArray: TArray<T>; AValue: T; AIndex: Integer)` - Insert at index
- `Reverse<T>(var AValueArray: array of T)` - Reverse element order
- `IndexOf<T>(AValueArray: array of T; AValue: T): Integer` - Find first index
- `IndexOf<T>(AValueArray: array of T; AValue: T; ACompare: IComparer<T>): Integer` - Find with custom comparer
- `IsMember<T>(AValueArray: array of T; AValue: T): Boolean` - Check if element exists
- `FreeAllItems<T: class>(var AValueArray: array of T)` - Free all object elements
- `BaseUnique<T>(AValueArray: array of T; AEqualityComparer: IEqualityComparer<T>): TArray<T>` - Get unique elements
- `Unique<T>(var AValueArray: TArray<T>; AEqualityComparer: IEqualityComparer<T>)` - Remove duplicates in-place
- `ToString<T>(const AValueArray: array of T; AToStringFunc: TFunc<T, string>; ...): string` - Convert to string
- `DynamicArrayConvert<T>(const AValueArray: array of T): TArray<T>` - Convert open array to dynamic array

### Sorting (`SortFunctionToolUnit`)

Comprehensive generic sorting utilities with two approaches:

#### 1. Direct Array Sorting (with IDataAccessor)

```pascal
uses
  SortFunctionToolUnit, System.Generics.Defaults;

var
  Arr: TArray<Integer>;
  Accessor: TArrayDataAccessor<Integer>;
begin
  Arr := [5, 2, 8, 1, 9, 3];
  Accessor := TArrayDataAccessor<Integer>.Create;

  // Sort entire array (default QuickSort)
  TArraySortUtils.Sort<Integer>(Arr, TComparer<Integer>.Default);

  // Sort with specific algorithm
  TArraySortUtils.QuickSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.MergeSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.HeapSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.InsertionSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.SelectionSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.BubbleSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.ShellSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.IntroSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));
  TArraySortUtils.HybridSort<Integer>(Arr, TComparer<Integer>.Default, 0, Length(Arr));

  // Sort with custom algorithm function
  TArraySortUtils.Sort<Integer>(BubbleSort<Integer>, Arr, TComparer<Integer>.Default);

  // Check if sorted
  if TArraySortUtils.CheckIsSorted<Integer>(Arr, TComparer<Integer>.Default) then
    WriteLn('Sorted');
end;
```

#### 2. Flexible Collection Sorting (via IDataAccessor)

```pascal
uses
  SortFunctionToolUnit, System.Generics.Defaults, System.Classes;

var
  Strings: TStrings;
  Accessor: TStringsDataAccessor;
begin
  Strings := TStringList.Create;
  try
    Strings.Add('zebra');
    Strings.Add('apple');
    Strings.Add('banana');

    Accessor := TStringsDataAccessor.Create;

    // Sort TStrings (or any collection via IDataAccessor)
    TArraySortUtils.Sort<TStrings, string>(Strings, Accessor, TComparer<string>.Default);

    // Or use specific algorithms
    TArraySortUtils.QuickSort<TStrings, string>(Strings, Accessor, TComparer<string>.Default);
  finally
    Strings.Free;
  end;
end;
```

**Available Sort Algorithms:**
| Algorithm | Time Complexity | Space | Stable |
|-----------|----------------|-------|--------|
| BubbleSort | O(n²) | O(1) | Yes |
| SelectionSort | O(n²) | O(1) | No |
| InsertionSort | O(n²) / O(n) best | O(1) | Yes |
| ShellSort | O(n^(3/2)) | O(1) | No |
| QuickSort | O(n log n) / O(n²) worst | O(log n) | No |
| MergeSort | O(n log n) | O(n) | Yes |
| HeapSort | O(n log n) | O(1) | No |
| IntroSort | O(n log n) | O(log n) | No |
| HybridSort | O(n log n) | O(n) / O(1) fallback | Yes |

### C-Style Pointer Sorting (`CLikeFunctionToolsUnit`)

Low-level pointer-based sorting for maximum performance and C interoperability.

```pascal
uses
  CLikeFunctionToolsUnit;

type
  TIntCompare = reference to function(APData1, APData2, APContext: Pointer): Integer;

function IntCompareAsc(APData1, APData2, APContext: Pointer): Integer;
begin
  Result := PInteger(APData1)^ - PInteger(APData2)^;
end;

var
  Arr: array[0..4] of Integer;
  I: Integer;
begin
  Arr := [5, 2, 8, 1, 9];

  // QuickSort
  QuickSort(@Arr[0], 5, SizeOf(Integer), nil, IntCompareAsc);

  // Binary search (array must be sorted)
  I := BinarySearch(@Arr[0], 5, SizeOf(Integer), nil, @Arr[2], IntCompareAsc);
  // I = 2 (index of element with value 8)

  // Sequential search
  I := SequentialSearch(@Arr[0], 5, SizeOf(Integer), nil, @Arr[3], IntCompareAsc);
end;
```

**Pointer Helper Functions:**
- `LeftMovePtr(ApBase: Pointer; AOffset: TSize_T): Pointer` - Move pointer left
- `RightMovePtr(ApBase: Pointer; AOffset: TSize_T): Pointer` - Move pointer right
- `MovePtr(APBase: Pointer; AOffset: NativeInt): Pointer` - Move pointer with signed offset

**Validation Functions:**
- `IsSorted(APBase: Pointer; AElemNum, AElemSize: TSize_T; APContext: Pointer; ACompareFunc: TCompareFunction): Boolean`
- `IsReverseSorted(...)`: Boolean
- `CheckArrayAllElemAreVaild(...)`: Boolean

**Sort Functions:**
- `BubbleSort`, `SelectionSort`, `InsertionSort`, `ShellSort`
- `QuickSort`, `MergeSort`, `HeapSort`, `IntroSort`, `HybridSort`
- `OptimizedSort` - Checks if already sorted before sorting

**Search Functions:**
- `BinarySearch` / `BinarySearchs` - Find element(s) in sorted array
- `SequentialSearch` / `SequentialSearchEx` / `SequentialSearchs` - Linear search

### Memory Utilities (`MemoryUtils`)

```pascal
uses
  MemoryUtils;

var
  Buffer: array[0..9] of Byte;
begin
  // Reverse bytes
  ReverseByte(Buffer, 10);

  // Reverse array elements
  ReverseArray(Buffer, 10, 1);

  // Compare memory
  if MemCompare(@Buffer[0], @Buffer[5], 10) then
    WriteLn('Equal');

  // Swap memory blocks
  MemSwap(@Buffer[0], @Buffer[5], 10);
end;
```

### RTTI Utilities (`RTTIMethodUtilsUnit`)

Dynamic event binding and property manipulation via RTTI.

```pascal
uses
  RTTIMethodUtilsUnit, System.Classes;

type
  TMyButton = class
  private
    FOnClick: TNotifyEvent;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TMyHandler = class
  public
    procedure HandleClick(Sender: TObject);
  end;

procedure TMyHandler.HandleClick(Sender: TObject);
begin
  WriteLn('Clicked!');
end;

var
  Button: TMyButton;
  Handler: TMyHandler;
begin
  Button := TMyButton.Create;
  Handler := TMyHandler.Create;
  try
    // Bind event handler dynamically
    SetObjectEvent(Button, 'OnClick', Handler, 'HandleClick');
  finally
    Button.Free;
    Handler.Free;
  end;
end;
```

**Functions:**
- `CheckMethodMatch(...)`: Boolean - Verify method signature matches event
- `SetObjectEvent(...)` - Bind event handler dynamically
- `SetObjectsBoolProp(...)` - Set Boolean properties on object arrays
- `SetObjectsProp(...)` - Set typed properties on object arrays
- `CallObjectProc(...)`: Boolean - Invoke parameterless public method

### Exception Constants (`ExceptionStrConstsUnit`)

```pascal
uses
  ExceptionStrConstsUnit;

raise Exception.CreateRes(@sParamOutOfRangeInclusive);
// Output: 'Parameter %s out of range (%d).  Must be >= %d and <= %d'
```

## Quick Start

### Installation

1. Add `delphi/src` to your project search path
2. Add required units to your `uses` clause

### Basic Example

```pascal
program Example;

uses
  System.SysUtils, ArrayHelperUnit, SortFunctionToolUnit,
  System.Generics.Defaults;

var
  Numbers: TArray<Integer>;
begin
  // Create and populate array
  SetLength(Numbers, 5);
  Numbers[0] := 5;
  Numbers[1] := 2;
  Numbers[2] := 8;
  Numbers[3] := 1;
  Numbers[4] := 9;

  // Sort with default QuickSort
  TArraySortUtils.Sort<Integer>(Numbers, TComparer<Integer>.Default);

  // Print result
  WriteLn(TArrayHelper.ToString<Integer>(Numbers, IntToStr));
  // Output: [1,2,5,8,9]
end.
```

## Notes

- All modules support **PurePascal** mode for cross-platform compatibility
- FMX framework users can use `MemSwap` without Windows dependencies
- The `{$M+}` compiler directive is required in `RTTIMethodUtilsUnit` for RTTI support