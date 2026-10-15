import 'package:e_commerce_app/data/datasources/cart_local_datasource.dart';
import 'package:e_commerce_app/data/datasources/cart_remote_datasource.dart';
import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:flutter/material.dart';

/*class CartRepository {
final CartLocalDatasource local;
  CartRepository(this.local);

  Future<void> saveCart(List<CartItemModel> items) async {
    await local.saveCart(items);
  }

  List<CartItemModel> getCart() {
    return local.getCart();
  }

  Future<void> clearCart() async {
    await local.clearCart();
  }

  final CartRemoteDatasource remote;
  CartRepository(this.remote);


  Future<void> saveCart(List<CartItemModel> items) {
    return remote.saveCart(items);
  }

  Future<List<CartItemModel>> getCart() {
    return remote.getCart();
  }

  Future<void> clearCart() {
    return remote.clearCart();
  }
}*/

/// Let's combine both local and remote data sources
class CartRepository {
  final CartRemoteDatasource remote;
  final CartLocalDatasource local;

  CartRepository({required this.remote, required this.local});

  //Get cart-------------------------------------------------------------------
  Future<List<CartItemModel>> getCart() async {
    try {
      final remoteItems = await remote.getCart();
      debugPrint('remote items:${remoteItems.length}');
      await local.saveCart(remoteItems);
      return remoteItems;
    } catch (e) {
      return local.getCart();
    }
  }

  //Save cart------------------------------------------------------------------
  Future<void> saveCart(List<CartItemModel> items) async {
    await local.saveCart(items);
    try {
      await remote.saveCart(items);
    } catch (e) {
      //Handle error, maybe log it
      debugPrint('Failed to save cart remotely: $e');
    }
  }

  //Clears cart----------------------------------------------------------------
  Future<void> clearCart() async {
    await local.clearCart();
    try {
      await remote.clearCart();
    } catch (e) {
      //Handle error, maybe log it
      debugPrint('Failed to clear cart remotely: $e');
    }
  }
}
