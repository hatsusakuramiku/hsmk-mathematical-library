{用于预定义一些类型，后续遇到此处已定义的类型直接引用即可而无需再定义}
unit GeneralTypeUnit;

interface

uses
  Winapi.Windows;

type
  {Dynamic Array}
  TIntegerArray = TArray<Integer>; //array of Integer;
  TStringArray = TArray<String>;
  TExtendedArray = TArray<Extended>;
  TCardinalArray = TArray<Cardinal>;
  TInt64Array = TArray<Int64>;
  TPointerArray = TArray<Pointer>;
  TObjectArray = TArray<TObject>;
  TSize_T = NativeUInt;
  PTSize_T = ^TSize_T;

const
  SIZEOFCHAR = SizeOf(Char);
  SIZEOFINTEGER = SizeOf(Integer);
  SIZEOFEXTENDED = SizeOf(Extended);
  SIZEOFNATIVEUINT = SizeOf(NativeUInt);
  SIZEOFTSIZE_T = SIZEOFNATIVEUINT;

implementation

end.
