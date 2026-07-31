import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/restaurant_provider.dart';
import 'screens/customer_home_screen.dart';
import 'screens/kitchen_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/delivery_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantProvider(),
      child: MaterialApp(
        title: 'Restaurant Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          useMaterial3: true,
        ),
        home: const RoleSelectScreen(),
      ),
    );
  }
}

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Mode (Role)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerHomeScreen()));
              },
              child: const Text('Customer App'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const KitchenScreen()));
              },
              child: const Text('Kitchen Display (Chef)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DeliveryScreen()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade50),
              child: const Text('Delivery Boy App (Rider) 🛵'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
              },
              child: const Text('Admin Dashboard (Owner)'),
            ),
          ],
        ),
      ),
    );
  }
}