import 'package:flutter/material.dart';
import 'dart:io';

//Initialize the images and check the length of images
class ImageList extends StatelessWidget{
 List<File> images;
 var arr;
 ImageList(this.images, this.arr);
 int num(List<File> images, var arr){
   if(arr[0] != null && arr[0].length > 0){
     return 4;
   }else if(images != null){
     return images.length;
   }
   return 0;
 }
 //Return four images to display
  @override
  Widget build(BuildContext context){
    return ListView.builder(

        itemCount: num(images, arr),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){

          if(arr[index] != null && arr[index].length > 0){
            return Image.network(
              arr[index],
              width: 90,
              height: 70,
            );
          }
          return Image.file(
              images[index],
            width: 90,
            height: 70,
          );
        }
    );
  }

}

