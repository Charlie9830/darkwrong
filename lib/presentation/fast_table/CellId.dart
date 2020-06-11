import 'package:meta/meta.dart';
import 'package:quiver/core.dart' show hash2;

class CellId {
  final String rowId;
  final String columnId;

  CellId({
    @required this.rowId,
    @required this.columnId,
  });

  operator ==(dynamic o) {
    return o is CellId && o.rowId == rowId && o.columnId == columnId;
  }

  @override
  int get hashCode => hash2(rowId, columnId);
}
