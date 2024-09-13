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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  void logAction(String action) {
    log(action, name: 'action');
  }

  late CustomSlidableController controller;
  late SlidableManager manager;

  @override
  void initState() {
    super.initState();
    controller = CustomSlidableController();
    manager = SlidableManager();
  }

  List<MenuAction> get leadingActions => [
        MenuAction(
          onPressed: () {},
          icon: Icons.home,
          label: 'Home',
          backgroundColor: Colors.green,
        ),
        MenuAction(
          icon: Icons.delete,
          onPressed: () {
            // Action when button is pressed
          },
          label: 'Delete',
          backgroundColor: Colors.blue,
        ),
        MenuAction(
          icon: Icons.home,
          onPressed: () {
            // Action when button is pressed
          },
          label: 'Replay',
          backgroundColor: Colors.yellow,
        ),
        MenuAction(
          icon: Icons.delete,
          onPressed: () {
            // Action when button is pressed
            log('Leading action executed');
          },
          label: 'Delete',
          backgroundColor: Colors.red,
        ),
      ];

  List<MenuAction> get trailingActions => [
        MenuAction(
          icon: Icons.person,
          onPressed: () {
            // Action when button is pressed
            controller.openLeading();
          },
          label: 'Person',
          backgroundColor: Colors.green,
        ),
        MenuAction(
          icon: Icons.copy,
          onPressed: () {
            // Action when button is pressed
          },
          label: 'Copy',
          backgroundColor: Colors.blue,
        ),
        MenuAction(
          icon: Icons.replay,
          onPressed: () {
            // Action when button is pressed
            logAction('Replay');
          },
          label: 'Replay',
          backgroundColor: Colors.yellow,
        ),
        MenuAction(
          icon: Icons.delete,
          onPressed: () {
            // Action when button is pressed
            log('Trailing action executed');
          },
          // label: 'Delete',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: controller.openLeading,
            //       child: const Text('Open Leading 2'),
            //     ),
            //     const SizedBox(width: 8.0),
            //     ElevatedButton(
            //       onPressed: controller.openTrailing,
            //       child: const Text('Open Trailing 2'),
            //     ),
            //     const SizedBox(width: 8.0),
            //     ElevatedButton(
            //       onPressed: controller.close,
            //       child: const Text('Close 2'),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16.0),
            CustomSlideContextTile.withContextMenu(
              controller: controller,
              manager: manager,
              leadingActions: leadingActions,
              trailingActions: trailingActions,
              revealAnimationType: RevealAnimationType.parallax,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: ListTile(
                  title: Text(
                    'Swipe me Parallax',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            CustomSlideContextTile.withContextMenu(
              manager: manager,
              leadingActions: leadingActions,
              trailingActions: trailingActions,
              revealAnimationType: RevealAnimationType.pull,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: ListTile(
                  title: Text(
                    'Swipe me Pull',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            CustomSlideContextTile.withContextMenu(
              manager: manager,
              leadingActions: leadingActions,
              // trailingActions: trailingActions,
              revealAnimationType: RevealAnimationType.reveal,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: ListTile(
                  title: Text(
                    'Swipe me Reveal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
