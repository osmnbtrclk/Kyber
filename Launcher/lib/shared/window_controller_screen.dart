import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/core.dart';
import 'package:window_manager/window_manager.dart';

class WindowController extends StatefulWidget {
  const WindowController({required this.child, super.key});

  final Widget child;

  @override
  State<WindowController> createState() => _WindowControllerState();
}

class _WindowControllerState extends State<WindowController>
    with WindowListener {
  @override
  void initState() {
    WindowHelper.completedSetup.future.then((_) async {
      windowManager.addListener(this);
    });
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowMoved() async {
    final position = await windowManager.getPosition();
    Preferences.windowData.windowX = position.dx;
    Preferences.windowData.windowY = position.dy;
    super.onWindowMoved();
  }

  @override
  void onWindowUnmaximize() {
    Preferences.windowData.windowMaximized = false;
    super.onWindowUnmaximize();
  }

  @override
  void onWindowMaximize() {
    Preferences.windowData.windowMaximized = true;
    super.onWindowMaximize();
  }

  @override
  Future<void> onWindowResized() async {
    super.onWindowResize();
    final size = await windowManager.getSize();
    Preferences.windowData.windowHeight = size.height;
    Preferences.windowData.windowWidth = size.width;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
