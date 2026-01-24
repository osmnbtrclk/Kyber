import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/tutorial/models/tutorial_container_border.dart';
import 'package:kyber_launcher/features/tutorial/providers/tutorial_cubit.dart';
import 'package:kyber_launcher/features/tutorial/widgets/tutorial_deco_item.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/borders/custom_border.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';

class TutorialStepContent extends StatefulWidget {
  const TutorialStepContent({
    required this.x,
    required this.y,
    required this.h,
    required this.w,
    super.key,
  });

  final double x;
  final double y;
  final double h;
  final double w;

  @override
  State<TutorialStepContent> createState() => _TutorialStepContentState();
}

class _TutorialStepContentState extends State<TutorialStepContent> {
  double x = 0;
  double y = 0;
  double h = 0;
  double w = 0;
  double top = 0;
  double hCard = 0;
  double wCard = 0;

  @override
  void initState() {
    loadPositions();
    start();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(loadPositions);
    super.didChangeDependencies();
  }

  void loadPositions() {
    h = widget.h;
    w = widget.w;
    x = widget.x;
    y = widget.y;
  }

  Future<void> start() async {
    await Future.delayed(Duration.zero, () {
      final box =
          const GlobalObjectKey(
                'pointWidget1234567890',
              ).currentContext!.findRenderObject()!
              as RenderBox;
      setState(() {
        hCard = box.size.height;
        wCard = box.size.width;
      });
    });

    setState(() {
      x = widget.x;
      y = widget.y;
      h = widget.h;
      w = widget.w;

      top = x + h + 24;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorialCubit, TutorialState>(
      builder: (context, state) {
        state as TutorialActive;

        return Positioned(
          left:
              MediaQuery.of(context).size.height >
                  MediaQuery.of(context).size.width
              ? 0
              : x + w < (MediaQuery.of(context).size.width / 2)
              ? h > hCard
                    ? x + w + 8
                    : (x + w * -1) - 8
              : (x < (MediaQuery.of(context).size.width / 2)
                    ? h > hCard
                          ? x + w + wCard > MediaQuery.of(context).size.width
                                ? x - wCard
                                : x - (w / 2) + 8
                          : 0
                    : x - wCard - 16),
          top:
              MediaQuery.of(context).size.height >
                  MediaQuery.of(context).size.width
              ? y + h + hCard + 50 > MediaQuery.of(context).size.height
                    ? y - hCard - 16
                    : y + h + 24
              : y > MediaQuery.of(context).size.height / 2
              ? y - hCard - 16
              : (y + h) < (MediaQuery.of(context).size.height / 2)
              ? y + h > hCard
                    ? y + h + 8
                    : y + h + 8
              : x < (MediaQuery.of(context).size.width / 2)
              ? y
              : y,
          child: SizedBox(
            width: 500,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      width: 500,
                      // todo: maybe change this. can't believe someone put this on pub.dev lmao
                      key: const GlobalObjectKey('pointWidget1234567890'),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomBorder(
                        painter: TutorialContainerBorderPainter(),
                        clipper: TutorialContainerBorderClipper(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //NeonText(),
                              Text(
                                state.tutorial.steps[state.currentStep].title
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: kActiveColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontFamily.battlefrontUI,
                                  shadows: [
                                    Shadow(
                                      color: kActiveColor.withOpacity(.8),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DefaultTextStyle(
                                style: TextStyle(
                                  color: kInactiveColor,
                                  fontSize: 16,
                                  fontFamily: FluentTheme.of(
                                    context,
                                  ).typography.bodyLarge?.fontFamily,
                                ),
                                child: state
                                    .tutorial
                                    .steps[state.currentStep]
                                    .description,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  KyberButton(
                                    onPressed: () =>
                                        context.read<TutorialCubit>().skip(),
                                    text: 'Skip',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  KyberButton(
                                    onPressed: () => context
                                        .read<TutorialCubit>()
                                        .nextStep(),
                                    text: 'Next',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 500 * .115,
                  top: 1,
                  child: TutorialDecoItem(type: 0),
                ),
                const Positioned(
                  left: 500 * .135,
                  top: 1,
                  child: TutorialDecoItem(type: 0),
                ),
                const Positioned(
                  left: 500 * .17,
                  top: 1,
                  child: TutorialDecoItem(type: 1),
                ),
                const Positioned(
                  right: 50,
                  bottom: 35,
                  child: TutorialDecoItem(type: 2),
                ),
                const Positioned(
                  right: 50,
                  bottom: 50,
                  child: TutorialDecoItem(type: 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NeonText extends StatelessWidget {
  const NeonText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'YOUR COLLECTION',
      style: TextStyle(
        fontSize: 40,
        color: kActiveColor,
        shadows: [
          BoxShadow(
            blurRadius: 5,
            color: kActiveColor.withOpacity(.7),
          ),
          BoxShadow(
            blurRadius: 7,
            color: kActiveColor.withOpacity(.4),
          ),
          BoxShadow(
            blurRadius: 10,
            color: kActiveColor.withOpacity(.7),
            spreadRadius: 5,
          ),
          BoxShadow(
            blurRadius: 7,
            color: kActiveColor.withOpacity(.4),
          ),
          BoxShadow(
            blurRadius: 10,
            color: kActiveColor.withOpacity(.7),
            spreadRadius: 5,
          ),
          BoxShadow(
            blurRadius: 7,
            color: kActiveColor.withOpacity(.4),
          ),
          BoxShadow(
            blurRadius: 10,
            color: kActiveColor.withOpacity(.7),
            spreadRadius: 5,
          ),
          BoxShadow(
            blurRadius: 7,
            color: kActiveColor.withOpacity(.4),
          ),
          BoxShadow(
            blurRadius: 10,
            color: kActiveColor.withOpacity(.7),
            spreadRadius: 5,
          ),
          BoxShadow(
            blurRadius: 7,
            color: kActiveColor.withOpacity(.4),
          ),
          BoxShadow(
            blurRadius: 10,
            color: kActiveColor.withOpacity(.7),
            spreadRadius: 5,
          ),
          BoxShadow(
            blurRadius: 7,
            color: kActiveColor.withOpacity(.4),
          ),
          BoxShadow(
            blurRadius: 10,
            color: kActiveColor.withOpacity(.7),
            spreadRadius: 5,
          ),
        ],
      ),
    );
  }
}
