import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:dz_project/models/product_model.dart';
import 'package:dz_project/services/path.dart';
import 'package:dz_project/services/firestore_service.dart';

//Initialze Database abstract class
abstract class Database{
  Future<void> setItems(ProductModel productModel);
  Future<void> deleteItem(ProductModel product);
  Stream<List<ProductModel>> ItemsStream();
}

String documentIdFromCurrentDated() => DateTime.now().toIso8601String();

//Create FirestoreDatabase
class FirestoreDatabase implements Database{
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;
  @override
  //Set data to Map
  Future<void> setItems(ProductModel productModel) async => await _service.setData(
    path: Path.itemInfo(uid, productModel.id),
    data: productModel.toMap(),

  );
  //Delete data from database
  @override
  Future<void> deleteItem(ProductModel productModel) async => await _service.deleteData(
    path: Path.itemInfo(uid, productModel.id),
  );
  //Get data from the Map stream
  @override
  Stream<List<ProductModel>> ItemsStream() => _service.collectionStream(
    path: Path.itemInfos(uid),
    builder: (data, documentId) => ProductModel.fromMap(data, documentId),
  );

}