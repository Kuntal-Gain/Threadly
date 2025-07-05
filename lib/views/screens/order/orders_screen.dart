import 'package:clozet/models/order.dart';
import 'package:clozet/views/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../models/products.dart';
import '../../../services/product_services.dart';
import '../../utils/constants/color.dart';
import '../../utils/constants/textstyle.dart';
import '../../utils/widgets/time_formatting.dart';

class OrderScreen extends StatefulWidget {
  final String userId;
  const OrderScreen({super.key, required this.userId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController orderController = Get.find<OrderController>();
  Map<String, bool> expanded = <String, bool>{};

  @override
  void initState() {
    super.initState();
    orderController.fetchOrders(widget.userId).then((_) {
      setState(() {
        for (final o in orderController.orders) {
          expanded[o.orderId] = false;
        }
      });
    });
  }

  List<String> orderStatus = [
    'Order Placed',
    'In Progress',
    'Shipping',
    'Delivered',
  ];

  Widget orderItem(OrderModel order, bool isExpanded) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      child: FutureBuilder<ProductModel?>(
        future: fetchProductById(order.productIds[0]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: CupertinoActivityIndicator(color: AppColor.primary),
              ),
            );
          }

          final product = snapshot.data!;

          return Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.snapshots.first,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  sizeHor(12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.btnGray,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyleConst().headingStyle(
                                  color: AppColor.black,
                                  size: 26,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Status : ',
                                    style: TextStyleConst().regularStyle(
                                      color: AppColor.gray,
                                      size: 22,
                                    ),
                                  ),
                                  Text(
                                    order.statuses.last.split("/").first,
                                    style: TextStyleConst().headingStyle(
                                      color: AppColor.black,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expanded.update(order.orderId, (v) => !v,
                                    ifAbsent: () => true);
                              });
                            },
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColor.gray,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isExpanded)
                Container(
                  height: 400,
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Order Status",
                            style: TextStyleConst().headingStyle(
                              color: AppColor.black,
                              size: 30,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColor.btnGray,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: order.orderId));

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: AppColor.primary,
                                        content: Center(
                                          child: Text(
                                            "Copied to clipboard",
                                            style:
                                                TextStyleConst().headingStyle(
                                              color: AppColor.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.content_copy,
                                    color: AppColor.secondary,
                                    size: 15,
                                  ),
                                ),
                                sizeHor(8),
                                Text(
                                  order.orderId,
                                  style: TextStyleConst().headingStyle(
                                    color: AppColor.secondary,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderStatus.length,
                          itemBuilder: (context, index) {
                            final status = orderStatus[index];
                            final isLast = index == orderStatus.length - 1;

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Left part: icon + line
                                Column(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index < order.statuses.length
                                            ? Colors.black
                                            : Colors.grey.shade300,
                                      ),
                                      child: index < order.statuses.length
                                          ? const Icon(Icons.check,
                                              size: 14, color: Colors.white)
                                          : null,
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 60,
                                        color:
                                            (index + 1) < order.statuses.length
                                                ? Colors.black
                                                : Colors.grey.shade300,
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                /// Right part: text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyleConst().headingStyle(
                                        color: AppColor.black,
                                        size: 23,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      index >= order.statuses.length
                                          ? ""
                                          : prettyTimestamp(order
                                              .statuses[index]
                                              .split("/")
                                              .last),
                                      style: TextStyleConst().regularStyle(
                                        color: AppColor.gray,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<ProductModel?> fetchProductById(String productId) async {
    return await ProductServices().fetchProductById(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary,
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
          ),
          title: Text(
            "Orders",
            style: TextStyleConst().headingStyle(
              color: AppColor.black,
              size: 26,
            ),
          ),
        ),
        body: orderController.orders.isEmpty
            ? const Center(child: Text("No Orders Found"))
            : ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  final order = orderController.orders[index];
                  expanded.putIfAbsent(order.orderId, () => false);

                  return orderItem(order, expanded[order.orderId]!);
                },
              ),
      );
    });
  }
}
