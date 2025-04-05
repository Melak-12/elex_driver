// slidewidget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideToCompleteButton extends StatefulWidget {
  final VoidCallback onCompleted;
  final String text;

  const SlideToCompleteButton({
    super.key,
    required this.onCompleted,
    required this.text,
  });

  @override
  State<SlideToCompleteButton> createState() => _SlideToCompleteButtonState();
}

class _SlideToCompleteButtonState extends State<SlideToCompleteButton>
    with SingleTickerProviderStateMixin {
  double _dragPercentage = 0.0;
  final double _dragThreshold = 0.9;
  late AnimationController _animationController;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      _isDragging = true;
      _dragPercentage += details.delta.dx / constraints.maxWidth;
      _dragPercentage = _dragPercentage.clamp(0.0, 1.0);
    });

    // Provide haptic feedback at intervals
    if (_dragPercentage > 0.25 && _dragPercentage < 0.27 ||
        _dragPercentage > 0.5 && _dragPercentage < 0.52 ||
        _dragPercentage > 0.75 && _dragPercentage < 0.77) {
      HapticFeedback.lightImpact();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragPercentage > _dragThreshold) {
      // Complete the animation
      _animationController.forward(from: _dragPercentage);

      // Provide success feedback
      HapticFeedback.mediumImpact();

      // Call the completion callback
      Future.delayed(const Duration(milliseconds: 200), () {
        widget.onCompleted();
      });
    } else {
      // Reset the animation
      setState(() {
        _isDragging = false;
      });
      _animationController.reverse(from: _dragPercentage);
      _dragPercentage = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackWidth = constraints.maxWidth;
          final thumbRadius = constraints.maxHeight * 0.8;
          final trackPadding = (constraints.maxHeight - thumbRadius) / 2;

          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF663399).withOpacity(0.1),
                      const Color(0xFF663399).withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),

              // Progress indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: trackWidth * _dragPercentage,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF663399), Color(0xFF8A63C9)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),

              // Slide text
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: _dragPercentage > 0.5
                        ? Colors.white
                        : const Color(0xFF663399),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              // Draggable thumb
              Positioned(
                left: (trackWidth - thumbRadius) * _dragPercentage,
                top: trackPadding,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _onDragUpdate(details, constraints),
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: thumbRadius,
                    height: thumbRadius,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF663399).withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _dragPercentage > _dragThreshold
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: const Color(0xFF663399),
                        size: thumbRadius * 0.5,
                      ),
                    ),
                  ),
                ),
              ),

             
            ],
          );
        },
      ),
    );
  }
}
