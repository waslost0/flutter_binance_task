import 'package:binance_task/core/models/websocket/websocket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'currency_pair_list_bloc.dart';

// https://api4.binance.com/api/v3/ticker/24hr
// todo load all currencies before update websocket
class CurrencyPairListPage extends StatelessWidget {
  CurrencyPairListPage({super.key});

  final ScrollController controller = ScrollController(keepScrollOffset: true);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CurrencyPairListBloc(
        websocketBloc: context.read<WebSocketBloc>(),
      )..add(CurrencyPairInitEvent()),
      child: Builder(
        builder: (context) => _buildPage(context),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CurrencyPairListBloc>(context);
    return BlocBuilder<CurrencyPairListBloc, CurrencyPairState>(
      bloc: bloc,
      builder: (BuildContext context, CurrencyPairState state) {
        if (state.status == PostStatus.success) {
          return ListView.builder(
            itemCount: state.pairs.length,
            controller: controller,
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              var item = state.pairs[index];
              return ListTile(
                title: Text("${item.symbol} ${item.closePrice}"),
              );
            },
          );
        }
        if (state.status == PostStatus.failure) {

        }
        return Center(child: const CircularProgressIndicator());
      },
    );
  }
}
