import 'package:binance_task/app/theme/app_theme.dart';
import 'package:binance_task/core/helpers/formatter.dart';
import 'package:binance_task/currency_pair_list/entities/currency.dart';
import 'package:flutter/material.dart';

/// [CurrencyListItem]
/// [Row]
/// - [buildCurrencyTitleVolume] - Currency pair name and value
/// - [buildValuePrice] - Value and open price (not sure what is top value must be)
/// - [buildPercent] - Percent open close price calculated
class CurrencyListItem extends StatelessWidget {
  final CurrencyPair item;

  const CurrencyListItem({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: buildCurrencyTitleVolume()),
        Expanded(child: buildValuePrice()),
        buildPercent(),
      ],
    );
  }

  Widget buildCurrencyTitleVolume() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCurrencyTitle(),
        const SizedBox(height: 5),
        buildVolume(),
      ],
    );
  }

  Widget buildValuePrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ValueFormatter().removeDecimalZeroFormat(item.openPrice),
          style: AppTextStyle.body1.copyWith(
            color: openPriceColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        buildPrice(),
      ],
    );
  }

  Widget buildPrice() {
    return Text(
      ValueFormatter().formatPriceCurrency(item.closePrice),
      style: AppTextStyle.body1.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildCurrencyTitle() {
    return Text(
      item.symbol,
      style: AppTextStyle.title,
    );
  }

  Widget buildVolume() {
    return Text(
      "Vol ${ValueFormatter().formatValueSimple(item.totalTradedQuoteAssetVolume)}",
      style: AppTextStyle.body1.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color get openPriceColor {
    if (item.openPriceValue > item.closePriceValue) {
      return AppColors.red;
    }
    return AppColors.green;
  }

  Widget buildPercent() {
    return Card(
      color: percentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        alignment: Alignment.center,
        constraints: const BoxConstraints(minWidth: 105),
        child: Text(
          percentText,
          style: AppTextStyle.title1.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  double get percentValue {
    return (100 - ((item.openPriceValue * 100) / item.closePriceValue));
  }

  String get percentText {
    var value = percentValue;
    return "${value > 0 ? "+" : "-"}${value.abs().toStringAsFixed(2)} %";
  }

  Color get percentColor {
    return percentValue > 0.0 ? AppColors.green : AppColors.red;
  }
}
