import 'package:binance_task/app/theme/app_theme.dart';
import 'package:binance_task/core/blocs/websocket/websocket_bloc.dart';
import 'package:binance_task/core/widgets/loading_indicator_widget.dart';
import 'package:binance_task/core/widgets/search_bar_widget.dart';
import 'package:binance_task/currency_pair_list/currency_pair_list_state.dart';
import 'package:binance_task/currency_pair_list/widget/currency_pair_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'currency_pair_list_bloc.dart';

/// [build] - [CurrencyPairListBloc]
/// - [_buildPage]
/// - - [LoadingIndicatorWidget]
/// - - [SearchBarWidget]
/// - - [buildList] - ListView
/// - - - [CurrencyListItem]
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

  final EdgeInsets listPadding = const EdgeInsets.only(
    top: 20,
    left: 20,
    right: 20,
    bottom: 16,
  );

  /// [_buildPage] boilerplate, with like BaseListView will disappear
  ///
  /// buildListItem instead
  /// ```
  /// @override
  /// Widget buildListItem(int index) {
  ///   var item = state.pairs[index];
  ///   return CurrencyListItem(item: item);
  /// }
  /// ```
  ///
  /// For SearchBar some fixed list header/
  ///
  /// @override
  /// Widget buildListHeader(BuildContext context) {
  ///   final bloc = context.read<CurrencyPairListBloc>();
  ///   return Padding(
  ///     padding: const EdgeInsets.only(top: 15, bottom: 5),
  ///     child: SearchBarWidget(
  ///       onSearch: (searchString) {
  ///         bloc.add(CurrencyPairFilterEvent(searchString: searchString));
  ///       },
  ///       onCancelTap: () {
  ///         bloc.add(CurrencyPairFilterEvent(searchString: ""));
  ///       },
  ///     ),
  ///   );
  /// }
  Widget _buildPage(BuildContext context) {
    final bloc = context.read<CurrencyPairListBloc>();
    return SafeArea(
      child: Stack(
        children: [
          BlocBuilder<CurrencyPairListBloc, CurrencyPairState>(
            bloc: bloc,
            buildWhen: (previous, current) =>
                previous != current && previous.status == PostStatus.initial,
            builder: (context, state) {
              if (state.status == PostStatus.initial) {
                return const Center(child: LoadingIndicatorWidget());
              }
              return const SizedBox();
            },
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                child: SearchBarWidget(
                  onSearch: (searchString) {
                    bloc.add(
                      CurrencyPairFilterEvent(searchString: searchString),
                    );
                  },
                  onCancelTap: () {
                    bloc.add(CurrencyPairFilterEvent(searchString: ""));
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<CurrencyPairListBloc, CurrencyPairState>(
                  bloc: bloc,
                  builder: (BuildContext context, CurrencyPairState state) {
                    if (state.status == PostStatus.success) {
                      if (state.pairs.isEmpty) {
                        return const Center(
                          child: Text("Empty list", style: AppTextStyle.title),
                        );
                      }
                      return buildList(state);
                    }
                    if (state.status == PostStatus.failure) {
                      // TODO: error widget
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildList(CurrencyPairState state) {
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
}
