import 'package:darkwrong/containers/HomeScreenContainer.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureCreator.dart';
import 'package:darkwrong/redux/AppStore.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Darkwrong());
}

class Darkwrong extends StatefulWidget {
  @override
  _DarkwrongState createState() => _DarkwrongState();
}

class _DarkwrongState extends State<Darkwrong> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp(
        title: 'Darkwrong',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreenContainer(),
      ),
    );
  }
}
