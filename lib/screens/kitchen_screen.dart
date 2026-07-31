import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);

    // কিচেনে শুধু Pending এবং Preparing অর্ডারগুলো আসবে
    final kitchenOrders = provider.orders
        .where((o) => o.status == 'pending' || o.status == 'preparing')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Display System (KDS)'),
      ),
      body: kitchenOrders.isEmpty
          ? const Center(
              child: Text(
                'No Active Orders in Kitchen 🍳',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: kitchenOrders.length,
              itemBuilder: (ctx, i) {
                final order = kitchenOrders[i];
                final isPending = order.status == 'pending';

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPending
                                    ? Colors.orange.shade100
                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                isPending ? 'NEW ORDER' : 'COOKING',
                                style: TextStyle(
                                  color: isPending
                                      ? Colors.orange.shade900
                                      : Colors.blue.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        ...order.items.map((item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                '• ${item.food.name}  x${item.quantity}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            )),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPending
                                  ? Colors.orange
                                  : Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              if (isPending) {
                                // অর্ডার একসেপ্ট করে রান্না শুরু
                                provider.updateOrderStatus(
                                    order.id, 'preparing');
                              } else {
                                // রান্না শেষ, ডেলিভারিতে পাঠানো
                                provider.updateOrderStatus(
                                    order.id, 'outForDelivery');
                              }
                            },
                            child: Text(
                              isPending
                                  ? 'Accept Order (Start Cooking)'
                                  : 'Food Ready (Send for Delivery)',
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