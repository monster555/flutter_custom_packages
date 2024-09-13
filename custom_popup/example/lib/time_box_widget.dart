import 'dart:async';
import 'dart:math';

import 'package:custom_popup/custom_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension DateTimeX on DateTime {
  double toRadians() => ((hour % 12) * 30 + minute * 0.5) * pi / 180 - pi / 2;

  /// Returns a string in the format of "MM/DD/YYYY"
  String get formattedDate {
    return '$_monthName, $day';
  }

  /// Returns a string in the format of "HH:MM AM/PM"
  String get formattedTime {
    int hour = this.hour;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$hour:${minute.toString().padLeft(2, '0')} $amPm';
  }

  String get _monthName {
    late String monthName;
    switch (month) {
      case 1:
        monthName = 'January';
      case 2:
        monthName = 'February';
      case 3:
        monthName = 'March';
      case 4:
        monthName = 'April';
      case 5:
        monthName = 'May';
      case 6:
        monthName = 'June';
      case 7:
        monthName = 'July';
      case 8:
        monthName = 'August';
      case 9:
        monthName = 'September';
      case 10:
        monthName = 'October';
      case 11:
        monthName = 'November';
      case 12:
        monthName = 'December';
      default:
        return '';
    }
    return monthName.substring(0, 3);
  }
}

extension DurationX on Duration {
  String get formattedDuration => '$inHours hours';
}

extension IntX on int {
  double toRadians() => this * pi / 180;
}

class TimeBoxBanner extends StatefulWidget {
  final DateTime startTime;
  final DateTime endTime;

  const TimeBoxBanner({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<TimeBoxBanner> createState() => _TimeBoxBannerState();
}

class _TimeBoxBannerState extends State<TimeBoxBanner> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.bottomLeft,
          begin: Alignment.topRight,
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                now.formattedDate,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              Text(
                now.formattedTime,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TimeBoxWidget(
                startTime: widget.startTime,
                endTime: widget.endTime,
              ),
              const SizedBox(height: 8.0),

              CustomPopup.menu(
                actions: [
                  MenuItem(
                    icon: CupertinoIcons.chevron_back,
                    label: 'Previous Time Box',
                    onPressed: () {},
                  ),
                  MenuItem(
                    icon: CupertinoIcons.chevron_forward,
                    label: 'Next Time Box',
                    onPressed: () {},
                  )
                ],
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _formatTime(widget.startTime),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        text:
                            ' (${widget.endTime.difference(widget.startTime).formattedDuration})',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              // Text(
              //   '${_formatTime(startTime)} (${endTime.difference(startTime).formattedDuration})',
              //   style: const TextStyle(color: Colors.white),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')}${time.hour >= 12 ? 'pm' : 'am'}';
  }
}

class TimeBoxWidget extends StatelessWidget {
  const TimeBoxWidget({
    required this.startTime,
    required this.endTime,
    this.dimension = 80.0,
    super.key,
  });

  final DateTime startTime;
  final DateTime endTime;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          size: Size(dimension, dimension),
          painter: PieChartPainter(
            startTime: startTime,
            endTime: endTime,
          ),
        ),
        _buildCurrentTimeIndicator(),
        ..._buildTicks(context),
      ],
    );
  }

  Widget _buildCurrentTimeIndicator() {
    DateTime now = DateTime.now();
    double angle = now.toRadians();

    double radius = dimension / 2; // Half of the CustomPaint size
    double x = radius * cos(angle);
    double y = radius * sin(angle);

    return Positioned(
      left: radius + x - 5, // Center + x offset - half of circle size
      top: radius + y - 5, // Center + y offset - half of circle size
      child: const AnimatedSunWidget(),
    );
  }

  List<Widget> _buildTicks(BuildContext context) {
    final list = List<double>.generate(4, (i) => i * 3 * 30);

    double radius = dimension / 2; // Half of the CustomPaint size

    return list.map((angle) {
      double x = radius * cos(angle * pi / 180);
      double y = radius * sin(angle * pi / 180);
      return Positioned(
        // Center + x offset - half of circle size
        left: radius + x - (dimension / 40),
        // Center + y offset - half of circle size
        top: radius + y - (dimension / 40),
        child: Transform.rotate(
          angle: angle * pi / 180,
          child: Container(
            width: dimension / 20,
            height: dimension / 20,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class PieChartPainter extends CustomPainter {
  final DateTime startTime;
  final DateTime endTime;

  PieChartPainter({required this.startTime, required this.endTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Draw full circle
    final fullCirclePaint = Paint()
      ..color = Colors.blue[800]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fullCirclePaint);

    // // Draw outer stroke
    // final strokePaint = Paint()
    //   ..color = Colors.white
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3;
    // canvas.drawCircle(center, radius, strokePaint);

    // Draw time range segment
    final segmentPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.fill;

    double startAngle = startTime.toRadians();
    double endAngle = endTime.toRadians();
    double sweepAngle = endAngle - startAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true,
      segmentPaint,
    );

    // // Draw time range segment (stroke)
    // final segmentStrokePaint = Paint()
    //   ..color = Colors.white70
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3;

    // canvas.drawArc(
    //   Rect.fromCircle(center: center, radius: radius),
    //   startAngle,
    //   sweepAngle,
    //   true,
    //   segmentStrokePaint,
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AnimatedSunWidget extends StatefulWidget {
  const AnimatedSunWidget({super.key});

  @override
  State<AnimatedSunWidget> createState() => _AnimatedSunWidgetState();
}

class _AnimatedSunWidgetState extends State<AnimatedSunWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCirc,
    ).drive(Tween<double>(begin: 0.6, end: 1.2));

    controller
      ..forward()
      ..addListener(() {
        // Make the animation back and forth
        if (controller.status.isCompleted) {
          controller.reverse();
        } else if (controller.status.isDismissed) {
          controller.forward();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ScaleTransition(
          scale: animation,
          child: child!,
        );
      },
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
