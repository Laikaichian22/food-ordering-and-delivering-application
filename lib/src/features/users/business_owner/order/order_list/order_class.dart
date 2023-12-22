// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/src/features/auth/models/order_customer.dart';

// class OrderClass extends StatelessWidget {
//   const OrderClass({
//     required this.datalist,
//     super.key
//   });

//   final List<OrderModel> datalist;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         sortColumnIndex: 1,
//         showCheckboxColumn: false,
//         border: TableBorder.all(width: 1.0),
//         columns: const[
//           DataColumn(
//             label: Text(
//               'Time and Date'
//           )),
//           DataColumn(
//             label: Text(
//               'Destination'
//           )),
//           DataColumn(
//             label: Text(
//               'Name'
//           )),
//           DataColumn(
//             label: Text(
//               'Order 1 [1st Pack]'
//           )),
//           DataColumn(
//             label: Text(
//               'Order2+Order3 [2nd pack or more]'
//           )),
//           DataColumn(
//             label: Text(
//               'Remark'
//           )),
//           DataColumn(
//             label: Text(
//               'Payment method'
//           )),
//           DataColumn(
//             label: Text(
//               'Payment amount'
//           )),
//         ], 
//         rows: datalist.map(
//           (data) => DataRow(cells: [
//             DataCell(
//               Text(data.dateTime),
//             ),
//             DataCell(
//               Text(data.destination),
//             ),
//             DataCell(
//               Text(data.name),
//             ),
//             DataCell(
//               Text(data.orderDetails),
//             ),
//             DataCell(
//               Text(data.orderDetails),
//             ),
//             DataCell(
//               Text(data.remark),
//             ),
//             DataCell(
//               Text(data.payMethod),
//             ),
//             DataCell(
//               Text('${data.payAmount}'),
//             ),
//           ])
//         ).toList(),
//       ),
//     );
//   }
// }
