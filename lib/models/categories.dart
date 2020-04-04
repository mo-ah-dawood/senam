import 'package:flutter/material.dart';
class Category {
  int id;
  String name;
  String image;
  List<Category>sub_categories;
  Category({this.id,this.name,this.image,this.sub_categories});
  factory Category.fromJsonMain(Map<String,dynamic>categories){
    List<Category> subCategory=[];
   if(categories['sub_categories']!=null&&categories['sub_categories'].length>0){
     for(int i=0;i<categories['sub_categories'].length;i++)
     {
       subCategory.add(Category.fromJsonSub(categories['sub_categories'][i]));
     }
   }
    return Category(
      id: categories['id'],
      name: categories['name'],
      image: categories['image'],
      sub_categories:subCategory
    );
  }
  factory Category.fromJsonSub(Map<String,dynamic>categories){
    return Category(
      id: categories['id'],
      name: categories['name'],
      image: categories['image'],
    );
  }

}