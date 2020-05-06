import 'package:flutter/material.dart';
import 'package:dz_project/screens/empty_screen.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

//Build the list of items
class ListItemsBuilder<T> extends StatelessWidget{
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  @override
  Widget build(BuildContext context){
    //Check the content of snapshot
    if(snapshot.hasData){
      final List<T> items = snapshot.data;
      if(items.isNotEmpty){
        return _buildList(items);
      }else{
        return EmptyScreen();
      }
    }else if(snapshot.hasError){
      return EmptyScreen(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }
  //Return ListView widget of the items
  Widget _buildList(List<T> items){
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index){
        if(index == 0 || index == items.length + 1){
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },

    );
  }


}