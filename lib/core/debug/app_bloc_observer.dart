import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Debug class for bloc base (blocs, cubits)
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    if (kDebugMode) {
      log('Changed: $change');
    }
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    if (kDebugMode) {
      log('Created $bloc');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    if (kDebugMode) {
      log('Closed $bloc');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    if (kDebugMode) {
      log('$bloc throws $error , stactrace: $stackTrace');
    }
  }
}
