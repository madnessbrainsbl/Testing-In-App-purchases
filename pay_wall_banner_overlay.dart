import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/blocs/theme_colors_bloc/app_theme_colors_bloc.dart';
import 'package:todo/core/extensions/localization_ext.dart';
import 'package:todo/features/pay_wall/widgets/paywall_buttons.dart';
import 'package:todo/features/pay_wall/widgets/paywall_glass_container.dart';
import 'package:todo/features/pay_wall/widgets/paywall_header.dart';
import 'package:todo/features/pay_wall/widgets/paywall_text.dart';

import '../../blocs/theme_colors_bloc/app_theme_colors_state.dart';
import '../../core/widgets/show_when.dart';
import '../../service/premium_version_sevice.dart';
import 'cubit/purchase_cubit.dart';
import 'cubit/purchase_state.dart';
import 'models/paywall_content.dart';

class PayWallBannerOverlay extends StatelessWidget {
  final Widget child;

  const PayWallBannerOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 16 - 16 - 2;
    List<PayWallContent> _content = PremiumVersionService.getContent(context);
    AppThemeColors colors = context.read<AppThemeColorsBloc>().state.currentThemeColors;


    return Material(
      child: Stack(
        children: [
          child,
          BlocBuilder<PurchaseCubit,PurchaseState>(
            builder: (context,state) {
              return ShowWhen(
                show: state.showPaywall,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => context.push("/paywall"),
                  // onTap: () => context.read<PurchaseCubit>().toggleBannerVision(),
                  child: const SizedBox.expand(),
                ),
              );
            }
          ),
          BlocBuilder<PurchaseCubit,PurchaseState>(
            builder: (context,state) {
              return ShowWhen(
                show: state.showPaywall,
                child: PaywallGlassContainer(
                  bgColor: colors.premiumBannerColor,
                  children: [
                    Text(context.localization.habit_ok_premium,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700)
                    ),
                    const SizedBox(height: 24),
                    PaywallHeader(contentWidth: contentWidth, colors: colors,),
                    ListView.separated(
                      padding: EdgeInsets.only(top: 24, bottom: 24),
                      shrinkWrap: true,
                      itemCount: _content.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => PaywallText(
                          contentWidth: contentWidth,
                          content: _content[index],
                          colors: colors
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.white30,
                        height: 24,
                      ),
                    ),
                    PaywallButtons(
                      colors: colors,
                      contentWidth: contentWidth,
                      purchaseState: state,
                      showShadows: false,
                    ),
                    SizedBox(height: 12,),
                    // Center(
                    //   child: Text(context.localization.seven_day_free,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w700),),
                    // ),
                    SizedBox(height: 8,),
                  ]
                ),
              );
            }
          )
        ],
      ),
    );
  }
}
