import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);
    final orders = provider.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Live Order Tracking')),
      body: orders.isEmpty
          ? const Center(child: Text('No active orders found'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, i) {
                final order = orders[orders.length - 1 - i]; // Newest first

                String statusText = '';
                Color statusColor = Colors.orange;
                IconData statusIcon = Icons.hourglass_top;

                if (order.status == 'pending') {
                  statusText = 'Order Sent! Waiting for Restaurant to Accept...';
                  statusColor = Colors.orange;
                  statusIcon = Icons.timelapse;
                } else if (order.status == 'preparing') {
                  statusText = 'Order Accepted! Chef is Cooking your food... 🍳';
                  statusColor = Colors.blue;
                  statusIcon = Icons.soup_kitchen;
                } else if (order.status == 'outForDelivery') {
                  statusText = 'Food is On The Way! Estimated time: 20-25 mins 🛵';
                  statusColor = Colors.purple;
                  statusIcon = Icons.delivery_dining;
                } else if (order.status == 'delivered') {
                  statusText = 'Order Delivered! Enjoy your meal 🎉';
                  statusColor = Colors.green;
                  statusIcon = Icons.check_circle;
                }

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Icon(statusIcon, color: statusColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                statusText,
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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