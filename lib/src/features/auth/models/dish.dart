
class DishModel{
  int dishId ;
  String? dishName;
  String dishPhoto;

  DishModel({
    required this.dishId,
    this.dishName,
    required this.dishPhoto,
  });


  Map<String, dynamic> toDishJason(){
   return{
    'dishId' : dishId,
    'dishName' : dishName,
    'dishPhoto' : dishPhoto,
   };
  }


  DishModel.fromMap(Map<String, dynamic> dishMap)
  : dishId = dishMap['dishId'],
    dishName = dishMap['dishName'],
    dishPhoto = dishMap['dishPhoto'];


}