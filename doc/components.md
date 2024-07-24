
## ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage && ZegoUIKitPrebuiltLiveAudioRoomMiniPopScope

> The page can be minimized within the app
> 
> To support the minimize functionality in the app:
> 
> 1. Add a minimize button.
> ```dart
> ZegoUIKitPrebuiltLiveAudioRoomConfig.topMenuBar.buttons.add(ZegoLiveAudioRoomMenuBarButtonName.minimizingButton)
> ```
> Alternatively, if you have defined your own button, you can call:
> ```dart
> ZegoUIKitPrebuiltLiveAudioRoomController().minimize.minimize().
> ```
> 
> 2. Nest the `ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage` within your MaterialApp widget. Make sure to return the correct context in the `contextQuery` parameter.
> 
> How to add in MaterialApp, example:
> ```dart
> 
> void main() {
>   WidgetsFlutterBinding.ensureInitialized();
> 
>   final navigatorKey = GlobalKey<NavigatorState>();
>   runApp(MyApp(
>     navigatorKey: navigatorKey,
>   ));
> }
> 
> class MyApp extends StatefulWidget {
>   final GlobalKey<NavigatorState> navigatorKey;
> 
>   const MyApp({
>     required this.navigatorKey,
>     Key? key,
>   }) : super(key: key);
> 
>   @override
>   State<StatefulWidget> createState() => MyAppState();
> }
> 
> class MyAppState extends State<MyApp> {
>   @override
>   Widget build(BuildContext context) {
>     return MaterialApp(
>       title: 'Flutter Demo',
>       home: const ZegoUIKitPrebuiltLiveAudioRoomMiniPopScope(
>         child: HomePage(),
>       ),
>       navigatorKey: widget.navigatorKey,
>       builder: (BuildContext context, Widget? child) {
>         return Stack(
>           children: [
>             child!,
> 
>             /// support minimizing
>             ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage(
>               contextQuery: () {
>                 return widget.navigatorKey.currentState!.context;
>               },
>             ),
>           ],
>         );
>       },
>     );
>   }
> }
> ```