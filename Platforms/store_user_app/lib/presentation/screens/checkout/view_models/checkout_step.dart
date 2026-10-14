enum CheckoutStep {
  initial(name: 'start'),
  authentication(name: 'auth'),
  billingAddress(name: 'billing'),
  shippingAddress(name: 'shipping'),
  shippingMethod(name: 'shipping-method'),
  paymentMethod(name: 'payment-method'),
  paymentInfo(name: 'payment-info'),
  confirmOrder(name: 'confirm-order'),
  completed(name: 'completed'),
  redirected(name: 'redirected'),
  fail(name: 'fail'),
  unknown(name: 'unknown');

  final String name;
  const CheckoutStep({required this.name});

  static CheckoutStep fromString(String label) {
    return values.firstWhere(
      (v) => v.name == label,
      orElse: () => CheckoutStep.unknown,
    );
  }
}
