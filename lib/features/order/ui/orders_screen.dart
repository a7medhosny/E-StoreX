import 'package:ecommerce/features/order/data/models/order_response_model.dart';
import 'package:ecommerce/features/order/logic/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    context.read<OrderCubit>().getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders", style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is GetOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetOrdersError) {
            return Center(
              child: Text(
                "Error: ${state.error}",
                style: TextStyle(fontSize: 14.sp),
              ),
            );
          } else if (state is GetOrdersSuccess) {
            final orders = state.orders;
            return orders == null || orders.isEmpty
                ? Center(
                  child: Text(
                    "No Orders Found",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  itemCount: orders.length,
                  padding: EdgeInsets.all(12.w),
                  itemBuilder: (context, index) {
                    return _buildOrderCard(orders[index]);
                  },
                );
          }
          return Center(
            child: Text("No Orders Found", style: TextStyle(fontSize: 14.sp)),
          );
        },
      ),
    );
  }

  /// 🟢 Card بتاع كل Order
  Widget _buildOrderCard(OrderResponseModel order) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order #${order.id?.substring(0, 6) ?? ''}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            Chip(
              label: Text(
                order.status ?? "Pending",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.blue.shade50,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Text(
            "Date: ${_formatDate(order.orderDate)}",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ),
        children: [
          Divider(color: Colors.grey.shade300),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                ...?order.orderItems?.map((item) => _buildOrderItemTile(item)),
                SizedBox(height: 8.h),
                _buildRow("Delivery:", order.deliveryMethod ?? "Standard"),
                SizedBox(height: 6.h),
                _buildRow(
                  "Total:",
                  "\$${order.total?.toStringAsFixed(2)}",
                  isBold: true,
                  valueColor: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🟢 Row للـ Key:Value
  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  /// 🟢 Item Tile لكل منتج
  Widget _buildOrderItemTile(OrderItem item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.h),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          item.mainImage ?? "",
          width: 50.w,
          height: 50.w,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) =>
                  Icon(Icons.image, size: 40.sp, color: Colors.grey),
        ),
      ),
      title: Text(
        item.productName ?? "Unknown",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
      subtitle: Text(
        "Qty: ${item.quantity}  •  \$${item.price}",
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      trailing: Text(
        "\$${(item.price ?? 0) * (item.quantity ?? 1)}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  /// 🟢 Format Date
  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat("dd MMM yyyy, hh:mm a").format(date);
  }
}
