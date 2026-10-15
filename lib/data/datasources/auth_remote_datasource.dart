import 'package:e_commerce_app/core/constants/api_constants.dart';
import 'package:e_commerce_app/core/network/api_client.dart';
import 'package:e_commerce_app/data/models/login_req.dart';
import 'package:e_commerce_app/data/models/user_model_res.dart';
import 'package:flutter/cupertino.dart';

class AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasource(this.apiClient);

  Future<UserModel> login({required LoginRequest loginReq})async{
    final response=await apiClient.post(ApiConstants.loginEndpoint, data:loginReq.toJson());
    debugPrint("RESPONSE: ${response.data}");
    return UserModel.fromJson(response.data);
  }
}
