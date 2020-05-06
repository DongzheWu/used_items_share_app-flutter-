import 'package:dz_project/models/product_model.dart';
import 'package:dz_project/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dz_project/widgets/image_list.dart';
import 'package:dz_project/models/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dz_project/services/path.dart';
import 'package:http/http.dart' as http;

//EditeScreen for editing item or post a new item.
class EditItemScreen extends StatefulWidget{
  const EditItemScreen({Key key, @required this.database, this.product, @required this.user}) : super(key: key);
  final Database database;
  final ProductModel product;
  final User user;

  static Future<void> show(BuildContext context, User user, {ProductModel product}) async{
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditItemScreen(database: database, product: product, user: user),
      fullscreenDialog: true,
    ),
    );
  }

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen>{
  String newTitle;
  String newPrice;
  String newDescrip;
  String url1,url2, url3, url4;
  var arr = new List(4);
  List<File> images = List<File>();
  Future<void> download(String url, String num) async{
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/${num}.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    images.add(tempFile);
  }
// Initite the page's State
  @override
  void initState(){
    super.initState();
    if(widget.product != null){
      newTitle = widget.product.title;
      newPrice = widget.product.price;
      newDescrip = widget.product.description;
      arr[0] = widget.product.url1;
      arr[1] = widget.product.url2;
      arr[2] = widget.product.url3;
      arr[3] = widget.product.url4;
      print(arr[0]);


    }
  }


  final databaseReference = FirebaseDatabase.instance.reference();
  void getData(){
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }
  // Check if the form is valid
  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  final _formKey = GlobalKey<FormState>();

// Sumbit the form and the pictures
  Future<void> _submit() async{
    if(_validateAndSaveForm()){
      final products = await widget.database.ItemsStream().first;
      final allTitles = products.map((product) => product.title).toList();
      if(widget.product != null){
        allTitles.remove(widget.product.title);
      }
      if(allTitles.contains(newTitle)){
        print('Choose different title');
      }else{
        final id = widget.product?.id ?? documentIdFromCurrentDated();




        String url1 = '';
        String url2 = '';
        String url3 = '';
        String url4 = '';
        var k = id;
        for (var i = 0; i < images.length; i++) {
//          var url = _upload(images[i], id, i);
          k = k + '1';
          var imageRefer = FirebaseStorage.instance.ref().child(Path.itemInfo(widget.user.uid, k));
          StorageUploadTask uploadTask = imageRefer.putFile(images[i]);
          arr[i] = await (await uploadTask.onComplete).ref.getDownloadURL();
          print('1111');
          if(i == 0) url1 = arr[i];
          if(i == 1) url2 = arr[i];
          if(i == 2) url3 = arr[i];
          if(i == 3) url4 = arr[i];
          print(url);
        }

        final productModel = ProductModel(id: id, title: newTitle, price: newPrice,description: newDescrip, url1: url1, url2: url2, url3: url3, url4: url4);

        await widget.database.setItems(productModel);
        Navigator.of(this.context).pop();
      }
    }
  }


  Widget build(BuildContext context){

    Future getImage(BuildContext context) async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState((){
//        _image = image;
        if(images == null) images = List<File>();
        images.add(image);
        print('Image Path $image');
      });
      Navigator.of(context).pop();
    }



    Future _openCamera(BuildContext context) async{
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState((){
//        _image = image;
        if(images == null) images = List<File>();
        images.add(image);
        print('Image Path $image');
      });
      Navigator.of(context).pop();
    }

    Future<void> _showChoiceDialog(BuildContext context){
      return showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Make a Choice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Gallary'),
                  onTap: (){
                    getImage(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0),),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: (){
                    _openCamera(context);
                  },
                ),
              ],
            ),
          )
        );
      });
    }





    return Scaffold(
      appBar: AppBar(
          elevation: 2.0,
          title: Text(widget.product == null ? 'New Item' : 'Edit Item'),
        backgroundColor: Color(0xff6604c2),
      ),
      body: new GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },

        child: Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child:Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Enter title of the item'),
                            initialValue: newTitle,
                            validator: (value) => value.isNotEmpty ? null: 'Name can\'t be empty',
                            textInputAction: TextInputAction.next,
                            onChanged: (newText){
                              newTitle = newText;
                            },

                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Enter price'),
                            initialValue: newPrice,
                            validator: (value) => value.isNotEmpty ? null: 'Price can\'t be empty',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onChanged: (newText){
                              newPrice = newText;
                            },

                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Enter description of the item'),
                            initialValue: newDescrip,
                            textInputAction: TextInputAction.next,
                            onChanged: (newText){
                              newDescrip = newText;
                            },
                          ),

                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.camera,
                              size:30,
                            ),
                            onPressed: (){
                              _showChoiceDialog(context);
                            },
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  width:350,
                                  height: 100,
                                  margin: EdgeInsets.only(
                                    top: 8,
                                    right: 10,
                                  ),

                                child: ImageList(images, arr),


                              ),



                            ],
                          )

                        ]
                    )
                ),
                new Builder(
                    builder:(BuildContext context){
                      return RaisedButton(
                        color: Color(0xff6604c2),
                        onPressed: (){

                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('You post a new item!'),
                          ));
                          _submit();


                        },
                        child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.white,
                            )
                        ),
                      );
                    }
                )

              ],
            )
        ),

      )


    );
  }

  Widget _buildContents(){

  }
}



//class AddItemScreen extends StatelessWidget{
//
//
//  Widget build(BuildContext context){
//    String newTitle;
//    String newPrice;
//    String newDescrip;
//
//    void _saveForm(){
//    }
//    return Scaffold(
//        appBar: AppBar(
//            title: Text('HyperGarageSale')
//        ),
//        body: new GestureDetector(
//          onTap: (){
//            FocusScope.of(context).requestFocus(new FocusNode());
//          },
//          child: Container(
//              margin: EdgeInsets.all(10),
//              child: ListView(
//                children: <Widget>[
//                  Form(
//                      child:Column(
//                          children: <Widget>[
//                            TextFormField(
//                              decoration: InputDecoration(labelText: 'Enter title of the item'),
//                              textInputAction: TextInputAction.next,
//                              onChanged: (newText){
//                                newTitle = newText;
//                              },
//
//                            ),
//                            TextFormField(
//                              decoration: InputDecoration(labelText: 'Enter price'),
//                              textInputAction: TextInputAction.next,
//                              keyboardType: TextInputType.number,
//                              onChanged: (newText){
//                                newPrice = newText;
//                              },
//
//                            ),
//                            TextFormField(
//                              decoration: InputDecoration(labelText: 'Enter description of the item'),
//                              textInputAction: TextInputAction.next,
//                              onChanged: (newText){
//                                newDescrip = newText;
//                              },
//                            ),
//                            Row(children: <Widget>[
//                              Container(
//                                width: 100,
//                                height: 100,
//                                margin: EdgeInsets.only(top: 8, right: 10, ),
//                                decoration: BoxDecoration(
//                                    border: Border.all(
//                                      width: 1,
//                                      color: Colors.grey,
//                                    )
//                                ),
//                                child: Container(),
//                              ),
//                              TextFormField(
//                                decoration: InputDecoration(labelText: 'Image URL'),
//                                keyboardType: TextInputType.url,
//                                textInputAction: TextInputAction.done,
//
//                              )
//                            ],)
//                          ]
//                      )
//                  ),
//                  new Builder(
//                      builder:(BuildContext context){
//                        return RaisedButton(
//                          color: Colors.blue,
//                          onPressed: (){
//                            Provider.of<Products>(context).addProduct(newTitle, newPrice,newDescrip);
////                  Navigator.of(context).push(MaterialPageRoute(
////                    builder: (ctx) => ListScreen(),
////                  ),);
//
//                            Scaffold.of(context).showSnackBar(SnackBar(
//                              content: Text('You post a new item!'),
//                            ));
//
//
//                          },
//                          child: Text('Post'),
//                        );
//                      }
//                  )
//
//                ],
//              )
//          ),
//
//        )
////        onTap: (){
////          FocusScope.of(context).requestFocus(new FocusNode());
////      },
//
//    );
//  }
//}