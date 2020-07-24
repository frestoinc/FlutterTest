import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class LoginGiven extends Given3WithWorld<String, String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1, String input2, String input3) async {
    await Future<void>.delayed(Duration(seconds: 6));

    var exist1 = await FlutterDriverUtils.isPresent(
        world.driver, find.byValueKey(input1));
    var exist2 = await FlutterDriverUtils.isPresent(
        world.driver, find.byValueKey(input2));
    var exist3 = await FlutterDriverUtils.isPresent(
        world.driver, find.byValueKey(input3));

    expectMatch(exist1, true);
    expectMatch(exist2, true);
    expectMatch(exist3, true);
  }

  @override
  RegExp get pattern =>
      RegExp(r'I have {string} and {string} and {string} widgets');
}

class LoginWhen1 extends When2WithWorld<String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1, String input2) async {
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey(input1), input2);
  }

  @override
  RegExp get pattern => RegExp(r'I fill {string} with {string}');
}

class LoginWhen2 extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey(input1));
  }

  @override
  RegExp get pattern => RegExp(r'I tap {string}');
}

class LoginThen extends Then1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey(input1));
  }

  @override
  RegExp get pattern => RegExp(r'{string} should be shown on page');
}
