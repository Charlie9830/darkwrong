import 'package:darkwrong/redux/reducers/AppStateReducer.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final appStore = Store<AppState>(appStateReducer,
    initialState: AppState.initial(), middleware: [thunkMiddleware]);
