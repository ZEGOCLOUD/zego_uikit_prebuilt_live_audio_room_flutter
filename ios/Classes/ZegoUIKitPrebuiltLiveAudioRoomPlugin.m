#import "ZegoUIKitPrebuiltLiveAudioRoomPlugin.h"

@implementation ZegoUIKitPrebuiltLiveAudioRoomPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zego_uikit_prebuilt_live_audio_room"
            binaryMessenger:[registrar messenger]];
  ZegoUIKitPrebuiltLiveAudioRoomPlugin* instance = [[ZegoUIKitPrebuiltLiveAudioRoomPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(FlutterMethodNotImplemented);
}

@end
