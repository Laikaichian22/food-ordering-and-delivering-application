import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/pay_method.dart';
import 'package:flutter_application_1/src/features/users/customer_page/place_order/place_order_pages/d_select_payment_page.dart';

class RadioBtnWidget extends StatefulWidget {
  const RadioBtnWidget({
    required this.onChanged,
    required this.details,
    required this.selection,
    required this.selectedId,
    super.key
  });

  final ValueChanged<String> onChanged;
  final PaymentMethodModel details;
  final PayMethodSelection selection;
  final String selectedId;

  @override
  State<RadioBtnWidget> createState() => _RadioBtnWidgetState();
}

class _RadioBtnWidgetState extends State<RadioBtnWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all()),
          child: ListTile(
            title: Text(
              widget.details.methodName ?? 'No method name',
              style: const TextStyle(fontSize: 18),
            ),
            leading: Radio(
              value: widget.selection.id,
              groupValue: widget.selectedId,
              onChanged: (value) {
                widget.onChanged(value.toString());
              },
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

