import 'package:flutter/material.dart';

class EaseInWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;  // Change Function to VoidCallback

  const EaseInWidget({
    Key? key,  // Make Key optional
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EaseInWidgetState();
}

class _EaseInWidgetState extends State<EaseInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();  // Trigger the provided onTap callback
        _controller.forward(from: 0);  // Start the animation
      },
      child: FadeTransition(
        opacity: _animation,  // Apply the animation to the opacity
        child: widget.child,  // Use the child widget passed in the constructor
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();  // Dispose of the controller when done
    super.dispose();
  }
}
