import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

part 'connectivity_state.dart';

/// Internet connectivity cubit will track connection state.
class InternetConnectivityCubit extends Cubit<InternetConnectivityState> {
  InternetConnectivityCubit()
      : super(
          ConnectivityResultState(connectivityResult: true),
        ) {
    checkConnection().then((value) => _emitConnectivityResult(value));
    _monitorInternetStatus();
  }

  late final StreamSubscription<ConnectivityResult> _internetStatusSubscription;

  StreamSubscription<ConnectivityResult> _monitorInternetStatus() {
    return _internetStatusSubscription =
        Connectivity().onConnectivityChanged.listen(_deserializeAndEmit);
  }

  void _deserializeAndEmit(ConnectivityResult status) {
    switch (status) {
      case ConnectivityResult.bluetooth:
        break;
      case ConnectivityResult.wifi:
        _emitConnectivityResult(true);
        break;
      case ConnectivityResult.ethernet:
        _emitConnectivityResult(true);
        break;
      case ConnectivityResult.mobile:
        _emitConnectivityResult(true);
        break;
      case ConnectivityResult.none:
        _emitConnectivityResult(false);
        break;
      case ConnectivityResult.vpn:
        break;
      case ConnectivityResult.other:
        break;
    }
  }

  void _emitConnectivityResult(bool result) {
    emit(ConnectivityResultState(connectivityResult: result));
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.vpn;
  }

  @override
  Future<void> close() {
    _internetStatusSubscription.cancel();
    return super.close();
  }
}
