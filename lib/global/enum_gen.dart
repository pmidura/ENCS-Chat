enum StatusMediaTypes {
  textActivity,
  imageActivity,
}

enum ConnectionStateName {
  connect,
  pending,
  accept,
  connected,
}

extension ConnStateNamePL on ConnectionStateName {
  String get value {
    switch (this) {
      case ConnectionStateName.connect:
        return 'Połącz';
      case ConnectionStateName.pending:
        return 'W toku';
      case ConnectionStateName.accept:
        return 'Akceptuj';
      case ConnectionStateName.connected:
        return 'Połączono';
      default:
        return '';
    }
  }
}

enum ConnectionStateType {
  buttonNameWidget,
  buttonBorderColor,
  buttonOnlyName,
}

enum OtherConnectionStatus {
  requestPending,
  invitationCame,
  invitationAccepted,
  requestAccepted,
}

enum ImageProviderCategory {
  fileImage,
  exactAssetImage,
  networkImage,
}

enum ChatMessageTypes {
  none,
  text,
  image,
  video,
  document,
  audio,
}
