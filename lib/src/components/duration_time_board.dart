import 'dart:async';

// Package imports:
import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/core/live_duration_manager.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/live_audio_room_config.dart';

/// @nodoc
class ColoredText extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double? fontSize;
  final double verticalPadding;
  final double horizontalPadding;

  const ColoredText({
    Key? key,
    required this.text,
    required this.backgroundColor,
    this.fontSize,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize ?? 25.zR,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Container(
      width: textPainter.width + horizontalPadding * 2,
      height: textPainter.height + verticalPadding * 2,
      margin: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: fontSize ?? 25.zR,
            ),
          ),
        ),
      ),
    );
  }
}

/// @nodoc
class LiveDurationTimeBoard extends StatefulWidget {
  final ZegoLiveDurationConfig config;
  final ZegoLiveDurationManager manager;

  final double? fontSize;

  const LiveDurationTimeBoard({
    Key? key,
    required this.config,
    required this.manager,
    this.fontSize,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CallDurationTimeBoardState();
}

/// @nodoc
class CallDurationTimeBoardState extends State<LiveDurationTimeBoard> {
  Timer? durationTimer;
  Duration? beginDuration;
  var durationNotifier = ValueNotifier<Duration>(Duration.zero);

  @override
  void initState() {
    super.initState();

    if (widget.config.isVisible) {
      ZegoLoggerService.logInfo(
        'init duration',
        tag: 'live audio room',
        subTag: 'prebuilt',
      );

      if (widget.manager.isValid) {
        startDurationTimer();
      } else {
        widget.manager.notifier.addListener(onLiveDurationManagerValueChanged);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    durationTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.isVisible) {
      return Container();
    }

    return ValueListenableBuilder<Duration>(
      valueListenable: durationNotifier,
      builder: (context, elapsedTime, _) {
        if (!widget.manager.isValid) {
          return Container();
        }

        return elapsedTime.inSeconds <= 0
            ? Container()
            : Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Colors.transparent,
                    ),
                  ),
                  Center(
                    child: ColoredText(
                      text: durationFormatString(elapsedTime),
                      fontSize: widget.fontSize ?? 25.zR,
                      backgroundColor: Colors.black.withOpacity(0.2),
                      horizontalPadding: 20.zR,
                      verticalPadding: 5.zR,
                    ),
                  ),
                ],
              );
      },
    );
  }

  String durationFormatString(Duration elapsedTime) {
    final hours = elapsedTime.inHours;
    final minutes = elapsedTime.inMinutes.remainder(60);
    final seconds = elapsedTime.inSeconds.remainder(60);

    final minutesFormatString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return hours > 0
        ? '${hours.toString().padLeft(2, '0')}:$minutesFormatString'
        : minutesFormatString;
  }

  void onLiveDurationManagerValueChanged() {
    if (widget.manager.isValid) {
      startDurationTimer();
    }
  }

  void startDurationTimer() {
    final networkTimestamp = ZegoUIKit().getNetworkTimeStamp();
    beginDuration = DateTime.fromMillisecondsSinceEpoch(networkTimestamp)
        .difference(widget.manager.notifier.value);

    durationTimer?.cancel();
    durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationNotifier.value = beginDuration! + Duration(seconds: timer.tick);
      widget.config.onDurationUpdate?.call(durationNotifier.value);
    });
  }
}
