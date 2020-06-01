import 'package:darkwrong/enums.dart';
import 'package:meta/meta.dart';

class MetadataDescriptor {
  final String propertyName;
  final String friendlyName;
  final MetadataEncoding encoding;
  final double columnWidth;

  MetadataDescriptor({
    @required this.propertyName,
    @required this.friendlyName,
    @required this.encoding,
    @required this.columnWidth,
  });
}