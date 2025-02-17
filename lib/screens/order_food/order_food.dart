import 'package:flutter/material.dart';
import 'package:restaurent/model/food_item.dart';
import 'package:restaurent/screens/order_food/product_item.dart';
import 'package:restaurent/services/food_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OrderFood extends StatefulWidget {
  @override
  State<OrderFood> createState() => _OrderFoodState();
}

class _OrderFoodState extends State<OrderFood> {
  final PageController _pageController = PageController();

  String selectedCategory = "Frequent Order";
  late Future<List<FoodItem>> foodItemsFuture;

  // Sample data for different categories
  final Map<String, List<String>> categoryData = {
    "Frequent Order": ["Plain Dosa", "Idli Sambar", "Puttu Kadala"],
    "Veg": ["Veg Biryani", "Paneer Butter Masala", "Gobi Manchurian"],
    "Fish": ["Fish Fry", "Fish Curry", "Prawns Masala"],
    "Egg": ["Egg Curry", "Egg Biryani", "Omelette"],
    "Chicken": ["Chicken Biryani", "Butter Chicken", "Tandoori Chicken"],
  };

  @override
  void initState() {
    super.initState();
    foodItemsFuture = FoodService().fetchFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    AssetImage('assets/select_category/profile.png'),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deliver to",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    "Palazhi, Calicut",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Color.fromRGBO(38, 38, 45, 1),
                thickness: 1.5,
                indent: MediaQuery.of(context).size.width * 0.05,
                endIndent: MediaQuery.of(context).size.width * 0.05,
              ),
              _buildSearchBar(),
              SizedBox(height: 30),
              _buildPromoBanner(),
              SizedBox(height: 20),
              _buildPageIndicator(),
              SizedBox(height: 50),
              CategoryFilter(
                categories: categoryData.keys.toList(),
                onSelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              SizedBox(height: 20), // Add spacing
              FutureBuilder<List<FoodItem>>(
                future: foodItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading food items"));
                  }
                  final foodItems = snapshot.data ?? [];

                  if (foodItems.isEmpty) {
                    return Center(child: Text("No food items available"));
                  }

                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        final food = foodItems[index];
                        // print('food ${food.}');
                        return Card(
                          color: Colors.grey[900], // Background color
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                food.imageUrl.isNotEmpty
                                    ? Image.network(food.imageUrl,
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover)
                                    : Icon(Icons.fastfood,
                                        size: 50, color: Colors.white),
                                SizedBox(height: 10),
                                Text(food.name,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                Row(
                                  children: [
                                    Text("\$${food.carbsGrams.toStringAsFixed(2)}",
                                        style:
                                            TextStyle(color: Colors.greenAccent)),
                                  ],
                                ),
                                Text("\$${food.price.toStringAsFixed(2)}",
                                    style:
                                        TextStyle(color: Colors.greenAccent)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, right: 50),
          filled: true,
          fillColor: Colors.grey[900],
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
            size: 25,
          ),
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.white60),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🔹 Promo Banner (Carousel)
  Widget _buildPromoBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 150,
        child: PageView(
          controller: _pageController,
          children: [
            _buildPromoCard("assets/select_category/banner.png"),
            _buildPromoCard("assets/select_category/banner.png"),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Center(
        child: SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect: ScrollingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.white,
            dotColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  // 🔹 Food Grid View
  Widget _buildFoodGrid() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 2, // Only showing 2 items for demo
        itemBuilder: (context, index) {
          return _buildFoodCard("Plain Dosa", "₹80", "assets/dosa.png");
        },
      ),
    );
  }

  // 🔹 Food Item Card (Reusable)
  Widget _buildFoodCard(String title, String price, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath,
                height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(price,
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Food List (For Combination & Recommended)
  Widget _buildFoodList() {
    return Column(
      children: List.generate(3, (index) {
        return _buildListItem(
            "Appam & Stew - 2 nos", "₹180", "assets/appam.png");
      }),
    );
  }

  Widget _buildRecommendedFood() {
    return Row(
      children: [
        Expanded(
            child: _buildListItem(
                "Plain Dosa - 2 nos", "₹180", "assets/dosa.png")),
        Expanded(
            child:
                _buildListItem("Puttu & Kadala", "₹180", "assets/puttu.png")),
      ],
    );
  }

  // 🔹 List Item
  Widget _buildListItem(String title, String price, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath,
                width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(title, style: TextStyle(color: Colors.white)),
          subtitle: Text(price, style: TextStyle(color: Colors.white70)),
          trailing: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // 🔹 Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white70,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on), label: "Location"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
      ],
    );
  }
}
