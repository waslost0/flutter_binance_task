import 'package:binance_task/app/theme/app_theme.dart';
import 'package:binance_task/core/blocs/connectivity/connectivity_cubit.dart';
import 'package:binance_task/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [NoInternetConnection]
/// Animated bottom widget witch shows message about lost internet connection
///
/// [build]
/// - [BlocBuilder]
/// - - [buildBody]
class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetConnectivityCubit, InternetConnectivityState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is ConnectivityResultState) {
          return buildBody(
            value: state.connectivityResult,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildBody({
    required bool value,
  }) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      heightFactor: !value ? 1.0 : 0.0,
      child: !value
          ? Container(
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 22,
                ),
                child: const Text(
                  Strings.noInternetConnection,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
