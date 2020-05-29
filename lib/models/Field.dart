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
}