
import 'package:flutter/material.dart';

class PaywallBgImage extends StatelessWidget {
  const PaywallBgImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/banners/pay_wall_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
