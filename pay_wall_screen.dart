import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/extensions/localization_ext.dart';
import 'package:todo/features/pay_wall/widgets/paywall_app_bar.dart';
import 'package:todo/features/pay_wall/widgets/paywall_bg_image.dart';
import 'package:todo/features/pay_wall/widgets/paywall_buttons.dart';
import 'package:todo/features/pay_wall/widgets/paywall_glass_container.dart';
import 'package:todo/features/pay_wall/widgets/paywall_header.dart';
import 'package:todo/features/pay_wall/widgets/paywall_text.dart';
import 'package:todo/service/premium_version_sevice.dart';

import '../../blocs/theme_colors_bloc/app_theme_colors_bloc.dart';
import '../../blocs/theme_colors_bloc/app_theme_colors_state.dart';
import 'cubit/purchase_cubit.dart';
import 'cubit/purchase_state.dart';
import 'models/paywall_content.dart';

class PayWallScreen extends StatefulWidget {
  const PayWallScreen({super.key});

  @override
  State<PayWallScreen> createState() => _PayWallScreenState();
}

class _PayWallScreenState extends State<PayWallScreen> {


  @override
  void initState() {
    context.read<PurchaseCubit>().loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 32 - 32 - 2;
    final AppThemeColors colors = context.read<AppThemeColorsBloc>().state.currentThemeColors;

    List<PayWallContent> _content = PremiumVersionService.getContent(context);

    return Scaffold(
      backgroundColor: colors.premiumScaffoldBgButton,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaywallAppBar(colors: colors, showHeader: true,),
            const SizedBox(height: 16),
            Container(
              margin: EdgeInsetsGeometry.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: colors.premiumCardBgButton,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 20)]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 8),
                  // Text(context.localization.habit_ok_premium, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                  // SizedBox(height: 24),
                  PaywallHeader(contentWidth: contentWidth, colors: colors,),
                  ListView.separated(
                    padding: EdgeInsets.only(top: 16, bottom: 0),
                    shrinkWrap: true,
                    itemCount: _content.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => PaywallText(contentWidth: contentWidth, content: _content[index], colors: colors),
                    separatorBuilder: (context, index) => Divider(color: colors.text.withAlpha(24), height: 24,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16,),
            BlocBuilder<PurchaseCubit,PurchaseState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PaywallButtons(
                      colors: colors,
                      contentWidth: MediaQuery.of(context).size.width - 32 - 16,
                      purchaseState: state,
                      showShadows: true,
                    ),
                  );
                }
            ),
            SizedBox(height: 12,),
            // Enjoy a 7-day free trial on all plans
            // Попробуйте любой тариф бесплатно 7 дней
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(context.localization.localeName=='ru') ...[
                  Text("Попробуйте любой тариф бесплатно ",style: TextStyle(color: colors.text.withAlpha(150),fontSize: 12,fontWeight: FontWeight.w600)),
                  Text("7 дней",style: TextStyle(color: colors.text,fontSize: 12,fontWeight: FontWeight.w700)),
                ] else ...[
                  Text("Enjoy a",style: TextStyle(color: colors.text.withAlpha(200),fontSize: 12,fontWeight: FontWeight.w600)),
                  Text(" 7-day ",style: TextStyle(color: colors.text,fontSize: 12,fontWeight: FontWeight.w700)),
                  Text("free trial on all plans",style: TextStyle(color: colors.text.withAlpha(200),fontSize: 12,fontWeight: FontWeight.w600)),
                ]
              ],
            ),
            SizedBox(height: 36,),
            // Restore purchases button
            TextButton(
              onPressed: () => context.read<PurchaseCubit>().restorePurchases(),
              child: Text(
                context.localization.localeName == 'ru' 
                  ? "Восстановить покупки" 
                  : "Restore Purchases",
                style: TextStyle(
                  color: colors.text.withAlpha(180),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }
}


