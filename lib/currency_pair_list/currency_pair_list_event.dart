import 'package:equatable/equatable.dart';

abstract class CurrencyPairListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitEvent extends CurrencyPairListEvent {}

class UpdateEvent extends CurrencyPairListEvent {}
