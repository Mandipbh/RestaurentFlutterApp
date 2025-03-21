import 'package:flutter/material.dart';

class OfferDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OfferDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: imagePath,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey[700]),
                  SizedBox(height: 20),
                  _buildOfferDetails(),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Offer Claimed Successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text("Claim Offer", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _offerDetailRow(Icons.timer, "Limited Time Offer"),
        SizedBox(height: 10),
        _offerDetailRow(Icons.local_offer, "Exclusive for App Users"),
        SizedBox(height: 10),
        _offerDetailRow(Icons.fastfood, "Available for Dine-in & Takeaway"),
      ],
    );
  }

  Widget _offerDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 24),
        SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 16, color: Colors.white70)),
      ],
    );
  }
}