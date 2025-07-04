import 'package:clozet/models/order.dart';
import 'package:clozet/views/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../models/products.dart';
import '../../../services/product_services.dart';
import '../../utils/constants/color.dart';
import '../../utils/constants/textstyle.dart';

class OrderScreen extends StatefulWidget {
  final String userId;
  const OrderScreen({super.key, required this.userId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    orderController.fetchOrders(widget.userId);
  }

  Map<String, bool> expanded = <String, bool>{};

  Widget orderItem(OrderModel order, bool isExpanded) {
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      child: FutureBuilder<ProductModel?>(
        future: fetchProductById(order.productIds[0]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 100,
              width: double.infinity,
              child: Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.primary,
                ),
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
                    child: Image.network(product.snapshots.first,
                        height: 100, width: 100, fit: BoxFit.cover),
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
                                expanded[order.orderId] =
                                    !expanded[order.orderId]!;
                              });
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_down,
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
                  height: 300,
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    children: [Text("data")],
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
      expanded = Map<String, bool>.from(orderController.orders
          .asMap()
          .map((key, value) => MapEntry(value.orderId, false)));

      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary,
            ),
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon:
                    const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
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
            ? const Center(
                child: Text("Orders"),
              )
            : ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  final orderId = orderController.orders[index].orderId;

                  return orderItem(
                      orderController.orders[index], expanded[orderId]!);
                },
              ),
      );
    });
  }
}
