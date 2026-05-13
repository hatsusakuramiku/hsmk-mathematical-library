unit ExceptionStrConstsUnit;

interface

/// <summary>
/// Exception message string constants for parameter validation.
/// </summary>
resourcestring
  /// <param name="A">Parameter name</param>
  /// <param name="B">Parameter name</param>
  sParamGreaterEqual = 'Parameter %s must greater than or equal to Parameter %s';

  /// <param name="A">Parameter name</param>
  /// <param name="B">Parameter name</param>
  sParamSLesserEqual = 'Parameter %s must lesser than or equal to Parameter %s';

  /// <param name="A">Parameter name</param>
  /// <param name="B">Current value</param>
  /// <param name="C">Minimum value</param>
  /// <param name="D">Maximum value</param>
  sParamOutOfRangeExclusive = 'Parameter %s out of range (%s).  Must be >= %s and < %s';

  /// <param name="A">Parameter name</param>
  /// <param name="B">Current value</param>
  /// <param name="C">Minimum value</param>
  /// <param name="D">Maximum value</param>
  sParamOutOfRangeInclusive = 'Parameter %s out of range (%d).  Must be >= %d and <= %d';

implementation

end.