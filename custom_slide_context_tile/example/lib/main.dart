import 'dart:developer';

import 'package:custom_slide_context_tile/custom_slide_context_tile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CustomSlideContextTile Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void logAction(String action) => log(action, name: 'action');

  late CustomSlidableController controller;

  @override
  void initState() {
    super.initState();
    controller = CustomSlidableController();
  }

  List<MenuAction> get leadingActions => [
        MenuAction(
          onPressed: () => logAction('Home'),
          icon: Icons.home,
          label: 'Home',
          backgroundColor: Colors.green,
        ),
        MenuAction(
          icon: Icons.delete,
          // Action when button is pressed
          onPressed: () => logAction('Delete'),
          label: 'Delete',
          backgroundColor: Colors.blue,
        ),
        MenuAction(
          icon: Icons.refresh,
          // Action when button is pressed
          onPressed: () => logAction('Update'),
          label: 'Update',
          backgroundColor: Colors.yellow,
        ),
        MenuAction(
          icon: Icons.delete,
          // Action when button is pressed
          onPressed: () => log('Leading action executed'),
          label: 'Delete',
          backgroundColor: Colors.red,
        ),
      ];

  List<MenuAction> get trailingActions => [
        MenuAction(
          icon: Icons.person,
          // Action when button is pressed
          onPressed: () => logAction('Person'),
          label: 'Person',
          backgroundColor: Colors.green,
        ),
        MenuAction(
          icon: Icons.copy,
          // Action when button is pressed
          onPressed: () => logAction('Copy'),
          label: 'Copy',
          backgroundColor: Colors.blue,
        ),
        MenuAction(
          icon: Icons.replay,
          // Action when button is pressed
          onPressed: () => logAction('Replay'),
          label: 'Replay',
          backgroundColor: Colors.yellow,
        ),
        MenuAction(
          icon: Icons.delete,
          // Action when button is pressed
          onPressed: () => log('Trailing action executed'),
          label: 'Delete',
          backgroundColor: Colors.red,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: controller.openLeading,
                  child: const Text('Leading'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: controller.openTrailing,
                  child: const Text('Trailing'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: controller.close,
                  child: const Text('Close'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            CustomSlideContextTile(
              controller: controller,
              leadingActions: [leadingActions.last],
              trailingActions: trailingActions.take(3).toList(),
              revealAnimationType: RevealAnimationType.parallax,
              title: const Text('Swipe me'),
              onTap: () => logAction('Parallax tapped...'),
            ),
            const SizedBox(height: 8.0),
            CustomSlideContextTile(
              leadingActions: leadingActions,
              trailingActions: trailingActions,
              revealAnimationType: RevealAnimationType.pull,
              title: const Text('Swipe me'),
              subtitle: const Text('Subtitle'),
            ),
            const SizedBox(height: 8.0),
            CustomSlideContextTile(
              leadingActions: leadingActions,
              revealAnimationType: RevealAnimationType.reveal,
              title: const Text('Swipe me, no trailing actions'),
            ),
            ...List<Widget>.generate(
              15,
              (e) => CustomSlideContextTile(
                leadingActions: leadingActions,
                trailingActions: trailingActions,
                revealAnimationType: RevealAnimationType.reveal,
                title: const Text('Swipe'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
