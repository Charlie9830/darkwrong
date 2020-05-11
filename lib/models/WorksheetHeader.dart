class WorksheetHeaderModel {
  final String uid;
  final String title;
  final int maxFieldLength;

  WorksheetHeaderModel({
    this.uid,
    this.title,
    this.maxFieldLength,
  });

  WorksheetHeaderModel copyWith({
    String uid,
    String title,
    int maxFieldLength,
  }) {
    return WorksheetHeaderModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      maxFieldLength: maxFieldLength ?? this.maxFieldLength,
    );
  }

  ///
  /// Returns the field length Inclusive of the title.
  ///
  int get actualMaxFieldLength => (title?.length ?? 0) > maxFieldLength ? title?.length ?? 0 : maxFieldLength;
}
