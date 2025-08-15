import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/theme_colors_bloc/app_theme_colors_state.dart';

import '../../../blocs/theme_colors_bloc/app_theme_colors_bloc.dart';

class PayWallButton extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String thirdText;
  final String price;
  final Color color;
  final double width;
  final VoidCallback onTap;

  const PayWallButton(
      {super.key,
      required this.color,
      required this.firstText,
      required this.secondText,
      required this.thirdText,
      required this.price,
      required this.width,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 144,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        width: width,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12)),
              child: Container(
                // padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
                height: 24,
                width: width,
                color: Colors.white12,
                child: Center(
                    child: Text(firstText,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700))),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(price,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            Text(secondText,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            const SizedBox(
              height: 8,
            ),
            Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
                child: Text(
                  thirdText,
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.white.withAlpha(230),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class PayWallButtonTwo extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String thirdText;
  final String price;
  final Color color;
  final Color textColor;
  final double width;
  final VoidCallback onTap;
  final bool showShadows;


  const PayWallButtonTwo({
    super.key,
      required this.firstText,
      required this.secondText,
      required this.thirdText,
      required this.price,
      required this.color,
      required this.textColor,
      required this.width,
      required this.onTap,
      required this.showShadows,
  });

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.read<AppThemeColorsBloc>().state.currentThemeColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(25),blurRadius: 15)]
            // boxShadow: showShadows ? [BoxShadow(color: Colors.black12)] : []
        ),
        width: width,
        child: Column(
          children: [
            Container(
              width: width,
              padding: EdgeInsetsGeometry.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: textColor.withAlpha(23),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                // border: Border.fromBorderSide(BorderSide(color: Colors.white,))
              ),
              child: Center(child: Text(firstText, style: TextStyle(fontSize: 9, color: textColor, fontWeight: FontWeight.w700)),),
            ),
            const SizedBox(height: 6),
            Text(price,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Montserrat",
                    color: textColor,
                    fontWeight: FontWeight.w800
                )),
            Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 4),
                child: Text(
                  thirdText,
                  style: TextStyle(
                      fontSize: 9,
                      color: textColor.withAlpha(250),
                      fontWeight: FontWeight.w500,
                      height: 1.35),
                  textAlign: TextAlign.center,
                )),
            // const SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}
