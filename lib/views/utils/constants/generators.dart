import 'dart:math';

String generateCartId() {
  String str = "CID${Random().nextInt(100000).toString().padLeft(5, '0')}";

  return str;
}

// NOTE : You must check before duplicate orderid
String generateOrderId() {
  String str = "OID${Random().nextInt(100000).toString().padLeft(5, '0')}";

  return str;
}
