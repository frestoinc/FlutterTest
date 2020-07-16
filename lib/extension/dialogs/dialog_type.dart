enum DialogType {
  DIALOG_EXIT_APP,
  DIALOG_CONFIRM_DELETE,
}

extension DialogStrings on DialogType {
  String get title {
    switch (this) {
      case DialogType.DIALOG_EXIT_APP:
        return "QUIT APPLICATION";
      case DialogType.DIALOG_CONFIRM_DELETE:
        return "DELETE ENTRY";
      default:
        return null;
    }
  }

  String get message {
    switch (this) {
      case DialogType.DIALOG_EXIT_APP:
        return "Confirm Quit Application?";
      case DialogType.DIALOG_CONFIRM_DELETE:
        return "Continue to delete entry?";
      default:
        return "";
    }
  }

  String get pBtn {
    switch (this) {
      case DialogType.DIALOG_CONFIRM_DELETE:
        return "Yes";
      case DialogType.DIALOG_EXIT_APP:
        return "Delete";
      default:
        return null;
    }
  }

  String get nBtn {
    switch (this) {
      case DialogType.DIALOG_CONFIRM_DELETE:
        return "No";
      case DialogType.DIALOG_EXIT_APP:
        return "Cancel";
      default:
        return null;
    }
  }
}
