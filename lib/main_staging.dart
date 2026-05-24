import 'main_development.dart' as development;

@Deprecated(
  'Use main_development.dart or main_production.dart. Staging flavor was removed.',
)
Future<void> main() => development.main();
