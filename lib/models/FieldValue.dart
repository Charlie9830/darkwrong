class FieldValue {
  final String value;
  final String key; // Currently a copy of the value property. In future may become unique if value becomes a complex object.
  final int length;

  FieldValue(
    this.value,
  )   : key = value,
        length = value?.length ?? 0;

  operator ==(Object o) {
    return o is FieldValue && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
