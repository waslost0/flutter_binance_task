part of 'connectivity_cubit.dart';

@immutable
abstract class InternetConnectivityState {}

class ConnectivityResultState extends InternetConnectivityState {
  ConnectivityResultState({
    required this.connectivityResult,
  });

  final bool connectivityResult;
}
