import 'package:meta/meta.dart';
class ProductModel{
  ProductModel({@required this.id, @required this.title, @required this.price, @required this.description, this.url1, this.url2, this.url3, this.url4});
  final String id;
  final String title;
  final String price;
  final String description;
  final String url1;
  final String url2;
  final String url3;
  final String url4;


  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId){
    if(data == null){
      return null;
    }

    final String title = data['Title'];
    final String price = data['Price'];
    final String desc = data['Desc'];
    final String url1 = data['Url1'];
    final String url2 = data['Url2'];
    final String url3 = data['Url3'];
    final String url4 = data['Url4'];


    return ProductModel(
      id: documentId,
      title: title,
      price: price,
      description: desc,
      url1: url1,
      url2: url2,
      url3: url3,
      url4: url4,
    );
  }

  Map<String, dynamic> toMap(){

    return{
      'Title': title,
      'Price': price,
      'Desc': description,
      'Url1': url1,
      'Url2': url2,
      'Url3': url3,
      'Url4': url4,

    };
  }
}