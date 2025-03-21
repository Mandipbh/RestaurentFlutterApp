import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/providers/food_provider.dart';
import 'package:restaurent/screens/cart/cart_screen.dart';

class FoodDetailScreens extends ConsumerStatefulWidget {
  final Map<String, dynamic> food;
  final String type;
  const FoodDetailScreens({super.key, required this.food, required this.type});

  @override
  ConsumerState<FoodDetailScreens> createState() => _FoodState();
}

class _FoodState extends ConsumerState<FoodDetailScreens> {
  List<Map<String, dynamic>> reviews = [];
  @override
  void initState() {
    super.initState();
    print('food detail ${widget.type}');

    Future.microtask(() => fetchReviews());
  }

  void fetchReviews() async {
    final user = ref.read(authProvider);
    if (user == null) return;

    final result = await ref.read(foodReviewsProvider({
      'food_id': widget.food['id'],
      'user_id': user.id,
    }).future);

    setState(() {
      reviews = result;
    });
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    final cartItems = ref.watch(cartProvider);
    bool isInCart = cartItems.any((item) {
      String cartItemId = item['food_items']?['id']?.toString() ??
          item['combination_breakfast']?['id']?.toString() ??
          item['recommended_breakfast']?['id']?.toString() ??
          item['all_foods']?['id']?.toString() ??
          '';

      return cartItemId == widget.food['id'].toString();
    });

    print('dcetail of it is in cart >> $isInCart');

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: AppColors.white),
                onPressed: () {
                  // if (cartItems.isEmpty) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar(
                        // content: Text("No items in the cart"),
                        // backgroundColor: Colors.red,
                        // duration: Duration(seconds: 2),
                      // ),
                    // );
                  // } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen(2)),
                    );
                  // }
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: badges.Badge(
                    badgeContent: Text(
                      cartItems.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.network(
              widget.food['image_url'] ?? '',
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
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child:
                              Icon(Icons.circle, color: Colors.green, size: 16),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.food['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRatingStars(widget.food['rating'] ?? 0),
                          Text(
                            '${widget.food['rating'] ?? 0}',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '₹ ${widget.food['price'] ?? '0'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          widget.food['description'] ??
                              'No description available',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                              (widget.food['carbs_grams'] ?? 0).toString(),
                              'Carbs'),
                          _buildStatCard(
                              (widget.food['fat_grams'] ?? 0).toString(),
                              'Fat'),
                          _buildStatCard(
                              (widget.food['protein_grams'] ?? 0).toString(),
                              'Protein'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: isInCart
                                ? null
                                : () {
                                    if (widget.type ==
                                        'recommended_breakfast') {
                                      ref.read(cartProvider.notifier).addToCart(
                                        context,
                                          user!.id,
                                          recommendedBreakfastId:
                                              widget.food['id'],
                                          quantity: 1, restaurentId: widget.food['restaurant_id']);
                                    } else if (widget.type ==
                                        'combination_breakfast') {
                                      ref.read(cartProvider.notifier).addToCart(
                                                                                context,

                                          user!.id,
                                          combinationBreakfastId:
                                              widget.food['id'],
                                          quantity: 1,  restaurentId: widget.food['restaurant_id']);
                                    } else if (widget.type == 'food_items') {
                                      ref.read(cartProvider.notifier).addToCart(
                                                                                context,

                                          user!.id,
                                          foodId: widget.food['id'],
                                          quantity: 1, restaurentId: widget.food['restaurant_id']);
                                    } else {
                                      ref.read(cartProvider.notifier).addToCart(
                                                                                context,

                                          user!.id,
                                          allFoodId: widget.food['id'],
                                          quantity: 1, restaurentId: widget.food['restaurant_id']);
                                    }
                              
                              
                              
                              
                              
                              
                              
                                    //  Navigator.pushReplacement(
                                    //  context,
                                    //  MaterialPageRoute(
                                    //  builder: (context) => CartScreen()),
                                    //  );
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isInCart
                                    ? Colors.orange
                                    : Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    isInCart
                                        ? "ALREADY ADDED 🛒"
                                        : "ADD TO CART 🛒",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                'Ingredients',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.food['ingredients'] ??
                                    'No ingredients available',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                'Terms & Conditions Of Storage',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'These terms and conditions forms an integral part of the Restaurant Information Form mentioned in Schedule A for Contactless Dining and constitute a legally binding agreement made between you, whether personally or on behalf of an entity (the "Restaurant"), and Times Internet Limited for its business division- Dineout ("Inresto"), wherein the Restaurant agrees to make Contactless Dining available at the Restaurant for the Customer.',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (reviews.isNotEmpty)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                itemCount: reviews.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return Card(
                                    color: Colors.grey.shade900,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage: NetworkImage(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn9zilY2Yu2hc19pDZFxgWDTUDy5DId7ITqA&s'),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  review['user_name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  review['review_text'],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(height: 6),
                                                Row(
                                                  children: List.generate(
                                                    review['rating'].toInt(),
                                                    (index) => Icon(Icons.star,
                                                        color: Colors.amber,
                                                        size: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
