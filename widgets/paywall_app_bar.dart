import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/blocs/theme_colors_bloc/app_theme_colors_state.dart';
import 'package:todo/core/extensions/localization_ext.dart';

class PaywallAppBar extends StatelessWidget {
  final AppThemeColors colors;
  final bool showHeader;
  const PaywallAppBar({super.key, required this.colors, required this.showHeader});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          margin: EdgeInsets.only(top: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: context.pop,
                  icon: Icon(CupertinoIcons.back, color: colors.text)
              ),
              if(showHeader) getPaywallHeaderText(context),
              const SizedBox(
                height: 36,
                width: 36,
              )
            ],
          )),
    );
  }

  Text getPaywallHeaderText(BuildContext context) => Text(context.localization.habit_ok_premium, style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.w700));
}
