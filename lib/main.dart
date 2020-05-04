import 'dart:math';
import 'package:darkwrong/Cell.dart';
import 'package:darkwrong/FastRow.dart';
import 'package:darkwrong/FastTable.dart';
import 'package:darkwrong/Field.dart';
import 'package:darkwrong/FieldValue.dart';
import 'package:darkwrong/Fixture.dart';
import 'package:darkwrong/TableHeader.dart';
import 'package:darkwrong/enums.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';

const List<String> positions = [
  'Advance Truss',
  'LX1',
  'LX2',
  'LX3',
  'LX4',
  'LX5',
  'LX6',
  'LX7',
  'LX8',
  'Ladder 1 Left',
  'Ladder 1 Right',
  'Ladder 2 Left',
  'Ladder 2 Right',
  'Ladder 3 Left',
  'Ladder 3 Right',
  'Ladder 4 Left',
  'Ladder 4 Right',
  'Rover 1 Left',
  'Rover 1 Right',
  'Rover 2 Left',
  'Rover 2 Right',
  'Smoke Left',
  'Smoke Right',
  'Portal 1',
  'Portal 2',
  'Portal 3',
  'Portal 4',
  'Box Boom Left',
  'Box Boom Right',
  'Pro Boom Left',
  'Pro Boom Right',
  'Bridge 1',
  'Bridge 2',
  'Near Slot Left',
  'Near Slot Right',
  'Far Slot Left',
  'Far Slot Right'
];

const List<String> instrumentTypes = [
  'Source4 10deg',
  'Source4 5deg ',
  'Source4 14deg ',
  'Source4 19deg ',
  'Source4 26deg ',
  'Source4 36deg ',
  'Source4 Lustr2 10deg',
  'Source4 Lustr2 5deg ',
  'Source4 Lustr2 14deg',
  'Source4 Lustr2 19deg',
  'Source4 Lustr2 26deg',
  'Source4 Lustr2 36deg',
  'Martin Mac Viper Performance',
  'Martin Mac Viper Profile',
  'Martin Mac Viper Wash DX',
  'VL3500 Spot',
  'VL3500 Wash',
  'GLP Bar 20',
  'GLP JDC1',
  'Clay Paky Sharpy',
  'Clay Paky Super Sharpy',
  'Clay Paky Unico',
  'Clay Paky Sharpy Wash 330',
  'Clay Paky Axcor',
  'Robe MegaPointe',
  'Robe BMFL',
  'Martin Mac Quantum Wash',
  'Martin Mac Quantum Profile',
  'Martin Mac Aura',
  'Martin Mac Aura XB',
  'Martin Mac Aura PXL'
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Fixture> fixtures = [];
  List<Fixture> testBuffer = [];
  Map<String, Field> fields = {};
  Map<String, int> maxFieldLengths = {};

  @override
  void initState() {
    final _random = Random();
    final uuid = Uuid();

    final String firstId = uuid.v4();
    final String secondId = uuid.v4();
    final String thirdId = uuid.v4();
    final String fourthId = uuid.v4();
    final String fifthId = uuid.v4();
    final String sixthId = uuid.v4();
    final String seventhId = uuid.v4();
    final String eighthId = uuid.v4();

    fields.addAll(<String, Field>{
      firstId: Field(uid: firstId, name: 'Unit Number', type: FieldType.text),
      secondId: Field(
        uid: secondId,
        name: 'Position',
        type: FieldType.text,
      ),
      thirdId: Field(
        uid: thirdId,
        name: 'Instrument Type',
        type: FieldType.text,
      ),
      fourthId: Field(
        uid: fourthId,
        name: 'Instrument Type 2',
        type: FieldType.text,
      ),
      fifthId: Field(
        uid: fifthId,
        name: 'Instrument Type 3',
        type: FieldType.text,
      ),
      sixthId: Field(
        uid: sixthId,
        name: 'Instrument Type 4',
        type: FieldType.text,
      ),
      seventhId: Field(
        uid: seventhId,
        name: 'Instrument Type 5',
        type: FieldType.text,
      ),
      eighthId: Field(
        uid: eighthId,
        name: 'Instrument Type 6',
        type: FieldType.text,
      )
    });

    fixtures.addAll(List.generate(2000, (index) {
      return Fixture(uid: uuid.v4(), fieldValues: <String, FieldValue>{
        firstId: FieldValue((index + 1).toString()), // Unit Number
        secondId: FieldValue(
            positions[_random.nextInt(positions.length)]), // Position
        thirdId: FieldValue(
            instrumentTypes[_random.nextInt(instrumentTypes.length)]),

        fourthId: FieldValue(
            instrumentTypes[_random.nextInt(instrumentTypes.length)]),

        fifthId: FieldValue(
            instrumentTypes[_random.nextInt(instrumentTypes.length)]),

        sixthId: FieldValue(
            instrumentTypes[_random.nextInt(instrumentTypes.length)]),

        seventhId: FieldValue(
            instrumentTypes[_random.nextInt(instrumentTypes.length)]),

        eighthId: FieldValue(instrumentTypes[
            _random.nextInt(instrumentTypes.length)]), // Instrument Type
      });
    }));

    maxFieldLengths = _buildMaxFieldLengths(fixtures);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Darkwrong'),
          actions: [
            RaisedButton(
              child: Text('Dump'),
              onPressed: _onDumpButtonPressed,
            ),
            RaisedButton(
              child: Text('Rebuild'),
              onPressed: _onRebuildButtonPressed,
            )
          ],
        ),
        body: FastTable(
          headers: fields.entries.map((field) {
            return TableHeader(
              Text(field.value.name),
              key: Key(field.key),
              width: maxFieldLengths[field.key] * 8.0,
            );
          }).toList(),
          rows: fixtures.map((fixture) {
            return FastRow(
              key: Key(fixture.uid),
              children: fixture.fieldValues.entries.map((entry) {
                return Cell(
                  entry.value.value,
                );
              }).toList(),
            );
          }).toList(),
        ));
  }

  void _onDumpButtonPressed() {
    setState(() {
      testBuffer = fixtures.toList();
      fixtures = [];
    });
  }

  void _onRebuildButtonPressed() {
    setState(() {
      fixtures = testBuffer.toList();
      testBuffer = [];
    });
  }

  Map<String, int> _buildMaxFieldLengths(List<Fixture> fixtures) {
    final Map<String, int> maxLengths = {};

    for (var fixture in fixtures) {
      for (var fieldValue in fixture.fieldValues.entries) {
        // Place an entry if one doesn't already exist.
        if (maxLengths.containsKey(fieldValue.key) == false) {
          maxLengths[fieldValue.key] = 0;
        }

        // Update the max length if greater than existing value.
        if (maxLengths[fieldValue.key] < fieldValue.value.length) {
          maxLengths[fieldValue.key] = fieldValue.value.length;
        }
      }
    }

    return maxLengths;
  }
}
