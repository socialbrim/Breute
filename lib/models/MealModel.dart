class MealModel {
  String mealName;
  String mealDes;
  String calories;
  String recipe;
  String mealDate;
  String imageURL;
  String type;
  String vidURL;
  DateTime mealDateInDateFormat;
  MealModel({
    this.calories,
    this.imageURL,
    this.mealDate,
    this.mealDes,
    this.mealName,
    this.recipe,
    this.type,
    this.mealDateInDateFormat,
    this.vidURL,
  });
}
