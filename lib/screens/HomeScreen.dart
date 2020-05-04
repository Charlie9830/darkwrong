import 'package:darkwrong/containers/WorksheetContainer.dart';
import 'package:darkwrong/view_models/HomeScreenViewModel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;
  const HomeScreen({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
          title: Text('Darkwrong'),
          actions: [
            RaisedButton(
              child: Text('Debug'),
              onPressed: viewModel.onDebugButtonPressed,
            )
          ],
        ),
        body: WorksheetContainer(), 
        );
  }
}