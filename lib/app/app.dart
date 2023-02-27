import 'package:binance_task/app/theme/app_theme.dart';
import 'package:binance_task/core/blocs/connectivity/connectivity_cubit.dart';
import 'package:binance_task/core/blocs/connectivity/connectivity_view.dart';
import 'package:binance_task/core/blocs/websocket/websocket_bloc.dart';
import 'package:binance_task/core/constants/strings.dart';
import 'package:binance_task/currency_pair_list/currency_pair_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InternetConnectivityCubit()),
        BlocProvider(
          create: (context) => WebSocketBloc(
            internetConnectivityCubit:
                context.read<InternetConnectivityCubit>(),
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                CurrencyPairListPage(),
                const Positioned(
                  bottom: 0,
                  left: 16,
                  right: 16,
                  child: NoInternetConnection(),
                ),
              ],
            ),
          ),
        ),
        title: Strings.appTitle,
        theme: AppTheme.buildThemeData(),
        debugShowCheckedModeBanner: false,
        // initialRoute: AppRouter.homeScreen,
        // onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
