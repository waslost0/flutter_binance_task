import 'package:binance_task/core/models/connectivity/connectivity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetConnectivityCubit, InternetConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityResultState) {
          return buildNoInternetAnimatedSwitcher(
            context,
            state.connectivityResult,
            buildNoInternetSafeArea(context),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildNoInternetSafeArea(BuildContext context) {
    return SafeArea(
      child: buildText(),
    );
  }

  Widget buildText() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 22,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Flexible(
              child: Text(
                'Вы не в сети. Проверьте подключение к Интернету.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoInternetAnimatedSwitcher(
      BuildContext context, bool value, Widget? child) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSwitcher(
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (widget, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(animation),
            child: widget,
          );
        },
        duration: const Duration(milliseconds: 250),
        child: (value) ? const SizedBox.shrink() : child,
      ),
    );
  }
}
