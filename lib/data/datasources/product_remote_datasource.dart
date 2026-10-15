import 'package:e_commerce_app/core/constants/api_constants.dart';
import 'package:e_commerce_app/core/network/api_client.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:flutter/material.dart';

class ProductRemoteDatasource {
  final ApiClient apiClient;

  ProductRemoteDatasource(this.apiClient);

  Future<List<ProductModel>> getProducts(int skip) async {
    final response = await apiClient.get(
      ApiConstants.productsEndpoints,
      queryParameters: {"limit": 10, "skip": skip},
    );
    debugPrint('Response from API: ${response.data}');
    final List list = response.data["products"];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }
}
