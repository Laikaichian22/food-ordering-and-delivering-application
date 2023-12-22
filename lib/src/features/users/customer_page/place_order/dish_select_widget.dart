import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/models/dish.dart';

class DishSelectionWidget extends StatefulWidget {
  const DishSelectionWidget({
    required this.category,
    required this.dishes,
    required this.selectedDishIds,
    super.key
  });

  final String category;
  final List<DishModel> dishes;
  final List<String> selectedDishIds;


  @override
  State<DishSelectionWidget> createState() => _DishSelectionWidgetState();
}

class _DishSelectionWidgetState extends State<DishSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all()
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            '${widget.category}:',
            style: const TextStyle(fontSize: 20),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.dishes.length,
            itemBuilder: (context, index) {
              DishModel dish = widget.dishes[index];
              return CheckboxListTile(
                title: Text('${dish.dishSpcId}-  ${dish.dishName}'),
                value: widget.selectedDishIds.contains(dish.dishSpcId),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      widget.selectedDishIds.add(dish.dishSpcId);
                    } else {
                      widget.selectedDishIds.remove(dish.dishSpcId);
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}