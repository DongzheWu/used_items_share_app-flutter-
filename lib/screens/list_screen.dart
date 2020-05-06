import 'package:dz_project/models/list_items_builder.dart';
import 'package:dz_project/models/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dz_project/models/product_model.dart';
import 'package:dz_project/screens/edititem_screen.dart';
import 'package:dz_project/services/auth.dart';
import 'package:dz_project/models/database.dart';

//Create List Screen to show the list of items
class ListScreen extends StatelessWidget{
  ListScreen({@required this.auth,@required this.user});
  final AuthBase auth;
  final User user;

  @override
  Widget build(BuildContext context){

    Future<void> _signOut() async{
      try{
        await auth.signOut();
      }catch(e){
        print(e.toString());
      }
    }

    return Scaffold(
            appBar: AppBar(
              title: Text('List'),
              backgroundColor: Color(0xff6604c2),
              actions: <Widget>[

                FlatButton(
                  child: Text('Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color:Colors.white,
                    ),),
                  onPressed: _signOut,
                ),
              ],

            ),
            body:

            _buildContents(context, user),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff6604c2),
        onPressed: () => EditItemScreen.show(context, user),
      ),

        );


  }
}
//Delete function to delete itmes from the list
Future<void> _delete(BuildContext context, ProductModel item)async{
  final database = Provider.of<Database>(context);
  await database.deleteItem(item);
}

Widget _buildContents(BuildContext context, User user){
  final database = Provider.of<Database>(context);
  return StreamBuilder<List<ProductModel>>(
    stream: database.ItemsStream(),
    builder: (context, snapshot){
      return ListItemsBuilder<ProductModel>(
        snapshot: snapshot,
        itemBuilder: (context, item) => Dismissible(
          key: Key('item-${item.id}'),
          background: Container(color: Colors.red),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _delete(context, item),
          child: ProductListTile(
            product: item,
            onTap: () => EditItemScreen.show(context, user, product: item),
          ),
        )
      );
    },
  );


}

