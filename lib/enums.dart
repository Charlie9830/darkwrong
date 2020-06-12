enum ValueEncoding {
  number,
  text,
}

enum FieldType {
  custom,
  instrumentName,
  position,
  channel,
  unitNumber,
}

enum FieldEnumeration {
  none,
  postive,
  negative,
}

enum InstrumentType {
  conventional,
  movingLight,
  atmosphericFX,
  specialFX,
  practical,
  other,
}

enum MetadataEncoding {
  text,
  number,
  instrumentType,
}

enum CellSelectionDirectionality {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  none,
}

enum RelativeAnchorLocation {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
  centered
}
