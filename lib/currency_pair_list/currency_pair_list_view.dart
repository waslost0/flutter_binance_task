import 'dart:math';
import 'dart:ui';

import 'package:binance_task/app/mixins/search_bar_mixin.dart';
import 'package:binance_task/core/blocs/connectivity/connectivity_cubit.dart';
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
        internetConnectivityCubit: context.read<InternetConnectivityCubit>(),
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
    final bloc = context.read<CurrencyPairListBloc>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SearchBarWidget(
            onSearch: (searchString) {
              bloc.add(CurrencyPairFilterEvent(searchString: searchString));
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<CurrencyPairListBloc, CurrencyPairState>(
            bloc: bloc,
            builder: (BuildContext context, CurrencyPairState state) {
              if (state.status == PostStatus.success) {
                return ListView.separated(
                  itemCount: state.pairs.length,
                  controller: controller,
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
          ),
        ),
      ],
    );
  }
}
