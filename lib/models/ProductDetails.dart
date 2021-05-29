class ProductModel {
  String title;
  List category;
  double pointReq;
  List images;
  int stock;
  String description;

  String productID;
  ProductModel({
    this.title,
    this.productID,
    this.category,
    this.pointReq,
    this.images,
    this.stock,
    this.description,
  });
}
