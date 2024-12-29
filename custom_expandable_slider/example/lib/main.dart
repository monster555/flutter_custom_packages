import 'package:custom_expandable_slider/custom_expandable_slider.dart';
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
      home: const CustomExpandableSliderHomePage(),
    );
  }
}

class CustomExpandableSliderHomePage extends StatelessWidget {
  const CustomExpandableSliderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No thumb, no haptics'),
            const SizedBox(height: 8.0),
            CustomExpandableSlider(
              width: 250,
              height: 24,
              initialValue: 0.5,
              showThumb: false,
              enableHaptics: false,
              onProgressChanged: (value) => debugPrint('Value changed: $value'),
            ),
            const SizedBox(height: 16.0),
            Text('With thumb'),
            const SizedBox(height: 8.0),
            CustomExpandableSlider.withThumb(
              width: 250,
              height: 24,
              initialValue: 0.5,
              onProgressChanged: (value) => debugPrint('Value changed: $value'),
            ),
          ],
        ),
      ),
    );
  }
}
