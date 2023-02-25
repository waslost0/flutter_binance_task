import 'dart:io';

import 'package:binance_task/core/models/connectivity/connectivity_cubit.dart';
import 'package:binance_task/core/models/connectivity/connectivity_view.dart';
import 'package:binance_task/core/models/websocket/websocket_bloc.dart';
import 'package:binance_task/currency_pair_list/currency_pair_list_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InternetConnectivityCubit()),
        BlocProvider(
          create: (context) => WebSocketBloc(
            internetConnectivityCubit:
                context.read<InternetConnectivityCubit>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return const MaterialApp(
            home: HomePage(),
            // title: Strings.appTitle,
            // theme: context.watch<SwitchThemeCubit>().state,
            debugShowCheckedModeBanner: false,
            // initialRoute: AppRouter.homeScreen,
            // onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CurrencyPairListPage(),
          NoInternetConnection(),
        ],
      ),
    );
  }
}
