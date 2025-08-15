import 'package:flutter/material.dart';
import 'package:todo/blocs/theme_colors_bloc/app_theme_colors_state.dart';
import 'package:todo/core/extensions/localization_ext.dart';

class PaywallHeader extends StatelessWidget {
  final double contentWidth;
  final AppThemeColors colors;
  const PaywallHeader({super.key, required this.contentWidth, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: contentWidth/2,
            child: Text(context.localization.function, style: TextStyle(color: colors.text,fontWeight: FontWeight.w800,fontSize: 15))
        ),
        Container(
            width: contentWidth/4,
            child: Text(context.localization.free, style: TextStyle(color: colors.text,fontWeight: FontWeight.w800,fontSize: 15))
        ),
        Container(
            width: contentWidth/4,
            child: Text(context.localization.premium, style: TextStyle(color: colors.text,fontWeight: FontWeight.w800,fontSize: 15))
        ),
      ],
    );
  }
}
