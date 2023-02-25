part of 'currency_pair_list_bloc.dart';

abstract class CurrencyPairEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrencyPairInitEvent extends CurrencyPairEvent {}

class CurrencyPairErrorEvent extends CurrencyPairEvent {
  final String message;

  CurrencyPairErrorEvent(this.message);
}

class CurrencyPairUpdatedEvent extends CurrencyPairEvent {
  final List<CurrencyPair> pairs;

  CurrencyPairUpdatedEvent({
    required this.pairs,
  });
}
