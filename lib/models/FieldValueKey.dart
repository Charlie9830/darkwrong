class FieldValueKey {
  final String _key;

  FieldValueKey(this._key);

  FieldValueKey.fromText(String key) : _key = key;

  operator ==(Object o) {
    return o is FieldValueKey && o.hashCode == _key.hashCode;
  }

  @override
  int get hashCode => _key.hashCode;

  @override
  String toString() {
    return _key;
  }
}
