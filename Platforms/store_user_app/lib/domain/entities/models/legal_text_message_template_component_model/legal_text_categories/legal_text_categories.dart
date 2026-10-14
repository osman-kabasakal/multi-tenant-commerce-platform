enum LegalTextCategories {
  orderConfirmation(name: 'OrderConfirmation'),
  orderCancellation(name: 'OrderCancellation'),
  returnRequest(name: 'ReturnRequest'),
  unknown(name: 'unknown');

  final String name;
  const LegalTextCategories({required this.name});

  static LegalTextCategories fromString(String label) {
    // static parser method
    return values.firstWhere(
      (v) => v.name == label,
      orElse: () => LegalTextCategories.unknown,
    );
  }
}
