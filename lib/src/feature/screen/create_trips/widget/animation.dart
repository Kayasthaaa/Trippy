// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class FadeInOutTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool fadeIn;

  const FadeInOutTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.fadeIn = true,
  });

  @override
  _FadeInOutTransitionState createState() => _FadeInOutTransitionState();
}

class _FadeInOutTransitionState extends State<FadeInOutTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.fadeIn) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant FadeInOutTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fadeIn) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
