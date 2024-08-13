import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/connectivity_bloc.dart/connectivity_event.dart';
import 'package:sleer/blocs/connectivity_bloc.dart/connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      var isConnected =
          results.contains(ConnectivityResult.none) ? false : true;
      add(ConnectivityChanged(isConnected));
    });

    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
