import 'package:binance_task/core/models/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color color;

  const CardWidget({
    super.key,
    this.child,
    this.color = AppColors.black,
    this.margin = const EdgeInsets.symmetric(
      vertical: AppTheme.defaultSmallPadding,
      horizontal: AppTheme.defaultPadding,
    ),
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.buildCardDecoration().copyWith(color: color),
      margin: margin,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
