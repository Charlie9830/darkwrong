import 'package:darkwrong/redux/reducers/AppStateReducer.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:redux/redux.dart';

final appStore = Store<AppState>(appStateReducer, initialState: AppState.initial());