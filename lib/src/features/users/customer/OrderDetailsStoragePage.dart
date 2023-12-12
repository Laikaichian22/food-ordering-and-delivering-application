// // OrderDetailsStoragePage.dart

// import 'package:flutter/material.dart';

// class OrderDetailsStoragePage extends StatefulWidget {
//   final String email;
//   final String name;
//   final String pickupPlace;
//   final String phoneNumber;
//   final List<String> dishes;
//   final List<String> sideDishes;

//   OrderDetailsStoragePage({
//     required this.email,
//     required this.name,
//     required this.pickupPlace,
//     required this.phoneNumber,
//     required this.dishes,
//     required this.sideDishes,
//   });

//   @override
//   _OrderDetailsStoragePageState createState() => _OrderDetailsStoragePageState();
// }

// class _OrderDetailsStoragePageState extends State<OrderDetailsStoragePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Details Storage'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Email: ${widget.email}'),
//             Text('Name: ${widget.name}'),
//             Text('Pickup Place: ${widget.pickupPlace}'),
//             Text('Phone Number: ${widget.phoneNumber}'),
//             const SizedBox(height: 16.0),
//             Text('Selected Dishes: ${widget.dishes.join(', ')}'),
//             const SizedBox(height: 16.0),
//             Text('Selected Side Dishes: ${widget.sideDishes.join(', ')}'),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, 'Data Updated');
//               },
//               child: Text('Update Data'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
