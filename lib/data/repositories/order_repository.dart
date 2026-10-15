import 'package:e_commerce_app/data/datasources/order_local_datasource.dart';
import 'package:e_commerce_app/data/datasources/order_remote_datasource.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderRepository{
  final OrderLocalDatasource local;
  final OrderRemoteDatasource remote;

  OrderRepository({required this.local,required this.remote});

  Future<void> placeOrder(OrderModel order)async{
    await local.saveOrder(order);
    try{
      await remote.placeOrder(order);
    }catch(e){
      debugPrint('Failed to place order remotely: $e');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final remoteOrders = await remote.getOrders();
      if(remoteOrders.isNotEmpty){
        await local.replaceOrders(remoteOrders);
      }
      return local.getOrders();
    } catch (e) {
      debugPrint('Failed to fetch orders remotely: $e');
      return local.getOrders();
    }
  }

  Future<void> cancelOrder(String orderId)async{
    await local.cancelOrder(orderId);
    try{
      await remote.cancelOrder(orderId);
    }catch(e){
      debugPrint('Failed to cancel order remotely: $e');
    }
  }

  Future<void> clearOrders()async{
    try{
      await local.clearOrders();
    }catch(e){
      debugPrint('Failed to clear orders remotely: $e');
    }
  }
}
