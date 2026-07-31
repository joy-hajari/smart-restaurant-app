import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);

    // ডেলিভারি বয়ের কাছে শুধু 'outForDelivery' হওয়া অর্ডারগুলো আসবে
    final deliveryOrders = provider.orders
        .where((o) => o.status == 'outForDelivery')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Boy Panel 🛵'),
        backgroundColor: Colors.purple.shade100,
      ),
      body: deliveryOrders.isEmpty
          ? const Center(
              child: Text(
                'No Orders Ready for Delivery 🛵',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: deliveryOrders.length,
              itemBuilder: (ctx, i) {
                final order = deliveryOrders[i];

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID: ${order.id}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '₹${order.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(),
                        ...order.items.map((item) => Text(
                              '• ${item.food.name} (x${item.quantity})',
                              style: const TextStyle(fontSize: 14),
                            )),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.check_circle),
                            onPressed: () {
                              // ডেলিভারি হয়ে গেলে স্ট্যাটাস হবে 'delivered'
                              provider.updateOrderStatus(order.id, 'delivered');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Order ${order.id} marked as Delivered!')),
                              );
                            },
                            label: const Text(
                              'Mark as Delivered (Confirm Delivery)',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}