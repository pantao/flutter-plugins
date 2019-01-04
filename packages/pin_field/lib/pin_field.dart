library pin_field;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Default Text Style
const TextStyle _kDefaultTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 24.0
);

/// Mobile SMS Code/Pin Field
class PinField extends StatefulWidget {
  /// Pin Length
  final int length;
  /// Pin Gap width
  final double gap;
  /// padding
  final EdgeInsetsGeometry padding;
  /// Keyboard Type
  final TextInputType keyboardType;
  /// On Value Changed handler
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  /// Input Formatters
  final List<TextInputFormatter> inputFormatters;
  PinField({
    this.length,
    this.gap,
    this.padding,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters
  }) : assert(length > 0);

  @override
  State<StatefulWidget> createState() {
    return _PinFieldState();
  }
}

class _PinFieldState extends State<PinField> {
  final TextEditingController _controller = TextEditingController();
  String _text = '';

  String get text => _text;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _text = _controller.text;
        if (widget.onChanged != null) {
           widget.onChanged(_text);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: CustomPaint(
        foregroundPainter: _PinFieldPainter(
          text: _text,
          length: widget.length,
          gap: widget.gap
        ),
        child: TextField(
          controller: _controller,
          style: TextStyle(
            /// Set editing text transparent
            color: Colors.transparent
          ),
          /// Hide Cursor
          cursorColor: Colors.transparent,

          maxLength: widget.length,
          onSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            /// Hide counter text
            counterText: '',
            border: OutlineInputBorder(
              borderSide: BorderSide.none
            )
          )
        )
      ),
    );
  }
}

class _PinFieldPainter extends CustomPainter {
  final String text;
  final int length;
  final double gap;

  _PinFieldPainter({
    this.text,
    this.length,
    this.gap
  }) : assert(length > 0);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => !(oldDelegate is _PinFieldPainter && oldDelegate.text == text);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    
    var x = 0.0;
    var y = size.height - 1.0;

    var pieceWidth = (size.width - gap * (length - 1)) / length;

    for (int i = 0; i < length; i ++) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x + pieceWidth, y),
        p
      );
      x += pieceWidth + gap;
    }

    if (text == null || text.trim().isEmpty) {
      return;
    }

    var i = 0;
    x = 0.0;
    y = 0.0;

    text.runes.forEach((rune) {
      TextPainter painter = TextPainter(
        text: TextSpan(
          style: _kDefaultTextStyle,
          text: String.fromCharCode(rune)
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
      );

      painter.layout();

      if (y == 0.0) {
        y = size.height / 2 - painter.height / 2;
      }

      x = pieceWidth * i + pieceWidth / 2 - painter.width / 2 + gap * i;
      painter.paint(canvas, Offset(x, y));
      i ++;
    });

  }
}