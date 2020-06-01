class MetadataValue {
  final String primaryValue;

  MetadataValue({
    this.primaryValue,
  });

  MetadataValue copyWith({
    String primaryValue,
  }) {
    return MetadataValue(
      primaryValue: primaryValue ?? this.primaryValue,
    );
  }
}
