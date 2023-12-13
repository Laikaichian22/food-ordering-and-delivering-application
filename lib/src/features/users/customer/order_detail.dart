import 'package:flutter/material.dart';

import 'package:flutter_application_1/src/features/users/customer/order_data.dart';
import 'package:flutter_application_1/src/features/users/customer/order_display_page.dart';

import 'package:flutter_application_1/src/features/users/customer/payment_methode.dart';

class OrderDetails extends StatefulWidget {
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String _email = '';
  String _name = '';
  String _pickupPlace = '';
  String _phoneNumber = '';
  List<String> _dishes = [];
  List<String> _sideDishes = [];
  List<String> _dishOptions = [
    'Chicken Rice',
    'Nasi Lemak',
    'Mee Goreng',
    'Roti Canai',
    'Laksa',
  ];
  List<String> _sideDishOptions = [
    'Egg',
    'Sambal',
    'Curry',
    'Salad',
    'Soup',
  ];

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _pickupPlaceController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateEmail);
    _nameController.addListener(_updateName);
    _pickupPlaceController.addListener(_updatePickupPlace);
    _phoneNumberController.addListener(_updatePhoneNumber);
  }

  void _updateEmail() {
    _email = _emailController.text;
  }

  void _updateName() {
    _name = _nameController.text;
  }

  void _updatePickupPlace() {
    _pickupPlace = _pickupPlaceController.text;
  }

  void _updatePhoneNumber() {
    _phoneNumber = _phoneNumberController.text;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _pickupPlaceController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

 void _nextPage() {
  // Check if all required fields are filled
  if (_email.isEmpty ||
      _name.isEmpty ||
      _pickupPlace.isEmpty ||
      _phoneNumber.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please fill in all required fields'),
      ),
    );
    return;
  }

  // Check if at least one dish is selected
  if (_dishes.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select at least one dish'),
      ),
    );
    return;
  }

  // Create an instance of OrderData
  OrderData orderData = OrderData(
    email: _email,
    name: _name,
    pickupPlace: _pickupPlace,
    phoneNumber: _phoneNumber,
    dishes: _dishes,
    sideDishes: _sideDishes,
  );

  // Navigate to OrderDisplayPage with the user input data
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OrderDisplayPage(orderData: orderData),
    ),
  );
}


  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UmaiFood'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'e.g. alicelee@gmail.com',
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'In short form. e.g. AliceLee',
                    ),
                  ),
                  TextField(
                    controller: _pickupPlaceController,
                    decoration: const InputDecoration(
                      labelText: 'Pickup Place',
                      hintText: 'E.g., Street address, landmark, etc.',
                    ),
                  ),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'E.g., +1 123-456-7890',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dishes',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _dishOptions.map((dish) {
                      bool isSelected = _dishes.contains(dish);
                      return FilterChip(
                        label: Text(dish),
                        selected: isSelected,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _dishes.add(dish);
                            } else {
                              _dishes.remove(dish);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Side dishes',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _sideDishOptions.map((sideDish) {
                      bool isSelected = _sideDishes.contains(sideDish);
                      return FilterChip(
                        label: Text(sideDish),
                        selected: isSelected,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _sideDishes.add(sideDish);
                            } else {
                              _sideDishes.remove(sideDish);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: const Text('Back'),
                  onPressed: _goBack,
                ),
                ElevatedButton(
                  child: const Text('Next'),
                  onPressed: _nextPage,
                ),
             
              ],
            ),
          ],
        ),
      ),
    );
  }
}