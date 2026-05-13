{******************************************************************************}
{                       Copyright 2026 hatsusakuramiku                         }
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
{ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      }
{ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,}
{ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN   }
{ THE SOFTWARE.                                                                }
{******************************************************************************}

{ Require Version >= Delphi XE4 (Delphi 10.0) }

unit RTTIMethodUtilsUnit;

{$O+}
{$M+}

interface

uses
  System.SysUtils, System.Variants, System.Generics.Defaults, System.Classes,
  System.UITypes, System.Generics.Collections;

/// <summary>
/// Checks if the method signature of a source handler matches the target event property.
/// </summary>
/// <param name="ADestInstance">The target object instance.</param>
/// <param name="AEventName">The target event name.</param>
/// <param name="ASourceHandler">The source handler object containing the method.</param>
/// <param name="AHandlerMethodName">The name of the source handler method.</param>
/// <param name="ErrorMsg">Output parameter that receives the error message if validation fails.</param>
/// <returns>
///   True if method signatures match and binding is possible;
///   False otherwise, with ErrorMsg describing the failure reason.
/// </returns>
function CheckMethodMatch(const ADestInstance: TObject; const AEventName: string; const ASourceHandler: TObject; const AHandlerMethodName: string; out ErrorMsg: string): Boolean;

/// <summary>
/// Dynamically binds an event handler to a published event property of any TObject instance using RTTI.
/// </summary>
/// <param name="ADestInstance">The target object instance to bind the event to.</param>
/// <param name="AEventName">The event property name (e.g., 'OnClick' or 'OnKeyUp'), case-insensitive.</param>
/// <param name="ASourceHandler">The object instance that owns the handler method.</param>
/// <param name="AHandlerMethodName">The name of the handler method.</param>
/// <param name="ACover">
///   [Optional, defaults to False] Indicates whether to overwrite an existing event handler.
///   - True: Force overwrite regardless of existing handler
///   - False: Only bind if no handler currently exists
/// </param>
/// <remarks>
/// WARNING: The caller MUST ensure the HandlerMethod signature strictly matches the target event's required signature.
/// RTTI cannot verify signature compatibility at compile-time or runtime. Signature mismatch will cause program crash (Access Violation).
/// </remarks>
procedure SetObjectEvent(const ADestInstance: TObject; const AEventName: string; const ASourceHandler: TObject; const AHandlerMethodName: string; ACover: Boolean = False);

/// <summary>
/// Safely sets a Boolean property value on an array of objects by property name.
/// </summary>
/// <param name="AObjects">The array of target object instances (nil objects or those without the property are skipped automatically).</param>
/// <param name="APropertyName">The property name to set (case-sensitive, e.g., 'Enabled' or 'Visible').</param>
/// <param name="AFlag">[Optional, defaults to True] The new Boolean value to assign.</param>
procedure SetObjectsBoolProp(const AObjects: array of TObject; const APropertyName: string; const AFlag: Boolean = True); overload;

/// <summary>
/// Safely sets multiple Boolean property values on an array of objects by property names.
/// </summary>
/// <param name="AObjects">The array of target object instances.</param>
/// <param name="APropertyNames">The array of property names to set (e.g., ['Enabled', 'Visible']).</param>
/// <param name="AFlag">[Optional, defaults to True] The new Boolean value to assign to all properties.</param>
procedure SetObjectsBoolProp(const AObjects: array of TObject; const APropertyNames: array of string; const AFlag: Boolean = True); overload;

/// <summary>
/// Safely sets a typed property value on an array of objects using RTTI.
/// </summary>
/// <param name="AObjects">The array of target object instances.</param>
/// <param name="APropertyName">The target property name.</param>
/// <param name="PropInfo">
///   The expected property type info pointer, typically obtained via TypeInfo() (e.g., TypeInfo(Integer) or TypeInfo(String)).
///   Used for strict memory and type compatibility validation before assignment.
/// </param>
/// <param name="PropValue">The new value to assign (passed as Variant for compatibility with various underlying data types).</param>
procedure SetObjectsProp(const AObjects: array of TObject; const APropertyName: string; const PropInfo: Pointer; const PropValue: Variant); overload;

/// <summary>
/// Safely sets multiple typed property values on an array of objects using RTTI.
/// </summary>
/// <param name="AObjects">The array of target object instances.</param>
/// <param name="APropertyNames">The array of target property names.</param>
/// <param name="PropInfo">
///   The expected type info pointer, typically obtained via TypeInfo().
///   Used to intercept incompatible type assignments and ensure memory safety.
/// </param>
/// <param name="PropValue">The new value to assign to all properties.</param>
/// <remarks>
/// Core low-level method. If a property on an object is incompatible with PropInfo during iteration,
/// that property assignment is safely skipped without raising an exception.
/// </remarks>
procedure SetObjectsProp(const AObjects: array of TObject; const APropertyNames: array of string; const PropInfo: Pointer; const PropValue: Variant); overload;

/// <summary>
/// Detects and invokes a parameterless public method on an object.
/// </summary>
/// <param name="Aobj">The object instance on which to invoke the method.</param>
/// <param name="AProcName">The method name to invoke.</param>
/// <returns>
///   True if the method was found and executed successfully;
///   False if the object is nil, method not found, not public, or has parameters.
/// </returns>
/// <remarks>
/// Only invokes parameterless public methods. Private and protected methods are ignored.
/// </remarks>
function CallObjectProc(const Aobj: TObject; const AProcName: string): Boolean;

implementation

uses
  System.Math, System.RTLConsts, System.TypInfo, System.Rtti;

function CheckMethodMatch(const ADestInstance: TObject; const AEventName: string; const ASourceHandler: TObject; const AHandlerMethodName: string; out ErrorMsg: string): Boolean;
var
  Ctx: TRttiContext;
  SourceType, DestType: TRttiType;
  SourceMethod: TRttiMethod;
  DestProp: TRttiProperty;
  DestEvent: TRttiInvokableType;
  SrcParams, DestParams: TArray<TRttiParameter>;
  I: Integer;
begin
  Result := False;
  ErrorMsg := '';

  Ctx := TRttiContext.Create;
  try
    SourceType := Ctx.GetType(ASourceHandler.ClassType);
    SourceMethod := SourceType.GetMethod(AHandlerMethodName);
    if not Assigned(SourceMethod) then
    begin
      ErrorMsg := Format(SMethodNotFound, [AHandlerMethodName, ASourceHandler.ClassName]);
      Exit;
    end;

    DestType := Ctx.GetType(ADestInstance.ClassType);
    DestProp := DestType.GetProperty(AEventName);
    if not Assigned(DestProp) then
    begin
      ErrorMsg := Format(SUnknownProperty, [AEventName]);
      Exit;
    end;

    if not DestProp.IsWritable then
    begin
      ErrorMsg := SReadOnlyProperty;
      Exit;
    end;

    if not (DestProp.Visibility in [mvPublic, mvPublished]) then
    begin
      ErrorMsg := Format(SInvalidPropertyElement, [AEventName]);
      Exit;
    end;

    if DestProp.PropertyType.TypeKind <> tkMethod then
    begin
      ErrorMsg := Format(SInvalidPropertyType, [DestProp.PropertyType.Name]);
      Exit;
    end;

    DestEvent := DestProp.PropertyType as TRttiInvokableType;

    if (SourceMethod.ReturnType <> nil) and (DestEvent.ReturnType <> nil) then
    begin
      if SourceMethod.ReturnType.Handle <> DestEvent.ReturnType.Handle then
      begin
        ErrorMsg := STypeMisMatch;
        Exit;
      end;
    end
    else if (SourceMethod.ReturnType <> nil) or (DestEvent.ReturnType <> nil) then
    begin
      ErrorMsg := STypeMisMatch;
      Exit;
    end;

    SrcParams := SourceMethod.GetParameters;
    DestParams := DestEvent.GetParameters;

    if Length(SrcParams) <> Length(DestParams) then
    begin
      ErrorMsg := SParameterCountMismatch;
      Exit;
    end;

    for I := 0 to High(SrcParams) do
    begin
      if (SrcParams[I].ParamType.Handle <> DestParams[I].ParamType.Handle) or
         (SrcParams[I].Flags * [pfVar, pfConst, pfOut, pfArray] <> DestParams[I].Flags * [pfVar, pfConst, pfOut, pfArray]) then
      begin
        ErrorMsg := Format(STypeMisMatch, [I + 1, AHandlerMethodName]);
        Exit;
      end;
    end;

    Result := True;
  finally
    Ctx.Free;
  end;
end;

function GetMethod(AInstance: TObject; const AMethodName: string): TMethod;
begin
  Result := GetMethodProp(AInstance, AMethodName);
end;

function CreateTMethod(AInstance: TObject; AMethodAddr: Pointer): TMethod;
begin
  Result.Code := AMethodAddr;
  Result.Data := AInstance;
end;

procedure SetObjectEvent(const ADestInstance: TObject; const AEventName: string; const ASourceHandler: TObject; const AHandlerMethodName: string; ACover: Boolean = False);
var
  PropInfo: PPropInfo;
  Method, HandlerMethod: TMethod;
  sErrMsg: string;
begin
  if (ADestInstance = nil) or (ASourceHandler = nil) then
    Exit;

  if not CheckMethodMatch(ADestInstance, AEventName, ASourceHandler, AHandlerMethodName, sErrMsg) then
  begin
    raise Exception.Create(sErrMsg);
  end;
  HandlerMethod := CreateTMethod(ADestInstance, GetMethod(ASourceHandler, AHandlerMethodName).Code);

  PropInfo := GetPropInfo(ADestInstance, AEventName, [tkMethod]);

  if (PropInfo <> nil) and Assigned(PropInfo^.SetProc) then
  begin
    if not ACover then
    begin
      Method := GetMethodProp(ADestInstance, PropInfo);
      if Method.Code <> nil then
        Exit;
    end;

    SetMethodProp(ADestInstance, PropInfo, HandlerMethod);
  end;
end;

function CheckPropMatch(const ARttiType: TRttiType; const APropertyName: string; const PropType: Pointer; out Prop: TRttiProperty): Boolean;
var
  PropHandle, TargetType: PTypeInfo;
  PropData, TargetData: PTypeData;
begin
  Result := False;
  Prop := nil;

  if not Assigned(ARttiType) then
    Exit;
  Prop := ARttiType.GetProperty(APropertyName);

  if not Assigned(Prop) then
    Exit;

  if not Assigned(PropType) then
    Exit;

  if not (Prop.Visibility in [mvPublished, mvPublic, mvProtected]) or not Prop.IsWritable then
    Exit;

  PropHandle := Prop.PropertyType.Handle;
  TargetType := PropType;

  if PropHandle = TargetType then
  begin
    Result := True;
    Exit;
  end;

  if (PropHandle = nil) or (TargetType = nil) or (PropHandle^.Kind <> TargetType^.Kind) then
    Exit;

  PropData := GetTypeData(PropHandle);
  TargetData := GetTypeData(TargetType);

  case PropHandle^.Kind of
    tkEnumeration:
      Result := (PropData^.BaseType^ = TargetType) or (PropData^.BaseType^ = TargetData^.BaseType^);

    tkInteger, tkFloat, tkChar, tkWChar, tkString, tkLString, tkWString, tkUString, tkInt64:
      Result := True;

    tkClass:
      Result := TargetData^.ClassType.InheritsFrom(PropData^.ClassType);

    tkInterface:
      Result := IsEqualGUID(PropData^.Guid, TargetData^.Guid);
  else
    Result := False;
  end;
end;

procedure SetObjectsBoolProp(const AObjects: array of TObject; const APropertyName: string; const AFlag: Boolean = True);
begin
  SetObjectsProp(AObjects, [APropertyName], TypeInfo(Boolean), AFlag);
end;

procedure SetObjectsBoolProp(const AObjects: array of TObject; const APropertyNames: array of string; const AFlag: Boolean = True);
begin
  SetObjectsProp(AObjects, APropertyNames, TypeInfo(Boolean), AFlag);
end;

procedure SetObjectsProp(const AObjects: array of TObject; const APropertyName: string; const PropInfo: Pointer; const PropValue: Variant);
begin
  SetObjectsProp(AObjects, [APropertyName], PropInfo, PropValue);
end;

procedure SetObjectsProp(const AObjects: array of TObject; const APropertyNames: array of string; const PropInfo: Pointer; const PropValue: Variant);
var
  Context: TRttiContext;
  RttiType: TRttiType;
  Prop: TRttiProperty;
  Obj: TObject;
  sPropName: string;
begin
  Context := TRttiContext.Create;
  try
    for Obj in AObjects do
    begin
      if not Assigned(Obj) then
        Continue;

      RttiType := Context.GetType(Obj.ClassType);
      for sPropName in APropertyNames do
      begin
        if CheckPropMatch(RttiType, sPropName, PropInfo, Prop) then
        begin
          Prop.SetValue(Obj, TValue.FromVariant(PropValue));
        end;
      end;
    end;
  finally
    Context.Free;
  end;
end;

function CallObjectProc(const Aobj: TObject; const AProcName: string): Boolean;
var
  Ctx: TRttiContext;
  RttiType: TRttiType;
  Method: TRttiMethod;
begin
  Result := False;

  if not Assigned(Aobj) then
    Exit;

  Ctx := TRttiContext.Create;
  try
    RttiType := Ctx.GetType(Aobj.ClassType);

    if not Assigned(RttiType) then
      Exit;

    Method := RttiType.GetMethod(AProcName);

    if not Assigned(Method) then
      Exit;

    if Method.Visibility <> mvPublic then
      Exit;

    if Length(Method.GetParameters) > 0 then
      Exit;

    Method.Invoke(Aobj, []);
    Result := True;
  finally
    Ctx.Free;
  end;
end;

end.