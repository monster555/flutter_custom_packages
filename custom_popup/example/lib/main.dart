import 'dart:developer';

import 'package:custom_popup/custom_popup.dart';
import 'package:custom_popup_example/time_box_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Popup Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Custom Popup Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);
  String selectedAction = '';

  List<MenuElement> get actions => [
        MenuItem(
          icon: CupertinoIcons.reply,
          label: 'Reply',
          onPressed: () => logAction('Reply'),
        ),
        MenuItem(
          icon: CupertinoIcons.flag,
          label: 'Flag',
          onPressed: () => logAction('Flag'),
        ),
        MenuItem(
          icon: CupertinoIcons.square_on_square,
          label: 'Duplicate',
          onPressed: () => logAction('Duplicate'),
        ),
        const MenuDivider(),
        MenuItem(
          icon: CupertinoIcons.delete,
          label: 'Delete Note',
          isDestructive: true,
          onPressed: () {
            showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            );
            logAction('Delete Note');
          },
        ),
        MenuItem(
          icon: CupertinoIcons.reply,
          label: 'Reply',
          onPressed: () => logAction('Reply'),
        ),
        MenuItem(
          icon: CupertinoIcons.flag,
          label: 'Flag',
          onPressed: () => logAction('Flag'),
        ),
        MenuItem(
          icon: CupertinoIcons.square_on_square,
          label: 'Duplicate',
          onPressed: () => logAction('Duplicate'),
        ),
        const MenuDivider(),
        MenuItem(
          icon: CupertinoIcons.delete,
          label: 'Delete Note',
          isDestructive: true,
          onPressed: () {
            showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            );
            logAction('Delete Note');
          },
        ),
        MenuItem(
          icon: CupertinoIcons.reply,
          label: 'Reply',
          onPressed: () => logAction('Reply'),
        ),
        MenuItem(
          icon: CupertinoIcons.flag,
          label: 'Flag',
          onPressed: () => logAction('Flag'),
        ),
        MenuItem(
          icon: CupertinoIcons.square_on_square,
          label: 'Duplicate',
          onPressed: () => logAction('Duplicate'),
        ),
        const MenuDivider(),
        MenuItem(
          icon: CupertinoIcons.delete,
          label: 'Delete Note',
          isDestructive: true,
          onPressed: () {
            logAction('Delete Note');
            showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            );
          },
        ),
      ];

  void logAction(String action) {
    setState(() {
      selectedAction = action;
    });
    log(action, name: 'action');
  }

  ThemeData get theme => Theme.of(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            TimeBoxBanner(
              startTime: DateTime.now().subtract(const Duration(minutes: 40)),
              endTime: DateTime.now().add(
                const Duration(hours: 1, minutes: 30),
              ),
            ),
            Opacity(
              opacity: 0.4,
              child: TimeBoxWidget(
                startTime: DateTime.now().subtract(const Duration(minutes: 40)),
                endTime: DateTime.now().add(
                  const Duration(hours: 1, minutes: 30),
                ),
                dimension: 220,
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.0),
          ],
        ),
      ),
    );
  }
}
