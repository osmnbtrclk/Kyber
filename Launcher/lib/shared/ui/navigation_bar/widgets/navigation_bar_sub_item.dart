import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class NavigationBarSubItem extends StatefulWidget {
  const NavigationBarSubItem({
    required this.isLast,
    required this.route,
    required this.fullRoute,
    required this.index,
    this.onClick,
    super.key,
  });

  final int index;
  final bool isLast;
  final VoidCallback? onClick;
  final String route;
  final String fullRoute;

  @override
  State<NavigationBarSubItem> createState() => _NavigationBarSubItemState();
}

class _NavigationBarSubItemState extends State<NavigationBarSubItem> {
  bool hover = false;

  @override
  void didChangeDependencies() {
    setState(() => hover = false);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant NavigationBarSubItem oldWidget) {
    setState(() => hover = false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLast) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        alignment: Alignment.center,
        height: 80,
        child: Text(
          widget.route.toUpperCase().replaceAll('_', ' '),
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 18,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: GestureDetector(
        onTap: () {
          if (widget.onClick != null) {
            widget.onClick!();
            return;
          }

          //setState(() => hover = false);
          final subRouteIndex = widget.index;
          final subRoute = router.routeInformationProvider.value.uri
              .toString()
              .split('/')
              .take(subRouteIndex + 2)
              .join('/');

          if (widget.fullRoute.startsWith('/mods')) {
            //TODO: fix
            router.go(widget.fullRoute);
            return;
          }

          while (router
                  .routerDelegate
                  .currentConfiguration
                  .last
                  .matchedLocation !=
              subRoute) {
            if (!router.canPop()) {
              router.go(widget.fullRoute);
              return;
            }

            router.pop();
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (event) => setState(() => hover = true),
          onExit: (event) => setState(() => hover = false),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 100),
            style: TextStyle(
              color: hover ? kActiveColor : kGrayColor,
              fontFamily: FontFamily.battlefrontUI,
              shadows: hover
                  ? [
                      Shadow(
                        color: kActiveColor.withOpacity(.8),
                        blurRadius: 15,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                widget.route.toUpperCase().replaceAll('_', ' '),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
