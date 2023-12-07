
class DishModel{
  int? dishId ;
  String dishName;
  String dishPhoto;

  DishModel({
    this.dishId,
    required this.dishName,
    required this.dishPhoto,
  });

  Map<String, dynamic> toDishJason(){
   return{
    'dishName' : dishName,
    'dishPhoto' : dishPhoto,
   };
  }

  DishModel.fromMap(Map<String, dynamic> dishMap)
  : dishName = dishMap['dishName'],
    dishPhoto = dishMap['dishPhoto'];


}