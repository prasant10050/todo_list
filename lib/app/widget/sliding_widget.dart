import 'package:flutter/widgets.dart';

enum SlideDirection { fromLeft, fromRight, fromTop, fromBottom }

class CustomSlideTransition extends StatefulWidget {

  const CustomSlideTransition({super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
    this.direction = SlideDirection.fromLeft,
  });
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final SlideDirection direction;

  @override
  _CustomSlideTransitionState createState() => _CustomSlideTransitionState();
}

class _CustomSlideTransitionState extends State<CustomSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _setSlideAnimation();
  }

  @override
  void didUpdateWidget(covariant CustomSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _setSlideAnimation() {
    Offset beginOffset;
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        beginOffset = Offset(-1.0, 0.0);
        break;
      case SlideDirection.fromRight:
        beginOffset = Offset(1.0, 0.0);
        break;
      case SlideDirection.fromTop:
        beginOffset = Offset(0.0, -1.0);
        break;
      case SlideDirection.fromBottom:
        beginOffset = Offset(0.0, 1.0);
        break;
    }

    _animation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}