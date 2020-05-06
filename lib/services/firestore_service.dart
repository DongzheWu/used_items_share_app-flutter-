import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

//Create FiresotreService
class FirestoreService{
  FirestoreService._();
  static final instance = FirestoreService._();
//Set data to the database
  Future<void> setData({String path, Map<String, dynamic> data, List<File> images}) async{
    final reference = Firestore.instance.document(path);
    print('&path: $data');
    await reference.setData(data);
  }
// DeleteData funtion to delete data from database
  Future<void> deleteData({String path}) async{
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }){
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID),).toList());
  }
}