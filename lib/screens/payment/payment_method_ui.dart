import 'package:flutter/material.dart';
import 'package:restaurent/constants/colors.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final VoidCallback payWithCard; // Receive function from previous screen

  const PaymentMethodsScreen({super.key, required this.payWithCard}); // Constructor

  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedPayment = "upi"; 

  void _payViaUPI() {
    print("Processing payment via UPI...");
  }

  void _cashOnDelivery() {
    print("Selected Cash on Delivery...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
    title:
        Text("Payment Options", style: TextStyle(color: AppColors.white)),
    backgroundColor: AppColors.black,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () => Navigator.pop(context),
    ),
  ),
    
    
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Text("UPI", style: TextStyle(color: Colors.white, fontSize: 18)),
//  _buildPaymentOption("upi", "Google Pay / PhonePe",
    //  Icons.account_balance_wallet, _payViaUPI),
//  SizedBox(height: 20),
            Text("Credit & Debit Cards",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            _buildPaymentOption("card", "Credit/Debit Card",
                Icons.credit_card, widget.payWithCard),
// 
            // SizedBox(height: 20),
          //  
          //  
          //  .
// 
          //  
            // Text("More Payment Options",
                // style: TextStyle(color: Colors.white, fontSize: 18)),
            // _buildPaymentOption("cod", "Cash on Delivery", Icons.money, _cashOnDelivery),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      String value, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = value;
        });
        onTap(); 
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: _selectedPayment == value ? Colors.orange : Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Text(title, style: TextStyle(color: Colors.white)),
              ],
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPayment,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPayment = newValue!;
                });
                onTap(); // Call function when selected
              },
              activeColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}