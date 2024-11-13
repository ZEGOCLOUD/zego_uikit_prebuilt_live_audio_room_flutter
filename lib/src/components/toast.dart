// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_styled_toast/flutter_styled_toast.dart' as styled_toast;

typedef ContextQuery = BuildContext Function();

/// @nodoc
class ZegoLiveAudioRoomToast {
  factory ZegoLiveAudioRoomToast() => instance;

  ZegoLiveAudioRoomToast._internal();
  ContextQuery? contextQuery;
  static final ZegoLiveAudioRoomToast instance =
      ZegoLiveAudioRoomToast._internal();

  TextStyle get textStyle => const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      );

  // ignore: use_setters_to_change_properties
  void init({required ContextQuery contextQuery}) {
    this.contextQuery = contextQuery;
  }

  void show(String message, {Color? backgroundColor}) {
    styled_toast.showToast(
      message,
      duration: const Duration(seconds: 3),
      context: contextQuery?.call(),
      position: styled_toast.StyledToastPosition.top,
      textStyle: textStyle,
      toastHorizontalMargin: 0,
      fullWidth: true,
      backgroundColor: backgroundColor,
    );
  }
}

// ignore: no-empty-block
void showToast(String message) {}

void showDebugToast(String message) {
  if (kDebugMode) {
    ZegoLiveAudioRoomToast.instance.show(message);
  }
}

void showSuccess(String message) {
  ZegoLiveAudioRoomToast.instance
      .show(message, backgroundColor: const Color(0xff55BC9E));
}

void showError(String message) {
  ZegoLiveAudioRoomToast.instance
      .show(message, backgroundColor: const Color(0xffBD5454));
}
