import 'package:darkwrong/enums.dart';
import 'package:meta/meta.dart';

class FieldModel {
  final String uid;
  final String name;
  final ValueEncoding encoding;
  final FieldType type;

  FieldModel({
    @required this.uid,
    @required this.name,
    @required this.encoding,
    @required this.type,
  });

  bool get isBuiltIn => type != FieldType.custom;

  FieldModel copyWith({
    String uid,
    String name,
    ValueEncoding encoding,
    FieldType type,
  }) {
    return FieldModel(
      uid: uid ?? this.uid,
      encoding: encoding ?? this.encoding,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
