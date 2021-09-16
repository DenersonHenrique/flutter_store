class CartItemModel {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
  });
}
