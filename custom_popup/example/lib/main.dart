import 'dart:developer';

import 'package:custom_popup/custom_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(const MyApp());

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
          onPressed: () => logAction('Delete Note'),
        ),
      ];

  void logAction(String action) {
    setState(() {
      selectedAction = action;
    });
    log(action, name: 'action');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPopup.menu(
              actions: actions,
              child: const Icon(Icons.settings),
            ),
            const SizedBox(height: 16.0),
            Text(selectedAction),
          ],
        ),
      ),
    );
  }
}
