import 'package:darkwrong/main.dart';
import 'package:flutter/material.dart';

class Slow extends StatelessWidget {
  final List<Fixture> fixtures;
  Slow({Key key, this.fixtures}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text('Unit Number'),
              ),
              DataColumn(
                label: Text('Position'),
              ),
              DataColumn(
                label: Text('Instrument Type'),
              ),
              DataColumn(
                label: Text('Wattage'),
              ),
              DataColumn(
                label: Text('Multicore Name'),
              ),
              DataColumn(
                label: Text('Multicore #'),
              ),
            ],
            rows: fixtures.map((item) {
              return DataRow(
                key: Key(item.uid),
                cells: [
                  DataCell(Text(item.unitNumber,)),
                  DataCell(Text(item.position,)),
                  DataCell(Text(item.intrumentType,)),
                  DataCell(Text(item.wattage,)),
                  DataCell(Text(item.multicoreName,)),
                  DataCell(Text(item.multicoreNumber,)),
                ],
              );
            }).toList()),
      );
    
  }
}
