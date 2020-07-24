import 'dart:async';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/login.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r'test_driver/features/**.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      FlutterDriverReporter(
        logErrorMessages: true,
      ),
      StdoutReporter()
    ]
    ..stepDefinitions = [LoginGiven(), LoginWhen1(), LoginWhen2(), LoginThen()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test_driver/app.dart'
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}
