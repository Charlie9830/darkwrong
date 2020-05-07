import 'package:uuid/uuid.dart';

String getUid() {
  final uuid = Uuid();

  return uuid.v4();
}