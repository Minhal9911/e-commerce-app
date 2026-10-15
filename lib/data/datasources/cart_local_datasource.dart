import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CartLocalDatasource {
  final GetStorage storage;

  CartLocalDatasource(this.storage);


  //Saving Cart-----------------------------------------------------------------
  Future<void> saveCart(List<CartItemModel> items) async {
    final jsonList = items.map((e) => e.toJson()).toList();
    debugPrint('SAVING TO LOCAL: $jsonList');
    await storage.write(StorageKeys.cartKey, jsonList);
    debugPrint('SAVED KEY: ${StorageKeys.cartKey}');
    debugPrint('VERIFY READ: ${storage.read(StorageKeys.cartKey)}');
  }

  //Get Cart--------------------------------------------------------------------
  List<CartItemModel> getCart(){
    debugPrint('READING KEY: ${StorageKeys.cartKey}');
    final data=storage.read<List>(StorageKeys.cartKey);
    debugPrint('RAW DATA: $data');
    debugPrint('DATA TYPE: ${data.runtimeType}');
    if(data==null) return[];
    return data.map((e)=>CartItemModel.fromJson(Map<String,dynamic>.from(e))).toList();
  }

  //Clear Cart------------------------------------------------------------------
  Future<void> clearCart()async{
    await storage.remove(StorageKeys.cartKey);
  }
}
