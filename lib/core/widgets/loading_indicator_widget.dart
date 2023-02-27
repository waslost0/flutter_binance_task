import 'package:binance_task/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final bool needShowOverlay;
  final double? topMargin;
  final MainAxisAlignment mainAxisAlignment;

  const LoadingIndicatorWidget({
    this.topMargin,
    this.needShowOverlay = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (needShowOverlay) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          buildLoader(context),
          Container(
            color: Colors.black.withOpacity(0.2),
            height: double.infinity,
            width: double.infinity,
          ),
        ],
      );
    }
    return buildLoader(context);
  }

  Widget buildLoader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Container(
          margin: topMargin != null ? EdgeInsets.only(top: topMargin!) : null,
          child: const SizedBox(
            height: 34,
            width: 34,
            child: CircularProgressIndicator(
              color: AppColors.loadingIndicatorColor,
              strokeWidth: 4,
            ),
          ),
        ),
      ],
    );
  }
}
