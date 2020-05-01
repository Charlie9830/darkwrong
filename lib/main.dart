import 'dart:math';
import 'package:darkwrong/Fast.dart';
import 'package:darkwrong/Slow.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';

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
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    final _random = Random();
    final uuid = Uuid();

    fixtures.addAll(List.generate(1000, (index) {
      return Fixture(
        uid: uuid.v1(),
        unitNumber: (index + 1).toRadixString(10),
        intrumentType: instrumentTypes[_random.nextInt(instrumentTypes.length)],
        multicoreName: '1.1',
        multicoreNumber: _random.nextInt(4).toString(),
        position: 'Advance Truss',
        wattage: '750w',
      );
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Darkwrong'),
            bottom: TabBar(controller: _tabController, tabs: [
              Text('Virtualized'),
              Text('Unvirtualized'),
            ])),
        body: TabBarView(
          controller: _tabController,
          children: [
            Fast(
              fixtures: fixtures,
            ),
            Slow(fixtures: fixtures)
          ],
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class Fixture {
  final String uid;
  final String unitNumber;
  final String position;
  final String intrumentType;
  final String wattage;
  final String multicoreName;
  final String multicoreNumber;

  Fixture(
      {this.uid,
      this.unitNumber,
      this.position,
      this.intrumentType,
      this.wattage,
      this.multicoreName,
      this.multicoreNumber});
}
