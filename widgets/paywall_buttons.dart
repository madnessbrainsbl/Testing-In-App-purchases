import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:todo/blocs/theme_colors_bloc/app_theme_colors_state.dart';
import 'package:todo/core/extensions/localization_ext.dart';
import 'package:todo/features/pay_wall/cubit/purchase_cubit.dart';
import 'package:todo/features/pay_wall/widgets/pay_wall_button.dart';
import 'package:todo/service/premium_version_sevice.dart';

import '../cubit/purchase_state.dart';

class PaywallButtons extends StatelessWidget {
  final AppThemeColors colors;
  final double contentWidth;
  final PurchaseState purchaseState;
  final bool showShadows;
  const PaywallButtons({super.key, required this.colors, required this.contentWidth, required this.purchaseState, required this.showShadows});

  @override
  Widget build(BuildContext context) {
    PurchaseCubit purchaseCubit = context.read<PurchaseCubit>();
    print("purchaseState" + purchaseState.toString());

    return purchaseState.products.isEmpty ? const Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: CupertinoActivityIndicator(color: Colors.white,),
        )
    ) : Builder(
      builder: (context) {
        ProductDetails firstProduct = purchaseState.products.firstWhere((prod) => prod.id=="monthly_subscription");
        ProductDetails secondProduct = purchaseState.products.firstWhere((prod) => prod.id=="annual_subscription");
        ProductDetails thirdProduct = purchaseState.products.firstWhere((prod) => prod.id=="lifetime_access");

        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            PayWallButtonTwo(
            // PayWallButton(
              color: colors.monthlyPremiumButton,
              firstText: context.localization.base_plan,
              secondText: context.localization.per_month,
              thirdText: context.localization.per_month.toLowerCase(),
              // thirdText: firstProduct.price+context.localization.month_details,
              price: firstProduct.price,
              width: (contentWidth-16)*3/9,
              onTap: () => purchaseCubit.buyMonthlySubscription(),
              showShadows: showShadows,
              textColor: colors.monthlyPremiumButtonText,
            ),
            SizedBox(
              width: 16,
            ),
            PayWallButtonTwo(
            // PayWallButton(
              color: colors.annualPremiumButton,
              firstText: context.localization.fifty_discount,
              secondText: context.localization.per_year,
              thirdText: context.localization.year_details+secondProduct.price+context.localization.year_details_two,
              // thirdText: priceDetails(context,secondProduct,12) + context.localization.year_details,
              price: priceDetails(context,secondProduct,12).toString(),
              // price: secondProduct.price,
              width: (contentWidth-16)*3/9,
              onTap: () => purchaseCubit.buyAnnualSubscription(),
              showShadows: showShadows,
              textColor: colors.annualPremiumButtonText,
            ),
            SizedBox(width: 16,),
            PayWallButtonTwo(
            // PayWallButton(
              color: colors.lifetimePremiumButton,
              firstText: context.localization.eighty_discount,
              secondText: context.localization.lifetime,
              thirdText: context.localization.lifetime_details+thirdProduct.price+context.localization.lifetime_details_two,
              // thirdText: context.localization.lifetime_details+thirdProduct.price+")",
              // thirdText: priceDetails(context,thirdProduct,60)+context.localization.lifetime_details+thirdProduct.price+context.localization.lifetime_details_two,
              price: priceDetails(context,thirdProduct,60),
              // price: thirdProduct.price,
              width: (contentWidth-16)*3/9,
              onTap: () => purchaseCubit.buyLifetimeAccess(),
              showShadows: showShadows,
              textColor: colors.lifetimePremiumButtonText,
            ),
          ],
        );
      }
    );
  }

  String priceDetails(BuildContext context,ProductDetails product,int divide) {
    return (product.price.substring(0,1).toString()).toString()
        +((double.parse(product.price.substring(1).toString())/divide).toString().length>4 ?
    (double.parse(product.price.substring(1).toString())/divide).toString().substring(0,4) : (double.parse(product.price.substring(1).toString())/divide).toString());
  }
}
