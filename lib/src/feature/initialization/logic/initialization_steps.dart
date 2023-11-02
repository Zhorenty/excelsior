import 'dart:async';

import 'package:excelsior/src/feature/articles/data/article_data_provider.dart';
import 'package:excelsior/src/feature/articles/data/article_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/feature/app/data/locale_datasource.dart';
import '/src/feature/app/data/locale_repository.dart';
import '/src/feature/app/data/theme_datasource.dart';
import '/src/feature/app/data/theme_repository.dart';
import '/src/feature/initialization/model/dependencies.dart';
import '/src/feature/initialization/model/initialization_progress.dart';

/// A function which represents a single initialization step.
typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

const kBaseUrl = 'https://jsonplaceholder.typicode.com';

/// The initialization steps, which are executed in the order they are defined.
///
/// The [Dependencies] object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  /// The initialization steps,
  /// which are executed in the order they are defined.
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'Articles Repository': (progress) async {
      final articleDataProvider = ArticleDataProviderImpl(
        restClient: Dio(BaseOptions(baseUrl: kBaseUrl)),
      );
      progress.dependencies.articleRepository = ArticleRepositoryImpl(
        articleDataProvider,
      );
    },
    'Theme Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final themeDataSource = ThemeDataSourceImpl(sharedPreferences);
      progress.dependencies.themeRepository = ThemeRepositoryImpl(
        themeDataSource,
      );
    },
    'Locale Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final localeDataSource = LocaleDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      progress.dependencies.localeRepository = LocaleRepositoryImpl(
        localeDataSource,
      );
    },
  };
}
