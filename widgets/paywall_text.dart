import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/blocs/theme_colors_bloc/app_theme_colors_state.dart';

import '../models/paywall_content.dart';
import '../pay_wall_screen.dart';

class PaywallText extends StatelessWidget {
  final PayWallContent content;
  final AppThemeColors colors;
  final double contentWidth;

  const PaywallText({super.key, required this.contentWidth, required this.content, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: contentWidth / 2,
            child: Padding(
              child: Text(content.advantageName, style: TextStyle(color: colors.text)),
              padding: EdgeInsetsGeometry.only(right: 12),
            )
        ),
        Container(
            width: contentWidth / 4,
            child: Text(content.freeAdvantage, style: TextStyle(color: colors.text)),),
        Container(
            width: contentWidth / 4,
            child: Icon(
              content.premiumAdvantage,
              color: colors.text
            )),
      ],
    );
  }
}
