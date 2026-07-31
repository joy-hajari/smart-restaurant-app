import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../models/order_model.dart';
import 'order_tracking_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);
    final menu = provider.menu;

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Menu')),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: Image.network(menu[i].imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(menu[i].name),
          subtitle: Text('₹${menu[i].price}'),
          trailing: ElevatedButton(
            onPressed: () {
              provider.placeOrder([OrderItem(food: menu[i], quantity: 1)]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order Placed Successfully!')),
              );
            },
            child: const Text('Order'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (provider.orders.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
            );
          }
        },
        label: const Text('Track Order'),
        icon: const Icon(Icons.delivery_dining),
      ),
    );
  }
}