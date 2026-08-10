import 'dart:async';

import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/infrastructure/card/repositories/local_card_reposory_impl.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/router/router.dart';
import 'package:dereruministic/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final cardRepository = LocalCardRepositoryImpl();
      final cards = await cardRepository.fetchAllCards();

      runApp(
        ProviderScope(
          overrides: [
            cardCatalogProvider.overrideWithValue(cards),
          ],
          child: const MainApp(),
        ),
      );
    },
    (e, s) {
      debugPrint('catch on runZonedGuarded: $e /// $s');
    },
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      //theme: AppTheme.light.copyWith(scaffoldBackgroundColor: Colors.white),
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
