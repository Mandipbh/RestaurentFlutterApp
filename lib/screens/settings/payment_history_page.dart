import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/payment_provider.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Order History", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search by price, id, method, status, date",
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(child: buildPaymentDetails()),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentDetails() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentData = ref.watch(paymentProvider);

        return paymentData.when(
          data: (payments) {
            if (payments.isEmpty) {
              return Center(
                  child: Text("No payments found",
                      style: TextStyle(color: Colors.white70)));
            }

            final filteredPayments = payments.where((payment) {
              return payment.amount.toString().contains(_searchQuery) ||
                  payment.id.toLowerCase().contains(_searchQuery) ||
                  payment.method.toLowerCase().contains(_searchQuery) ||
                  payment.status.toLowerCase().contains(_searchQuery) ||
                  payment.createdAt.toString().contains(_searchQuery);
            }).toList();

            if (filteredPayments.isEmpty) {
              return Center(
                  child: Text("No matching results",
                      style: TextStyle(color: Colors.white70)));
            }

            return ListView.builder(
              itemCount: filteredPayments.length,
              itemBuilder: (context, index) {
                final payment = filteredPayments[index];
                print('payment: ${payment.id}');
                return Card(
                  color: Colors.grey[850],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "₹${payment.amount.toStringAsFixed(2)} - ${payment.method}",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              payment.status,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${payment.createdAt.toLocal()}",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
              child: Text("Error: $err", style: TextStyle(color: Colors.red))),
        );
      },
    );
  }
}
