import 'dart:math';
import 'dart:ui';

import 'package:binance_task/core/models/websocket/websocket_bloc.dart';
import 'package:binance_task/currency_pair_list/currency_pair_list_state.dart';
import 'package:binance_task/currency_pair_list/widget/currency_pair_list_item.dart';
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

  final EdgeInsets listPadding = EdgeInsets.only(
    top: 30,
    left: 20,
    right: 20,
    bottom: 16 +
        max(window.viewPadding.bottom / window.devicePixelRatio,
            window.viewInsets.bottom / window.devicePixelRatio),
  );

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CurrencyPairListBloc>(context);
    return BlocBuilder<CurrencyPairListBloc, CurrencyPairState>(
      bloc: bloc,
      builder: (BuildContext context, CurrencyPairState state) {
        if (state.status == PostStatus.success) {
          return ListView.separated(
            itemCount: state.pairs.length,
            controller: controller,
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              var item = state.pairs[index];
              return CurrencyListItem(item: item);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 20);
            },
            padding: listPadding,
          );
        }
        if (state.status == PostStatus.failure) {}
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
