import 'package:flutter/material.dart';

class RingProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Widget? child;
  final bool animateProgress;
  final Duration animationDuration;

  const RingProgressBar({
    super.key,
    required this.progress,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    required this.progressColor,
    required this.backgroundColor,
    this.child,
    this.animateProgress = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<RingProgressBar> createState() => _RingProgressBarState();
}

class _RingProgressBarState extends State<RingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.animateProgress) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(RingProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: _animation.value, end: widget.progress)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: widget.strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(widget.backgroundColor),
            ),
          ),
          // Progress ring
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: widget.animateProgress
                      ? _animation.value
                      : widget.progress,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.progressColor,
                  ),
                );
              },
            ),
          ),
          // Center content
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}
