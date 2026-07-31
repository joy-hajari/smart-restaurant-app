import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/order_model.dart';

class RestaurantProvider with ChangeNotifier {
  final List<FoodItem> _menu = [
    FoodItem(
      id: 'f1',
      name: 'Chicken Biryani',
      description: 'Delicious Hyderabadi Chicken Biryani',
      price: 220.0,
      imageUrl: 'https://picsum.photos/id/292/200/200',
    ),
    FoodItem(
      id: 'f2',
      name: 'Paneer Butter Masala',
      description: 'Rich creamy paneer curry',
      price: 180.0,
      imageUrl: 'https://picsum.photos/id/1080/200/200',
    ),
  ];

  final List<OrderModel> _orders = [];

  List<FoodItem> get menu => [..._menu];
  List<OrderModel> get orders => [..._orders];

  double get totalRevenue {
    return _orders
        .where((o) => o.status == 'delivered')
        .fold(0.0, (sum, item) => sum + item.totalAmount);
  }

  void addFoodItem(FoodItem item) {
    _menu.add(item);
    notifyListeners();
  }

  void placeOrder(List<OrderItem> items) {
    double total = items.fold(0.0, (sum, item) => sum + (item.food.price * item.quantity));
    final newOrder = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: items,
      totalAmount: total,
      status: 'pending',
      timestamp: DateTime.now(),
    );
    _orders.add(newOrder);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].status = newStatus;
      notifyListeners();
    }
  }
}