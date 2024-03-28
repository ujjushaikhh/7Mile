// import 'package:flutter/material.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';

// import '../ui/Success/success_payement.dart';

// class MyPapPal extends StatelessWidget {
//   final int? cartid;
//   final String? clientid;
//   final String? secretid;
//   final String? finalPrice;
//   final String? totalPrice;
//   final String? shippingCharge;
//   final String? couponCharge;
//   final List<Map<String, dynamic>>? transactionlist;
//   const MyPapPal(
//       {super.key,
//       this.cartid,
//       this.transactionlist,
//       this.clientid,
//       this.secretid,
//       this.finalPrice,
//       this.totalPrice,
//       this.shippingCharge,
//       this.couponCharge});

//   @override
//   Widget build(BuildContext context) {
//     return UsePaypal(
//         sandboxMode: true,
//         clientId: clientid!,
//         secretKey: secretid!,
//         returnURL: "https://samplesite.com/return",
//         cancelURL: "https://samplesite.com/cancel",
//         transactions: [
//           {
//             "amount": {
//               "total": finalPrice.toString(),
//               "currency": "USD",
//               "details": {
//                 "subtotal": totalPrice!.toString(),
//                 "shipping": shippingCharge.toString(),
//                 "shipping_discount": couponCharge.toString()
//               }
//             },
//             "description": "The payment transaction description.",
//             // "payment_options": {
//             //   "allowed_payment_method":
//             //       "INSTANT_FUNDING_SOURCE"
//             // },
//             "item_list": {
//               "items": transactionlist,
//               // [
//               //   {
//               //     "name":
//               //         cartProduct.map((e) => e.name).toString(),
//               //     "quantity":
//               //         cartProduct.map((e) => e.productQty),
//               //     "price": cartProduct.map((e) => e.price),
//               //     "currency": "USD"
//               //   }
//               // ],

//               // shipping address is not required though
//               // "shipping_address": {
//               //   "recipient_name": "Jane Foster",
//               //   "line1": "Travis County",
//               //   "line2": "",
//               //   "city": "Austin",
//               //   "country_code": "US",
//               //   "postal_code": "73301",
//               //   "phone": "+00000000",
//               //   "state": "Texas"
//               // },
//             }
//           }
//         ],
//         note: "Contact us for any questions on your order.",
//         onSuccess: (Map params) {
//           debugPrint("onSuccess: $params");
//           // if (!mounted) return;
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => MySuuccessPayment(
//                         cartid: cartid,
//                       )));
//           // await checkoutapi();
//         },
//         onError: (error) {
//           debugPrint("onError: $error");
//         },
//         onCancel: (params) {
//           debugPrint('cancelled: $params');
//         });
//   }
// }
