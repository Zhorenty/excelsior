import 'package:excelsior/src/feature/articles/widget/articles_screen.dart';
import 'package:flutter/material.dart';
import '/src/core/localization/localization.dart';
import '/src/feature/app/widget/locale_scope.dart';
import '/src/feature/app/widget/theme_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatefulWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context).theme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      locale: LocaleScope.of(context).locale,
      home: const ArticleScreen(),
    );
  }
}
