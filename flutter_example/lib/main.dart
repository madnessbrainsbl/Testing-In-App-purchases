import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// Simplified version of PurchaseState
class PurchaseState {
  final List<ProductDetails> products;
  final String errorMessage;
  final bool loading;
  final bool showPaywall;

  const PurchaseState({
    required this.products,
    required this.errorMessage,
    required this.loading,
    required this.showPaywall,
  });

  PurchaseState copyWith({
    List<ProductDetails>? products,
    String? errorMessage,
    bool? loading,
    bool? showPaywall,
  }) {
    return PurchaseState(
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      loading: loading ?? this.loading,
      showPaywall: showPaywall ?? this.showPaywall,
    );
  }
}

// Simplified PurchaseCubit
class PurchaseCubit extends Cubit<PurchaseState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late List<ProductDetails> _products = [];
  bool testMode = false;
  
  PurchaseCubit() : super(const PurchaseState(
    products: [], 
    errorMessage: '', 
    loading: false, 
    showPaywall: false
  )) {
    _iap.purchaseStream.listen(_onPurchaseUpdated);
  }

  Future<void> loadProducts() async {
    print("[PurchaseCubit] Loading products...");
    emit(state.copyWith(loading: true));

    final available = await _iap.isAvailable();
    if (!available) {
      print("[PurchaseCubit] In-App Purchases not available");
      emit(state.copyWith(errorMessage: "In-App Purchases not available", loading: false));
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
      emit(state.copyWith(errorMessage: "Products not found: ${response.notFoundIDs.join(', ')}", loading: false));
      return;
    }

    _products = response.productDetails;
    print("[PurchaseCubit] Products loaded: ${_products.map((p) => p.id).toList()}");
    emit(state.copyWith(products: _products, loading: false));
  }

  Future<void> buyProduct(String id) async {
    try {
      print("[PurchaseCubit] Starting purchase for: $id");
      final product = _products.firstWhere((p) => p.id == id);
      final param = PurchaseParam(productDetails: product);

      await _iap.buyNonConsumable(purchaseParam: param);
      
      print("[PurchaseCubit] Purchase initiated successfully for: $id");
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
          
          // Complete the purchase
          _iap.completePurchase(purchaseDetails);
          
          emit(state.copyWith(showPaywall: false));
        }
      }
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Purchases App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PurchaseCubit()..loadProducts(),
        child: PaywallScreen(),
      ),
    );
  }
}

class PaywallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In-App Purchases Test'),
      ),
      body: BlocBuilder<PurchaseCubit, PurchaseState>(
        builder: (context, state) {
          if (state.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PurchaseCubit>().loadProducts(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Available Products:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                if (state.products.isEmpty)
                  Text('No products available')
                else
                  ...state.products.map((product) => Card(
                    child: ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text(product.price),
                      onTap: () => context.read<PurchaseCubit>().buyProduct(product.id),
                    ),
                  )).toList(),
                Spacer(),
                ElevatedButton(
                  onPressed: () => context.read<PurchaseCubit>().restorePurchases(),
                  child: Text('Restore Purchases'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
