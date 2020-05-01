import 'dart:math';
import 'package:darkwrong/Fast.dart';
import 'package:darkwrong/Slow.dart';
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Fixture> fixtures = [];
  MaxColumnLengths maxColumnLengths = MaxColumnLengths();

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    final _random = Random();
    final uuid = Uuid();

    fixtures.addAll(List.generate(2000, (index) {
      return Fixture(
        uid: uuid.v4(),
        unitNumber: (index + 1).toRadixString(10),
        instrumentType:
            instrumentTypes[_random.nextInt(instrumentTypes.length)],
        multicoreName: '1.1',
        multicoreNumber: _random.nextInt(4).toString(),
        position: positions[_random.nextInt(positions.length)],
        wattage: '750w',
      );
    }));

    maxColumnLengths = _buildMaxColumnLengths(fixtures);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Darkwrong'),
            actions: [
              RaisedButton(
                child: Text('Debug'),
                onPressed: _onDebugButtonPressed,
              )
            ],
            bottom: TabBar(controller: _tabController, tabs: [
              Text('Virtualized'),
              Text('Unvirtualized'),
            ])),
        body: TabBarView(
          controller: _tabController,
          children: [
            Fast(
              fixtures: fixtures,
              maxColumnLengths: maxColumnLengths
            ),
            Slow(fixtures: fixtures)
          ],
        ));
  }

  void _onDebugButtonPressed() {
    print(fixtures);
  }

  MaxColumnLengths _buildMaxColumnLengths(List<Fixture> fixtures) {
    final MaxColumnLengths maxLengths = MaxColumnLengths();

    for (var fixture in fixtures) {
      // Unit Number
      if (fixture.unitNumberLength > maxLengths.unitNumber) {
        maxLengths.unitNumber = fixture.unitNumberLength;
      }

      // Position
      if (fixture.positionLength > maxLengths.position) {
        maxLengths.position = fixture.positionLength;
      }

      // InstrumentType
      if (fixture.instrumentTypeLength > maxLengths.instrumentType) {
        maxLengths.instrumentType = fixture.instrumentTypeLength;
      }

      // Wattage
      if (fixture.wattageLength > maxLengths.wattage) {
        maxLengths.wattage = fixture.wattageLength;
      }

      // MulticoreName
      if (fixture.multicoreNameLength > maxLengths.multicoreName) {
        maxLengths.multicoreName = fixture.multicoreNameLength;
      }

      // MulticoreNumber
      if (fixture.multicoreNumberLength > maxLengths.multicoreNumber) {
        maxLengths.multicoreNumber = fixture.multicoreNumberLength;
      }
    }

    return maxLengths;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class MaxColumnLengths {
  int unitNumber = 0;
  int position = 0;
  int instrumentType = 0;
  int wattage = 0;
  int multicoreName = 0;
  int multicoreNumber = 0;
}

class Fixture {
  final String uid;
  final String unitNumber;
  final String position;
  final String instrumentType;
  final String wattage;
  final String multicoreName;
  final String multicoreNumber;

  final int unitNumberLength;
  final int positionLength;
  final int instrumentTypeLength;
  final int wattageLength;
  final int multicoreNameLength;
  final int multicoreNumberLength;

  Fixture(
      {this.uid,
      this.unitNumber = '',
      this.position = '',
      this.instrumentType = '',
      this.wattage = '',
      this.multicoreName = '',
      this.multicoreNumber = ''})
      : unitNumberLength = unitNumber.length ?? 0,
        positionLength = position.length ?? 0,
        instrumentTypeLength = instrumentType.length ?? 0,
        wattageLength = wattage.length ?? 0,
        multicoreNameLength = multicoreName.length ?? 0,
        multicoreNumberLength = multicoreNumber.length ?? 0;
}
