import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo/features/pay_wall/widgets/paywall_header.dart';
import 'package:todo/features/pay_wall/widgets/paywall_text.dart';

class PaywallGlassContainer extends StatelessWidget {
  final List<Widget> children;
  final Color bgColor;
  const PaywallGlassContainer({super.key, required this.children, required this.bgColor});

  @override
  Widget build(BuildContext context) {


    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(width: 1,color: bgColor,strokeAlign: BorderSide.strokeAlignInside)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
