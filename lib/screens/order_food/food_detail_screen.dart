import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/screens/cart/cart_screen.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/cart_provider.dart';

class FoodDetailScreens extends ConsumerWidget {
  final Map<String, dynamic> food;

  FoodDetailScreens({required this.food});

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: Image.network(
              food['image_url'] ?? '',
              fit: BoxFit.cover,
            ),
          ),
          
          DraggableScrollableSheet(
            initialChildSize: 0.65, 
            minChildSize: 0.65,
            maxChildSize: 0.85, 
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                              Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(Icons.circle, color: Colors.white, size: 16),
                            ),
                        // Title and veg icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              food['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      
                          ],
                        ),
                        
                        SizedBox(height: 8),
                        
                        // Rating
                        _buildRatingStars(4.5),
                        SizedBox(height: 16),
                        
                        // Price
                        Text(
                          '₹ ${food['price']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        // Size options
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['2.5', '3.0', '3.5'].map((size) => 
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[800]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                size,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ).toList(),
                        ),
                        SizedBox(height: 24),
                        
                        // Description
                        Text(
                          food['description'],
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        SizedBox(height: 24),
                        
                        // Add to cart button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade900,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ref.read(cartProvider.notifier).addToCart(user!.id, food['id'], 1);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => CartScreen()),
                              );
                            },
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Terms & Conditions
                        Text(
                          'Ingredients',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          food['ingredients'],
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        SizedBox(height: 24),
                        
                        Text(
                          'Reviews',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage('assets/select_category/profile.png'),
                                  ),
                                  SizedBox(width: 12),
                                Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Asif Mohammed',
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                            SizedBox(width: 8),
                                            _buildRatingStars(5),
                                          ],
                                        ),
                                        Text(
                                          'Great customer service and very well made dosa',
                                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

