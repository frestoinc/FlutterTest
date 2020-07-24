import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class CustomHook extends Hook {
  @override
  Future<void> onAfterScenarioWorldCreated(
      World world, String scenario, Iterable<Tag> tags) async {
    await (world as FlutterWorld).driver.requestData(
          'APP:RESET',
          timeout: const Duration(seconds: 6),
        );
  }
}
