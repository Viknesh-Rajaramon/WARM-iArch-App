bool convertStringToBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  
  if (value is int) {
    return value != 0;
  }

  return value.toString().trim() == "1";
}
