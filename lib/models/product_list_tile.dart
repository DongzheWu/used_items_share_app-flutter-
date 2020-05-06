import 'package:dz_project/models/product_model.dart';
import 'package:flutter/material.dart';

//Add tListTile to display item's title and price in the list page.
class ProductListTile extends StatelessWidget{
  final ProductModel product;
  final VoidCallback onTap;
  const ProductListTile({Key key, @required this.product, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(product.title),
      subtitle: Text('\$ ${product.price}'),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}