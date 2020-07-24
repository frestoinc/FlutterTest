import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class LoginTest {
  static Iterable<StepDefinitionGeneric> STEPS = [
    InSpecificPage(),
    WidgetExists(),
    WidgetNotExists(),
    InputTextField(),
    TapAction(),
    VerifyByText(),
    VerifyByWidget(),
  ];

  static StepDefinitionGeneric InSpecificPage() {
    return when1<String, FlutterWorld>(RegExp(r'user is at {string}'),
        (input1, context) async {
      await FlutterDriverUtils.waitUntil(
          context.world.driver,
          () => FlutterDriverUtils.isPresent(
              context.world.driver, find.byValueKey(input1)),
          timeout: Duration(seconds: 7));
    });
  }

  static StepDefinitionGeneric WidgetExists() {
    return given1<String, FlutterWorld>(RegExp(r'a {string} widget'),
        (input1, context) async {
      var exist1 = await FlutterDriverUtils.isPresent(
          context.world.driver, find.byValueKey(input1));

      context.expectMatch(exist1, true);
    });
  }

  static StepDefinitionGeneric WidgetNotExists() {
    return given1<String, FlutterWorld>(RegExp(r'{string} is detach'),
        (input1, context) async {
      var exist1 = await FlutterDriverUtils.isAbsent(
          context.world.driver, find.byValueKey(input1),
          timeout: Duration(seconds: 4));

      context.expectMatch(exist1, true);
    });
  }

  static StepDefinitionGeneric InputTextField() {
    return when2<String, String, FlutterWorld>(
      RegExp(r'user enter {string} in {string}'),
      (input1, input2, context) async {
        await FlutterDriverUtils.enterText(
            context.world.driver, find.byValueKey(input2), input1);
      },
    );
  }

  static StepDefinitionGeneric TapAction() {
    return when1<String, FlutterWorld>(RegExp(r'user tap {string}'),
        (input1, context) async {
      await FlutterDriverUtils.tap(
          context.world.driver, find.byValueKey(input1));
    });
  }

  static StepDefinitionGeneric VerifyByText() {
    return then1<String, FlutterWorld>(RegExp(r'{string} should show'),
            (input1, context) async {
          await Future<void>.delayed(Duration(seconds: 3));
          var exist = await FlutterDriverUtils.isPresent(
              context.world.driver, find.text(input1));
          context.expectMatch(exist, true);
        });
  }

  static StepDefinitionGeneric VerifyByWidget() {
    return then1<String, FlutterWorld>(
        RegExp(r'{string} should show on screen'), (input1, context) async {
      await Future<void>.delayed(Duration(seconds: 3));
      var exist = await FlutterDriverUtils.isPresent(
          context.world.driver, find.byValueKey(input1));
      context.expectMatch(exist, true);
    });
  }
}

///sample
class LoginWhen1 extends When2WithWorld<String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1, String input2) async {
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey(input2), input1);
  }

  @override
  RegExp get pattern => RegExp(r'user enter {string} in {string}');
}
