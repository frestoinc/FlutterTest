enum DialogType {
  DIALOG_EXIT_APP,
  DIALOG_CONFIRM_DELETE,
}

extension DialogStrings on DialogType {
  String get title {
    switch (this) {
      case DialogType.DIALOG_EXIT_APP:
        return 'QUIT APPLICATION';
      case DialogType.DIALOG_CONFIRM_DELETE:
        return 'DELETE ENTRY';
      default:
        return '';
    }
  }

  String get message {
    switch (this) {
      case DialogType.DIALOG_EXIT_APP:
        return 'Confirm Quit Application?';
      case DialogType.DIALOG_CONFIRM_DELETE:
        return 'Continue to delete entry?';
      default:
        return '';
    }
  }

  String get pBtn {
    switch (this) {
      case DialogType.DIALOG_CONFIRM_DELETE:
        return 'Delete';
      case DialogType.DIALOG_EXIT_APP:
        return 'Yes';
      default:
        return '';
    }
  }

  String get nBtn {
    switch (this) {
      case DialogType.DIALOG_CONFIRM_DELETE:
        return 'Cancel';
      case DialogType.DIALOG_EXIT_APP:
        return 'No';
      default:
        return '';
    }
  }
}
