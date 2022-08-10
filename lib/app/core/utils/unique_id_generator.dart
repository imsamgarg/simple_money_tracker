/// Added time param for testing
String getUniqueId({DateTime? time}) {
  return (time ?? DateTime.now().microsecondsSinceEpoch).toString();
}
