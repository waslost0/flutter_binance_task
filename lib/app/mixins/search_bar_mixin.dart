import 'dart:async';

import 'package:binance_task/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String searchString) onSearch;

  const SearchBarWidget({
    required this.onSearch,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

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
    inputFocus.addListener(() {
      if (!inputFocus.hasFocus) {
        onCancel();
      } else {
        onTap();
      }
    });
    searchController.addListener(() {
      _startReloadTimer();
    });
  }

  Widget _buildSearchInputField(BuildContext context) {
    return TextFormField(
      focusNode: inputFocus,
      onFieldSubmitted: onSubmitted,
      controller: searchController,
      maxLength: maxSearchStringLength,
      decoration: AppTheme.buildSearchInputDecoration().copyWith(
        isDense: true,
        hintText: searchHint,
        hintStyle: AppTextStyle.body2.copyWith(
          color: AppColors.hint,
        ),
        counterText: "",
      ),
    );
  }

  @protected
  void onCancelTap() {
    searchController.text = "";
  }

  void onSearch(String searchString) {
    widget.onSearch.call(searchString);
  }

  void onTap() {}

  @protected
  void onCancel() {}

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
}
