class FieldValue {
  final String value;
  final int length;

  FieldValue(
    this.value,
  ) : length = value?.length ?? 0;
}
