import 'package:e_commerce/admin/feedback_screen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          }
        ),
        title: const Text(
          "Dashboard",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Quick Actions
            const Text(
              "Quick Actions",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    _buildOverviewCard(
                    icon: Icons.category,
                    label: "Manage Products",
                    onTap: () => Navigator.pushNamed(context, 'manage_products'),
                  ),
                  const SizedBox(height: 20),

                  _buildOverviewCard(
                    icon: Icons.insert_chart_outlined,
                    label: "View Reports",
                    onTap: () => Navigator.pushNamed(context, 'reports_screen'),
                  ),
                  const SizedBox(height: 20),
                  _buildOverviewCard(
                      icon: Icons.feedback_outlined,
                      label: "Feedback",
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedbackScreen()),
                            )
                          }),
                ],
              ),
            ),
            const SizedBox(height: 20),
           

            const SizedBox(height: 20),

            // Section: Best-Selling Products Chart
            const Text(
              "Analytics",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, 'bestSellingChart'),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Best Selling Products",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build overview cards
  Widget _buildOverviewCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepOrangeAccent),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
