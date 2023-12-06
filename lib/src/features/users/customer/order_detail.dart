import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  @override
  State<OrderDetails> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<OrderDetails> {
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

  void _nextPage() {
    if (_email.isEmpty || _name.isEmpty || _pickupPlace.isEmpty || _phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
        ),
      );
      return;
    }

    if (_dishes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one dish'),
        ),
      );
      return;
    }

    // TODO: Add logic for navigating to the next page
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
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'e.g. alicelee@gmail.com',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'In short form. e.g. AliceLee',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Pickup Place',
                      hintText: 'E.g., Street address, landmark, etc.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _pickupPlace = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'E.g., +1 123-456-7890',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
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
                  onPressed: () {
                    // TODO: Add logic for going to the previous page
                  },
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

void main() {
  runApp(MaterialApp(
    title: 'UmaiFood',
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: OrderDetails(),
  ));
}
