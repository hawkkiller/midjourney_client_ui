import 'package:flutter/material.dart';
import 'package:midjourney_client_ui/src/core/utils/extensions/context_extension.dart';

class SettingsCategory extends StatelessWidget {
  const SettingsCategory({
    required this.category,
    super.key,
  });

  final String category;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size.fromHeight(50),
    painter: _CategoryPainter(
      lineColor: context.schemeOf().outlineVariant,
      textColor: context.schemeOf().onBackground,
      textStyle: context.textThemeOf().labelMedium,
      category: category,
    ),
  );
}

class _CategoryPainter extends CustomPainter {
  _CategoryPainter({
    required this.lineColor,
    required this.textColor,
    required this.category,
    this.textStyle,
  });

  final Color lineColor;
  final Color textColor;
  final String category;
  final TextStyle? textStyle;

  late final _linePainter = Paint()
    ..color = lineColor
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  late final _textPainter = TextPainter(
    text: TextSpan(
      text: category,
      style: textStyle ??
          TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
    ),
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // draw line, then stop, draw text and after that draw line again

    // draw line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width / 4, size.height / 2),
      _linePainter,
    );

    // draw text
    _textPainter
      ..layout()
      ..paint(
        canvas,
        Offset(
          size.width / 4 + 16,
          size.height / 2 - _textPainter.height / 2,
        ),
      );

    // draw line
    canvas.drawLine(
      Offset(size.width / 4 + 16 + _textPainter.width + 16, size.height / 2),
      Offset(size.width, size.height / 2),
      _linePainter,
    );
  }

  @override
  bool shouldRepaint(covariant _CategoryPainter oldDelegate) =>
      lineColor != oldDelegate.lineColor ||
      textColor != oldDelegate.textColor ||
      category != oldDelegate.category ||
      textStyle != oldDelegate.textStyle;
}
