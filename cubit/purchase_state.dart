import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

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
