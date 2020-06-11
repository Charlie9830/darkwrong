import 'package:darkwrong/presentation/fast_table/CellId.dart';
import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:meta/meta.dart';

class CellChangeData implements Comparable {
  final CellIndex index;
  final CellId id;

  CellChangeData({
    @required this.index,
    @required this.id,
  });

  @override
  int compareTo(other) {
    if (other is CellChangeData) {
      if (other.index.rowIndex != this.index.rowIndex) {
        return this.index.rowIndex - other.index.rowIndex;
      }

      return this.index.columnIndex - other.index.columnIndex;
    }

    throw FormatException('Other is not of type CellChangeData');
  }
}
