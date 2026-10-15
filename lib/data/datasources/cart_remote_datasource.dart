import 'package:e_commerce_app/core/constants/api_constants.dart';
import 'package:e_commerce_app/core/network/api_client.dart';
import 'package:e_commerce_app/data/models/cart_item_model.dart';
import 'package:flutter/material.dart';

class CartRemoteDatasource {
  final ApiClient _apiClient;

  CartRemoteDatasource(this._apiClient);

  Future<void> saveCart(List<CartItemModel> items)async{
    try{
      final body = {
        "items": items.map((e) => {
          "product_id": e.product.id,
          "quantity": e.quantity,
        }).toList(),
      };
      final res=await _apiClient.post(ApiConstants.saveCartEndpoint,data: body);
      debugPrint('SAVE CART RESPONSE: ${res.data}');
    }catch(e){
      debugPrint('Remote save error: $e');
    }
  }

  Future<List<CartItemModel>> getCart()async{
    final response= await _apiClient.get(ApiConstants.cartEndpoint);
    final list= response.data['items']as List;
     return list.map((e)=>CartItemModel.fromJson(e)).toList();
  }

  Future<void> clearCart()async{
    await _apiClient.delete(ApiConstants.cartEndpoint);
  }
}