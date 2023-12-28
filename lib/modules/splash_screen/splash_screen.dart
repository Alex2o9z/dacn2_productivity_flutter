import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool selected = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        selected = true;
      });

      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
              (route) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          curve: Curves.bounceOut,
          width: selected ? 200.0 : 100.0,
          height: selected ? 200.0 : 100.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/app-icon.png'),
            ),
          ),
          duration: const Duration(milliseconds: 1000),
        ),
      ),
    );
  }
}
