import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionReport extends StatelessWidget {
  final CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('report');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reportCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching reports.'));
          }

          final reportData = snapshot.data!.docs;

          if (reportData.isEmpty) {
            return const Center(child: Text('No reports available.'));
          }

          return ListView.builder(
            itemCount: reportData.length,
            itemBuilder: (context, index) {
              final report = reportData[index];
              final fullName = report['full_name'] ?? 'Unknown';
              final price = report['Price'] ?? '0';
              final count = report['count'] ?? '0';
              final total = report['total'] ?? '0.00';
              final date = report['date'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text('Price: $price'),
                      Text('Count: $count'),
                      Text('Total: $total'),
                      if (date != null)
                        Text('Date: ${date.toDate().toString()}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
