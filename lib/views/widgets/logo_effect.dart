import 'package:flutter/material.dart';

import '../../utils/app_size.dart';

class LogoEffect extends StatefulWidget {
  const LogoEffect({super.key});

  @override
  LogoEffectState createState() => LogoEffectState();
}

class LogoEffectState extends State<LogoEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), 
      vsync: this,
    )..repeat(); 
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(color: Colors.black.withOpacity(0.5)),
        Align(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * 3.1416, 
                    child: Container(
                      width: AppSize.appWidth * 0.17, 
                      height: AppSize.appHeight * 0.17,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, 
                        border: Border.all(
                          color: Colors.white, 
                          width: 1.0, 
                        ),
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white70, Colors.grey],
                          stops: [0.0, 0.5, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Image.asset(
                'assets/images/logo.png',
                width: AppSize.appWidth * 0.15,
                height: AppSize.appHeight * 0.15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}