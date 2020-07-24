import 'dart:async';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import 'custom_hook.dart';
import 'steps/login.dart';

Future<void> main() {
  final steps = [...LoginTest.STEPS];

  final config = FlutterTestConfiguration.DEFAULT(steps,
      featurePath: 'test_driver/features/**.feature',
      targetAppPath: 'test_driver/app.dart')
    ..hooks = [CustomHook()]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      FlutterDriverReporter(
        logErrorMessages: true,
      ),
      StdoutReporter()
    ]
    //..targetDeviceId = 'all' //doesn't work
    ..restartAppBetweenScenarios = true
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}
