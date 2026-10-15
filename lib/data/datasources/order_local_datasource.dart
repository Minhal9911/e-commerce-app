import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/core/enums/order_status.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class OrderLocalDatasource {
  final GetStorage storage;

  OrderLocalDatasource(this.storage);

  //SAVE ORDER------------------------------------------------------------------
  Future<void> saveOrder(OrderModel order)async{
    final orders = getOrders();
    orders.insert(0, order);
    final jsonList = orders.map((e)=>e.toJson()).toList();
    debugPrint('Saving order: $jsonList');
    await storage.write(StorageKeys.orderKey, jsonList);
  }

  //SAVE ORDERS-----------------------------------------------------------------
  Future<void> replaceOrders(List<OrderModel> orders)async{
    final jsonList = orders.map((e)=>e.toJson()).toList();
    await storage.write(StorageKeys.orderKey, jsonList);
  }

  //GET ORDERS------------------------------------------------------------------
  List<OrderModel> getOrders(){
    final data = storage.read<List>(StorageKeys.orderKey);
    if(data==null)return[];
    return data.map((e)=>OrderModel.fromJson(Map<String,dynamic>.from(e))).toList();
  }

  //CANCEL ORDER----------------------------------------------------------------
  Future<void> cancelOrder(String orderId)async{
    final orders = getOrders();
    final updateOrders = orders.map((e){
      if(e.id == orderId){
        return e.copyWith(status: OrderStatus.cancelled);
      }
      return e;
    }).toList();
    await replaceOrders(updateOrders);
  }

  //CLEAR ORDERS----------------------------------------------------------------
  Future<void> clearOrders()async{
    await storage.remove(StorageKeys.orderKey);
  }
}
