import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../models/food_item.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _showAddFoodDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Food Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price (₹)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  hintText: 'Paste valid Image Link',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim().isEmpty
                  ? 'Special Dish'
                  : nameController.text.trim();
              final price = double.tryParse(priceController.text) ?? 120.0;
              final desc = descController.text.trim();
              final img = imageController.text.trim();

              final newItem = FoodItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                description:
                    desc.isEmpty ? 'Freshly prepared delicious food' : desc,
                price: price,
                imageUrl: img.isEmpty ? 'https://picsum.photos/200' : img,
              );

              Provider.of<RestaurantProvider>(context, listen: false)
                  .addFoodItem(newItem);
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);

    final pendingOrders =
        provider.orders.where((o) => o.status == 'pending').toList();
    final preparingOrders =
        provider.orders.where((o) => o.status == 'preparing').toList();
    final onTheWayOrders =
        provider.orders.where((o) => o.status == 'outForDelivery').toList();
    final deliveredOrders =
        provider.orders.where((o) => o.status == 'delivered').toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Preparing (Kitchen)'),
              Tab(text: 'On The Way'),
              Tab(text: 'Delivered'),
            ],
          ),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              color: Colors.lightBlue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Revenue',
                            style: TextStyle(fontSize: 14)),
                        Text(
                          '₹${provider.totalRevenue.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showAddFoodDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(pendingOrders, 'Waiting for Kitchen to Accept'),
                  _buildOrderList(preparingOrders, 'Food is Cooking in Kitchen'),
                  _buildOrderList(onTheWayOrders, 'Delivery Boy is On The Way'),
                  _buildOrderList(deliveredOrders, 'Successfully Delivered'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List orders, String subStatusText) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders in this section'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (ctx, i) {
        final order = orders[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title:
                Text('${order.id} - ₹${order.totalAmount.toStringAsFixed(0)}'),
            subtitle: Text(
                '${order.items.map((e) => "${e.food.name} (x${e.quantity})").join(", ")}\n[$subStatusText]'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}