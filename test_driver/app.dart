import 'package:flutter_driver/driver_extension.dart';
import 'package:flutterapp/extension/command.dart';
import 'package:flutterapp/main.dart' as app;

void main() {
  final commandRunner = ExternalApplicationCommandInvoker();
  enableFlutterDriverExtension(handler: (request) async {
    String result;
    print('************ RUNNING COMMAND: $request');

    if (request == 'APP:RESET') {
      result =
          await commandRunner.invokeCommand(ExternalApplicationCommand.reset);
    }

    return result;
  });

  ///remove commandRunner if don't wish to reset on every run
  app.main(commandRunner);
}
