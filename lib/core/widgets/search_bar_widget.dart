import 'dart:async';

import 'package:binance_task/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// [SearchBarWidget]
/// Simple search bar widget
class SearchBarWidget extends StatefulWidget {
  final Function(String searchString) onSearch;
  final Function()? onCancelTap;

  const SearchBarWidget({
    required this.onSearch,
    this.onCancelTap,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

/// [build] - [PreferredSize]
/// - [_buildSearchInputField]
class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController searchController = TextEditingController();
  bool isSearchActive = false;
  Timer? _reloadTimer;
  FocusNode inputFocus = FocusNode();

  bool rightActionButtonEnabled = false;

  int get maxSearchStringLength => 256;

  String get searchHint => "Search coin pairs";

  Duration timerDuration = Duration.zero;

  bool get hideNavBar => false;

  EdgeInsets get searchBarPadding => const EdgeInsets.symmetric(horizontal: 16);

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      _startReloadTimer();
    });
  }

  @protected
  void onCancelTap() {
    searchController.text = "";
    widget.onCancelTap?.call();
  }

  void onSearch(String searchString) {
    widget.onSearch.call(searchString.trim().toLowerCase());
  }

  @protected
  void onSubmitted(String searchString) {}

  void _startReloadTimer() {
    if (_reloadTimer != null) {
      _reloadTimer?.cancel();
    }

    _reloadTimer = Timer(timerDuration, () {
      onSearch(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 70.0),
      child: Padding(
        padding: searchBarPadding,
        child: _buildSearchInputField(context),
      ),
    );
  }

  Widget _buildSearchInputField(BuildContext context) {
    return TextFormField(
      focusNode: inputFocus,
      onFieldSubmitted: onSubmitted,
      controller: searchController,
      maxLength: maxSearchStringLength,
      style: AppTextStyle.body1.copyWith(
        decorationColor: Colors.white,
        height: 1.2,
      ),
      decoration: AppTheme.buildSearchInputDecoration().copyWith(
        hintText: searchHint,
        hintStyle: AppTextStyle.body2.copyWith(
          color: AppColors.lightGray,
        ),
        isDense: true,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 45,
        ),
        suffixIcon: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 15,
          onPressed: onCancelTap,
          icon: const Icon(
            Icons.cancel_outlined,
            color: AppColors.lightGray,
          ),
        ),
        counterText: "",
      ),
    );
  }
}
