import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/shared/ui/webview/iframe.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/main.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ModDescription extends StatefulWidget {
  const ModDescription({
    required this.description,
    super.key,
  });

  final String description;

  @override
  State<ModDescription> createState() => _ModDescriptionState();
}

class _ModDescriptionState extends State<ModDescription> {
  // late String previousDescription;
  String? des;
  bool rendering = false;

  //@override
  //void initState() {
  //  previousDescription = widget.description;
  //  flutterJs!.evaluateAsync('convertBBCode(${jsonEncode(widget.description ?? '')})').then((value) {
  //    setState(() {
  //      des = value.stringResult;
  //    });
  //  });
  //  super.initState();
  //}

  //@override
  //void didChangeDependencies() {
  //  if (widget.description != previousDescription && widget.description.isNotEmpty) {
  //    previousDescription = widget.description;
  //    flutterJs!.evaluateAsync('convertBBCode(${jsonEncode(widget.description ?? '')})').then((value) {
  //      setState(() {
  //        des = value.stringResult;
  //      });
  //    });
  //  }
  //  super.didChangeDependencies();
  //}

  @override
  Widget build(BuildContext context) {
    if (widget.description.isNotEmpty && des == null && !rendering) {
      rendering = true;
      flutterJs!
          .evaluateAsync(
            'convertBBCode(${jsonEncode(widget.description ?? '')})',
          )
          .then((value) {
            setState(() {
              des = value.stringResult;
            });
          });
    }

    if (des == null) {
      return const Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: ProgressRing(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: HtmlWidget(
        des!,
        enableCaching: false,
        customStylesBuilder: (element) {
          if (element.classes.contains('center')) {
            return {'align': 'center', 'text-align': 'center'};
          }

          if (element.classes.contains('underline')) {
            return {'text-decoration': 'underline'};
          }

          if (element.styles.any(
            (element) => element.property == 'font-size',
          )) {
            final input = element.styles
                .firstWhere((e) => e.property == 'font-size')
                .value!
                .span!
                .text;
            final value = double.parse(input.replaceAll('rem', ''));
            return {'font-size': '${value * 21}px'};
          }

          return null;
        },
        onLoadingBuilder: (context, element, loadingProgress) {
          return Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: ProgressRing(
                value: (loadingProgress ?? 0) * 100,
              ),
            ),
          );
        },
        customWidgetBuilder: (element) {
          // TODO: implement tooltip. this shit doesn't work
          if (element.localName == 'youtube') {
            return SizedBox(
              height: 338,
              width: 600,
              child: Iframe(
                url:
                    'https://www.youtube-nocookie.com/embed/${element.innerHtml}?modestbranding=1&rel=0&fs=0',
              ),
            );
          }

          if (element.localName == 'a') {
            final href = element.attributes['href'];
            if (href != null) {
              return InlineCustomWidget(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  hitTestBehavior: HitTestBehavior.translucent,
                  opaque: false,
                  child: GestureDetector(
                    onTap: () {
                      if (href.startsWith(
                        'https://www.nexusmods.com/starwarsbattlefront22017/mods/',
                      )) {
                        router.push(
                          "/mods/mod_browser/${href.split("/").last}",
                        );
                      } else if (href.startsWith(
                            'https://www.nexusmods.com/starwarsbattlefront22017/users/',
                          ) ||
                          href.startsWith('https://www.nexusmods.com/users/')) {
                        router.push(
                          "/mods/mod_browser/users/${href.split("/").last}",
                        );
                      } else {
                        launchUrlString(href);
                      }
                    },
                    child: Tooltip(
                      message: href,
                      style: TooltipThemeData(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 50),
                          border: kDefaultAllBorder,
                          borderRadius: BorderRadius.circular(
                            kDefaultInnerBorderRadius,
                          ),
                        ),
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: FontFamily.iBMPlexMono,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      child: Text(
                        element.text,
                        style: TextStyle(
                          color: kActiveColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          return null;
        },
        //onTapUrl: (link) {
        //  if (link.startsWith('https://www.nexusmods.com/starwarsbattlefront22017/mods/')) {
        //    router.push("/mods/mod_browser/${link.split("/").last}");
        //    return true;
        //  }
        //
        //  if (link.startsWith('https://www.nexusmods.com/starwarsbattlefront22017/users/')) {
        //    router.push("/mods/mod_browser/users/${link.split("/").last}");
        //    return true;
        //  }
        //
        //  return false;
        //},
      ),
    );
  }
}
