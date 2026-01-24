import 'package:fixnum/fixnum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:grpc/grpc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/default_dialog.dart';
import 'package:kyber_launcher/shared/ui/elements/dropdown/kyber_dropdown.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_highlight.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_segmented_control.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

final _prewrittenReasons = <ReportReason, String>{
  ReportReason.TOXIC_BEHAVIOUR:
      'Violation of ToS: You will not engage in harassment, unwelcome communication, hate speech, or other harmful behavior towards other users or our team. If you believe this is a mistake, please contact contact@kyber.gg.',
  ReportReason.HACKING:
      'Violation of ToS: You will not use cheats, bots, or unauthorized tools to gain an unfair advantage. If you believe this is a mistake, please contact contact@kyber.gg',
  ReportReason.GRIEFING:
      'Violation of ToS: You will not engage in harassment, unwelcome communication, hate speech, or other harmful behavior towards other users or our team. If you believe this is a mistake, please contact contact@kyber.gg.',
  ReportReason.OTHER:
      'Violation of ToS. If you believe this is a mistake, please contact contact@kyber.gg.',
};

class ReportPunishmentDialog extends StatefulWidget {
  const ReportPunishmentDialog({
    required this.target,
    required this.initialReason,
    super.key,
  });

  final ServerPlayer target;
  final ReportReason initialReason;

  @override
  State<ReportPunishmentDialog> createState() => _ReportPunishmentDialogState();
}

class _ReportPunishmentDialogState extends State<ReportPunishmentDialog> {
  late ReportReason selectedReportReason;
  bool permanent = false;
  Duration duration = const Duration(days: 7);
  TextEditingController reasonController = TextEditingController();
  int durationIndex = 0;

  @override
  void initState() {
    selectedReportReason = widget.initialReason;
    reasonController.text = _prewrittenReasons[widget.initialReason] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContentDialog(
      title: Text('TAKE ACTION'.toUpperCase()),
      description: const Text('BAN A PLAYER'),
      constraints: const BoxConstraints(
        maxWidth: 700,
        maxHeight: 600,
      ),
      actions: [
        KyberButton(
          text: 'CANCEL',
          onPressed: () => Navigator.of(context).pop(),
        ),
        KyberButton(
          text: 'BAN',
          onPressed: () {
            final request = ApproveReportsRequest(
              banDuration: Int64(permanent ? 0 : duration.inSeconds),
              banMessage: reasonController.text,
              playerId: widget.target.id,
            );

            sl
                .get<KyberGRPCService>()
                .reportServiceClient
                .approveReports(request)
                .then((value) {
                  NotificationService.success(
                    message: 'Player banned successfully',
                  );
                  Navigator.of(context).pop();
                })
                .catchError((error) {
                  NotificationService.error(
                    message:
                        'Failed to ban player: ${error is GrpcError ? error.message : error.toString()}',
                  );
                });
          },
        ),
      ],
      content: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        children: [
          const Text('REPORT USER'),
          const SizedBox(height: 5),
          ButtonBuilder(
            builder: (context, hovered) {
              return AnimatedContainer(
                height: 50,
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: hovered ? kActiveColor : decoColor,
                    width: 2,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: const TextStyle(
                    color: kWhiteColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Assets.logos.kyberLight.svg(
                                color: kWhiteColor,
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.target.name,
                                style: const TextStyle(
                                  fontFamily: FontFamily.battlefrontUI,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onClick: () async {},
          ),
          const SizedBox(height: 15),
          const Row(
            spacing: 5,
            children: [
              Text('SELECT A REASON FOR REPORTING'),
              KyberHighlight(body: 'REQUIRED'),
            ],
          ),
          const SizedBox(height: 5),
          KyberDropdown<ReportReason>(
            items: ReportReason.values
                .map(
                  (e) => DropdownItem<ReportReason>(
                    label: e.name.replaceAll('_', ' '),
                    value: e,
                  ),
                )
                .toList(),
            selectedItem: selectedReportReason,
            onChanged: (value) {
              setState(() => selectedReportReason = value);
              reasonController.text = _prewrittenReasons[value] ?? '';
            },
            itemBuilder: (item) => Container(
              alignment: Alignment.centerLeft,
              height: 35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: FontFamily.battlefrontUI,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            spacing: 5,
            children: [
              Text('ADD COMMENTS'),
              KyberHighlight(body: 'REQUIRED'),
            ],
          ),
          const SizedBox(height: 5),
          mt.TextFormField(
            style: const TextStyle(
              color: kWhiteColor,
              fontFamily: FontFamily.battlefrontUI,
              height: 1,
            ),
            maxLines: 4,
            minLines: 4,
            controller: reasonController,
            decoration: mt.InputDecoration(
              hintText: 'Enter a ban reason'.toUpperCase(),
              hintStyle: const TextStyle(
                color: kInactiveColor,
                fontFamily: FontFamily.battlefrontUI,
                fontSize: 15,
                height: 1,
              ),
              isDense: true,
              fillColor: Colors.black.withOpacity(.6),
              focusColor: Colors.black.withOpacity(.6),
              hoverColor: Colors.black.withOpacity(.6),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13.5,
              ),
              enabledBorder: const mt.OutlineInputBorder(
                borderSide: BorderSide(color: decoColor, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(kDefaultInnerBorderRadius),
                ),
              ),
              focusedBorder: mt.OutlineInputBorder(
                borderSide: BorderSide(color: kActiveColor, width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(kDefaultInnerBorderRadius),
                ),
              ),
            ),
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) {
                  return Text(
                    '$currentLength / $maxLength',
                    style: const TextStyle(
                      fontFamily: FontFamily.battlefrontUI,
                      fontSize: 14,
                      color: kInactiveColor,
                    ),
                  );
                },
            maxLength: 500,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 15),
          InfoLabel(
            label: 'BAN TYPE',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KyberSegmentedControl<bool>(
                  selectedIndex: permanent ? 1 : 0,
                  items: const [
                    KyberSegmentedControlItem(title: 'Temporary', value: false),
                    KyberSegmentedControlItem(title: 'Permanent', value: true),
                  ],
                  onSelected: (index) => setState(() => permanent = index == 1),
                ),
              ],
            ),
          ),
          if (!permanent) ...[
            const SizedBox(height: 15),
            InfoLabel(
              label: 'BAN DURATION',
              child: KyberSegmentedControl<Duration>(
                selectedIndex: durationIndex,
                items: const [
                  KyberSegmentedControlItem(
                    title: '1 Week',
                    value: Duration(days: 7),
                  ),
                  KyberSegmentedControlItem(
                    title: '2 Weeks',
                    value: Duration(days: 14),
                  ),
                  KyberSegmentedControlItem(
                    title: '1 Month',
                    value: Duration(days: 30),
                  ),
                  KyberSegmentedControlItem(
                    title: '3 Months',
                    value: Duration(days: 90),
                  ),
                  KyberSegmentedControlItem(
                    title: 'Custom',
                    value: Duration.zero,
                  ),
                ],
                onSelected: (index) => setState(
                  () {
                    if (index == 4) {
                      mt
                          .showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            initialDate: DateTime.now(),
                            barrierColor: Colors.black,
                          )
                          .then((value) {
                            if (value != null) {
                              duration = value.difference(DateTime.now());
                              durationIndex = 4;
                              NotificationService.info(
                                message:
                                    'Custom duration set to ${duration.inDays} days',
                              );
                            } else {
                              durationIndex = 0;
                              duration = const Duration(days: 7);
                            }
                            setState(() => null);
                          });
                    } else {
                      duration = [
                        const Duration(days: 7),
                        const Duration(days: 14),
                        const Duration(days: 30),
                        const Duration(days: 90),
                        const Duration(days: 180),
                      ][index];
                      setState(() {
                        durationIndex = index;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
