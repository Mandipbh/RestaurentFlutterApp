import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/model/user_model.dart';
import 'package:restaurent/providers/order_provider.dart';
import 'package:restaurent/providers/payment_provider.dart';
import 'package:restaurent/providers/user_provider.dart';
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/screens/reserve_table/reserve_table.dart';
import 'package:restaurent/screens/settings/edit_profile_screen.dart';
import 'package:restaurent/screens/settings/order_history_page.dart';
import 'package:restaurent/screens/settings/payment_history_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isAddressExpanded = false;
  bool isOrderHistoryExpanded = false;
  bool isPaymentsExpanded = false;
  bool isResTableExpanded = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainNavigation())),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  user.imageUrl != null && user.imageUrl!.isNotEmpty
                      ? NetworkImage(_getImageUrl(user.imageUrl!))
                      : AssetImage('assets/select_category/dosa.jpg')
                          as ImageProvider,
            ),
            SizedBox(height: 10),
            Text(
              user.fullName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              user.phone,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Text(
              user.email,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 10),
            buildExpandableCard("Address", isAddressExpanded, () {
              setState(() {
                isAddressExpanded = !isAddressExpanded;
              });
            }, isAddressExpanded ? buildAddressDetails(user) : null, () {}),
            SizedBox(height: 10),
            buildExpandableCard(
              "Order history",
              isOrderHistoryExpanded,
              () {
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OrderDetailsScreen(orderId: order.id, totalPrice : order.
// totalPrice, deliveryAddress :  order.deliveryAdress)));
              },
              isOrderHistoryExpanded ? buildOrderHistoryDetails(context) : null,
              () {
                // Handle icon tap separately if needed
                setState(() {
                  isOrderHistoryExpanded = !isOrderHistoryExpanded;
                });
              },
            ),
            SizedBox(height: 10),
            buildExpandableCard(
              "Payments",
              isPaymentsExpanded,
              () {
                setState(() {
                  isPaymentsExpanded = !isPaymentsExpanded;
                  if (isPaymentsExpanded) {
                    ref.refresh(paymentProvider);
                  }
                });
              },
              isPaymentsExpanded ? buildPaymentDetails() : null,
              () {},
            ),
            SizedBox(height: 10),
            buildExpandableCard(
              "Reservation Tables",
              isResTableExpanded,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReserveTable()),
                );
              },
              isResTableExpanded ? buildPaymentDetails() : null,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  String _getImageUrl(String path) {
    final supabase = Supabase.instance.client;
    return supabase.storage.from('avatars').getPublicUrl(path);
  }

  // Rest of the methods remain the same as in the original ProfileScreen
  Widget buildExpandableCard(String title, bool isExpanded, VoidCallback onTap,
      Widget? expandedContent, onIconTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: onIconTap,
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          child: expandedContent ?? SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget buildAddressDetails(UserModel user) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Home",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          Text(user.address, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget buildOrderHistoryDetails(BuildContext context) {
    // Keeping the original implementation
    return Consumer(
      builder: (context, ref, child) {
        final orderData = ref.watch(orderProvider);
        return orderData.when(
          data: (orders) {
            if (orders.isEmpty) {
              return Center(
                  child: Text("No Orders found",
                      style: TextStyle(color: Colors.white70)));
            }

            final recentOrders = orders.take(5).toList();

            return Column(
              children: [
                ...recentOrders.map((order) {
                  String formattedDate = _formatDate(order.createdAt);

                  return Card(
                    color: Colors.grey[850],
                    child: GestureDetector(
                      onTap: () {
                        print('object');
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    "#${order.id}",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "₹${order.totalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatusChip(order.status),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      color: Colors.white38, fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(color: Colors.white10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildActionButton(Icons.local_shipping,
                                    "Track", Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderHistoryScreen()),
                    );
                  },
                  child: Text(
                    "View All Orders",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
              child: Text("Error: $err", style: TextStyle(color: Colors.red))),
        );
      },
    );
  }

  Widget buildPaymentHistoryDetails(BuildContext context) {
    // Keeping the original implementation
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [],
        );
      },
    );
  }
}

Widget buildPaymentDetails() {
  // Keeping the original implementation
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

          return Column(children: [
            ...payments.map((payment) {
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
                          SizedBox(
                            width: 10,
                          ),
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
            }).toList(),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentHistoryScreen()),
                );
              },
              child: Text(
                "View All Payments",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]);
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
            child: Text("Error: $err", style: TextStyle(color: Colors.red))),
      );
    },
  );
}

String _formatDate(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  } catch (e) {
    return "Invalid Date"; // Handle invalid date
  }
}

Widget _buildStatusChip(String status) {
  Color statusColor = Colors.blue;
  if (status == "Delivered") statusColor = Colors.green;
  if (status == "Cancelled") statusColor = Colors.red;
  if (status == "Pending") statusColor = Colors.orange;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: statusColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
          color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildActionButton(IconData icon, String label, Color color) {
  return TextButton.icon(
    onPressed: () {},
    icon: Icon(icon, color: color, size: 18),
    label: Text(label, style: TextStyle(color: color)),
    style: TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      backgroundColor: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
