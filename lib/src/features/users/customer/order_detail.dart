import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/constants/text_strings.dart';
import 'package:flutter_application_1/src/features/auth/screens/profile/profile.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';




class OrderDetails extends StatefulWidget {
  @override
 State<OrderDetails> createState() => _ViewOrderState();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UmaiFood',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),

    );
}

  }
class _ViewOrderState extends State<OrderDetails> {
  String _email = '';

  // A variable to store the user's name
  String _name = '';

  // A variable to store the user's selected dishes
  List<String> _dishes = [];

  // A variable to store the user's selected side dishes
  List<String> _sideDishes = [];

  // A list of available dishes
  List<String> _dishOptions = [
    'Chicken Rice',
    'Nasi Lemak',
    'Mee Goreng',
    'Roti Canai',
    'Laksa',
  ];

  // A list of available side dishes
  List<String> _sideDishOptions = [
    'Egg',
    'Sambal',
    'Curry',
    'Salad',
    'Soup',
  ];

  // A method that validates the user's input and navigates to the next page
  void _nextPage() {
    // Check if the user has entered their email and name
    if (_email.isEmpty || _name.isEmpty) {
      // Show a message that the fields are required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email and name'),
        ),
      );
      return;
    }

    // Check if the user has selected at least one dish
    if (_dishes.isEmpty) {
      // Show a message that the user needs to select a dish
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
        title: Text('UmaiFood'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A container that shows the personal details section
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A text that shows the personal details section
                  Text(
                    'Personal details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // A text field for the user to enter their email
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'e.g. alicelee@gmail.com',
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Update the email variable with the user's input
                        _email = value;
                      });
                    },
                  ),
                  // A text field for the user to enter their name
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'In short form. e.g. AliceLee',
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Update the name variable with the user's input
                        _name = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            // A spacer widget that adds some vertical space
            SizedBox(height: 16.0),
            // A container that shows the dishes section
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A text that shows the dishes section
                  Text(
                    'Dishes',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // A wrap widget that shows the dish options as chips
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _dishOptions.map((dish) {
                      // A variable to store if the dish is selected or not
                      bool isSelected = _dishes.contains(dish);
                      return FilterChip(
                        label: Text(dish),
                        selected: isSelected,
                        onSelected: (value) {
                          setState(() {
                            // If the dish is selected, add it to the dishes list
                            if (value) {
                              _dishes.add(dish);
                            } else {
                              // If the dish is unselected, remove it from the dishes list
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
            // A spacer widget that adds some vertical space
            SizedBox(height: 16.0),
            // A container that shows the side dishes section
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A text that shows the side dishes section
                  Text(
                    'Side dishes',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // A wrap widget that shows the side dish options as chips
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _sideDishOptions.map((sideDish) {
                      // A variable to store if the side dish is selected or not
                      bool isSelected = _sideDishes.contains(sideDish);
                      return FilterChip(
                        label: Text(sideDish),
                        selected: isSelected,
                        onSelected: (value) {
                          setState(() {
                            // If the side dish is selected, add it to the side dishes list
                            if (value) {
                              _sideDishes.add(sideDish);
                            } else {
                              // If the side dish is unselected, remove it from the side dishes list
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
            // A spacer widget that takes up the remaining space
            Spacer(),
            // A row that shows the back and next buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // A back button that goes to the previous page
                ElevatedButton(
                  child: Text('Back'),
                  onPressed: () {
                    // TODO: Add logic for going to the previous page
                  },
                ),
                // A next button that goes to the next page
                ElevatedButton(
                  child: Text('Next'),
                  onPressed:(){},
                  )
                  ])
          ],
          )  ));
                  }}
  
          
