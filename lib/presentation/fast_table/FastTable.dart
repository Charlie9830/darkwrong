import 'package:darkwrong/presentation/fast_table/ColumnWidthsProvider.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:flutter/material.dart';

class FastTable extends StatelessWidget {
  final List<FastRow> rows;
  final List<TableHeader> headers;
  FastTable({Key key, this.rows, this.headers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _columnWidths = headers.map((item) => item.width).toList();

    return Column(
      children: [
        Row(
          children: headers,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return ColumnWidthsProvider(
                  key: rows[index].key,
                  widths: _columnWidths,
                  child: rows[index],
                );
              }),
        ),
      ],
    );
  }
}
