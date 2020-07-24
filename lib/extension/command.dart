import 'package:rxdart/rxdart.dart';

enum ExternalApplicationCommand {
  reset,
  notificationsDisable,
}

class ExternalApplicationCommandInvoker {
  final Subject<String> commands = BehaviorSubject.seeded('NONE');
  final Map<ExternalApplicationCommand, Future<String> Function()> _handlers =
      <ExternalApplicationCommand, Future<String> Function()>{};

  void addCommandHandler(
    ExternalApplicationCommand command,
    Future<String> Function() handler,
  ) {
    commands.add('Added command for `$command`');
    _handlers[command] = handler;
  }

  Future<String> invokeCommand(ExternalApplicationCommand command) async {
    String result;
    commands.add('Try invoke command `$command`');
    if (_handlers.containsKey(command)) {
      commands.add('Invoking command `$command`');
      result = await _handlers[command]();
      commands.add('Invoked command `$command`');
    }

    return result;
  }
}
