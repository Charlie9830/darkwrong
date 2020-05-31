import 'package:darkwrong/enums.dart';

String getHumanFriendlyValueEncoding(ValueEncoding encoding) {
  switch(encoding) {
    case ValueEncoding.number:
      return "Number";
    case ValueEncoding.text:
      return "Text";
    default:
    throw UnimplementedError('No case for $encoding in getHumanFriendlyValueEncoding');
  }
}