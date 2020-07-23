import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() {
    driver?.close();
  });

  test('Test flutter driver health', () async {
    final health = await driver.checkHealth();
    expect(health.status, HealthStatus.ok);
  });

  test('Test first page is splash page', () async {
    //splash page
    await driver.waitFor(find.byValueKey('splash_page'));
    await Future<void>.delayed(Duration(milliseconds: 7000));
    await driver.waitForAbsent(find.byValueKey('splash_page'));

    await driver.waitFor(find.byValueKey('login_page'));
    await driver.tap(find.byValueKey('email_field'));
    await driver.enterText('abc@gmail.com');
    await driver.waitFor(find.text('abc@gmail.com'));
    await driver.tap(find.byValueKey('pwd_field'));
    await driver.enterText('123456');

    await Future<void>.delayed(Duration(milliseconds: 7000));
  });
}
