
class DishModel{
  int dishId ;
  String dishSpcId;
  String dishName;
  String dishPhoto;
  String dishType;
  int? totalStock;
  bool? isSelected;

  DishModel({
    required this.dishId,
    required this.dishSpcId,
    required this.dishName,
    required this.dishPhoto,
    required this.dishType,
    this.totalStock,
    this.isSelected = false,
  });


  Map<String, dynamic> toDishJason(){
   return{
    'dishId' : dishId,
    'dishSpecial Id' : dishSpcId,
    'dishName' : dishName,
    'dishPhoto' : dishPhoto,
    'dishType' : dishType,
    'totalInStock' : totalStock,
   };
  }

  DishModel.fromMap(Map<String, dynamic> dishMap)
  : dishId = dishMap['dishId'],
    dishSpcId = dishMap['dishSpecial Id'],
    dishName = dishMap['dishName'],
    dishType = dishMap['dishType'],
    totalStock = dishMap['totalInStock'],
    dishPhoto = dishMap['dishPhoto'];
}