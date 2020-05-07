class FieldValueModel {
  final String uid;
  final String value;
  final int length;

  FieldValueModel(
    this.uid,
    this.value,
  ) : length = value?.length ?? 0;
}
