
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double perspectiveStrength = 0.001;

  double xTranslation = 0;
  double yTranslation = 0;
  double zTranslation = 0;

  double xAngle = 0;
  double yAngle = 0;
  double zAngle = 0;

  Matrix4 get matrix4 {
    // Convert angles from degrees to radians.
    final x = xAngle * math.pi / 180;
    final y = yAngle * math.pi / 180;
    final z = zAngle * math.pi / 180;

    // Precalculate trigonometric values.
    final cx = math.cos(x);
    final sx = math.sin(x);

    final cy = math.cos(y);
    final sy = math.sin(y);

    final cz = math.cos(z);
    final sz = math.sin(z);

    // Rotation matrix R = Rz * Ry * Rx.
    final r00 = cz * cy;
    final r01 = cz * sy * sx - sz * cx;
    final r02 = cz * sy * cx + sz * sx;

    final r10 = sz * cy;
    final r11 = sz * sy * sx + cz * cx;
    final r12 = sz * sy * cx - cz * sx;

    final r20 = -sy;
    final r21 = cy * sx;
    final r22 = cy * cx;

    // Construct the complete 4x4 matrix directly.
    // Matrix4 constructor arguments are column-major.
    return Matrix4(
      r00, r10, r20, 0,
      r01, r11, r21, 0,
      r02, r12, r22, perspectiveStrength,
      xTranslation,
      yTranslation,
      zTranslation,
      1,
    );
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void resetValues() {
    setState(() {
      xTranslation = 0;
      yTranslation = 0;
      zTranslation = 0;

      xAngle = 0;
      yAngle = 0;
      zAngle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Transform Controls'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: matrix4,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.view_in_ar,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Translation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildSlider(
                      label: 'X Translation',
                      value: xTranslation,
                      min: -200,
                      max: 200,
                      onChanged: (v) =>
                          setState(() => xTranslation = v),
                    ),
                    buildSlider(
                      label: 'Y Translation',
                      value: yTranslation,
                      min: -200,
                      max: 200,
                      onChanged: (v) =>
                          setState(() => yTranslation = v),
                    ),
                    buildSlider(
                      label: 'Z Translation',
                      value: zTranslation,
                      min: -500,
                      max: 500,
                      onChanged: (v) =>
                          setState(() => zTranslation = v),
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Angles (degrees)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildSlider(
                      label: 'X Angle',
                      value: xAngle,
                      min: -180,
                      max: 180,
                      onChanged: (v) =>
                          setState(() => xAngle = v),
                    ),
                    buildSlider(
                      label: 'Y Angle',
                      value: yAngle,
                      min: -180,
                      max: 180,
                      onChanged: (v) =>
                          setState(() => yAngle = v),
                    ),
                    buildSlider(
                      label: 'Z Angle',
                      value: zAngle,
                      min: -180,
                      max: 180,
                      onChanged: (v) =>
                          setState(() => zAngle = v),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: resetValues,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reset all'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
