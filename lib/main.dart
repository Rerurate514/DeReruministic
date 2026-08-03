import 'dart:async';

import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/router/router.dart';
import 'package:dereruministic/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runZonedGuarded(
    () {
      runApp(const ProviderScope(child: MainApp()));
    },
    (e, s) {
      debugPrint('catch on runZonedGuarded: $e /// $s');
    },
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: AppTheme.light.copyWith(scaffoldBackgroundColor: Colors.white),
      //darkTheme: AppTheme.dark.copyWith(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
