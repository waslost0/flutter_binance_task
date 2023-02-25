import 'package:binance_task/core/models/websocket/websocket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'currency_pair_list_bloc.dart';
import 'currency_pair_list_event.dart';
import 'currency_pair_list_state.dart';

class CurrencyPairListPage extends StatelessWidget {
  const CurrencyPairListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CurrencyPairListBloc(
        websocketBloc: context.read<WebSocketBloc>(),
      )..add(InitEvent()),
      child: Builder(
        builder: (context) => _buildPage(context),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CurrencyPairListBloc>(context);
    return BlocBuilder<CurrencyPairListBloc, CurrencyPairListState>(
      bloc: bloc,
      builder: (BuildContext context, CurrencyPairListState state) {
        return Placeholder();
      },
    );
  }
}
