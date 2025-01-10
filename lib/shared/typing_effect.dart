import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypingEffect extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;

  const TypingEffect({
    Key? key,
    required this.text,
    this.textStyle,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  _TypingEffectState createState() => _TypingEffectState();
}

class _TypingEffectState extends State<TypingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 100),
      vsync: this,
    );
    _charCount = StepTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          _controller.reset();
          _controller.forward();
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, child) {
        String text = widget.text.substring(0, _charCount.value);
        return Text(
          text,
          style: widget.textStyle ?? GoogleFonts.oxanium(fontSize: 24),
        );
      },
    );
  }
}
