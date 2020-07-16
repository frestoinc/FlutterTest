import 'package:flutterapp/extension/dialogs/dialog_type.dart';

abstract class DialogListener {
  void onPositiveButtonClicked(DialogType type, dynamic t);

  void onNegativeButtonClicked(DialogType type, dynamic t);
}
