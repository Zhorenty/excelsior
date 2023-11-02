import '/src/feature/initialization/model/environment_store.dart';
import 'dependencies.dart';

/// {@template initialization_progress}
/// A class which represents the initialization progress.
/// {@endtemplate}
final class InitializationProgress {
  /// {@macro initialization_progress}
  const InitializationProgress({
    required this.dependencies,
    required this.environmentStore,
  });

  /// Mutable version of dependencies
  final DependenciesMutable dependencies;

  /// Environment store
  final IEnvironmentStore environmentStore;
}
