import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../blocs/user_stats_bloc/user_stats_bloc.dart';
import '../../../blocs/user_stats_bloc/user_stats_events.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  final UserStatsBloc _userStatsBloc;
  late List<ProductDetails> _products;
  bool testMode = false;
  
  PurchaseCubit(this._userStatsBloc) : super(const PurchaseState(products: [], errorMessage: '', loading: false, showPaywall: false)) {
    _iap.purchaseStream.listen(_onPurchaseUpdated);
  }

  Future<void> loadProducts() async {
    print("[PurchaseCubit] Loading products...");
    emit(state.copyWith(loading: true));

    final available = await _iap.isAvailable();
    if (!available) {
      print("[PurchaseCubit] In-App Purchases not available");
      emit(state.copyWith(errorMessage: "In-App Purchases not available",loading: false));
      return;
    }
    print("[PurchaseCubit] In-App Purchases available");

    const ids = {
      'monthly_subscription',
      'annual_subscription',
      'lifetime_access',
    };
    print("[PurchaseCubit] Querying products: $ids");

    final response = await _iap.queryProductDetails(ids);

    if (response.notFoundIDs.isNotEmpty) {
      print("[PurchaseCubit] Products not found: ${response.notFoundIDs}");
      emit(state.copyWith(errorMessage: "Products not found: ${response.notFoundIDs.join(', ')}",loading: false));
      return;
    }

    _products = response.productDetails;
    print("[PurchaseCubit] Products loaded: ${_products.map((p) => p.id).toList()}");
    emit(state.copyWith(products: _products,loading: false));
  }

  Future<void> toggleBannerVision() async {

    if(state.products.isEmpty) {
      await loadProducts();
    }
    emit(state.copyWith(showPaywall: !state.showPaywall));
  }

  Future<void> buyMonthlySubscription() async => _buyProduct('monthly_subscription');

  Future<void> buyAnnualSubscription() async => _buyProduct('annual_subscription');

  Future<void> buyLifetimeAccess() async => _buyProduct('lifetime_access');

  Future<void> _buyProduct(String id) async {
    try {
      print("[PurchaseCubit] Starting purchase for: $id");
      final product = _products.firstWhere((p) => p.id == id);
      final param = PurchaseParam(productDetails: product);

      bool isConsumable = false; // Подписки обычно не являются consumable
      if (id == 'lifetime_access') {
        await _iap.buyNonConsumable(purchaseParam: param);
      } else {
        // Для подписок используем buyNonConsumable
        await _iap.buyNonConsumable(purchaseParam: param);
      }
      
      print("[PurchaseCubit] Purchase initiated successfully for: $id");
      // Обработка покупки будет происходить в _onPurchaseUpdated
    } catch (e) {
      print("[PurchaseCubit] Purchase failed: $e");
      emit(state.copyWith(errorMessage: "Purchase failed: $e"));
    }
  }

  Future<void> restorePurchases() async {
    try {
      print("[PurchaseCubit] Starting restore purchases...");
      await _iap.restorePurchases();
      print("[PurchaseCubit] Restore purchases completed");
    } catch (e) {
      print("[PurchaseCubit] Error restoring purchases: $e");
      emit(state.copyWith(errorMessage: "Failed to restore purchases: $e"));
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print("[PurchaseCubit] Purchase updated: ${purchaseDetailsList.length} items");
    
    for (var purchaseDetails in purchaseDetailsList) {
      print("[PurchaseCubit] Processing purchase: ${purchaseDetails.productID}, status: ${purchaseDetails.status}");
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("[PurchaseCubit] Purchase pending for: ${purchaseDetails.productID}");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("[PurchaseCubit] Purchase error: ${purchaseDetails.error}");
          emit(state.copyWith(errorMessage: purchaseDetails.error?.message ?? "Unknown error"));
        } else if (purchaseDetails.status == PurchaseStatus.purchased || 
                   purchaseDetails.status == PurchaseStatus.restored) {
          print("[PurchaseCubit] Purchase successful: ${purchaseDetails.productID}");
          
          // Verify and deliver the purchase
          _deliverProduct(purchaseDetails);
          
          // Complete the purchase
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }
  
  void _deliverProduct(PurchaseDetails purchaseDetails) {
    print("[PurchaseCubit] Delivering product: ${purchaseDetails.productID}");
    
    emit(state.copyWith(showPaywall: false));
    
    if (purchaseDetails.productID == "monthly_subscription") {
      _userStatsBloc.add(AddMonthlySubscription());
    } else if (purchaseDetails.productID == "annual_subscription") {
      _userStatsBloc.add(AddAnnualSubscription());
    } else if (purchaseDetails.productID == "lifetime_access") {
      _userStatsBloc.add(AddLifetimeAccess());
    }
  }
}
