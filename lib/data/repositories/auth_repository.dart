//Repository = Decision Maker (“Repository decides where to get data from”)
import 'package:e_commerce_app/core/constants/app_config.dart';
import 'package:e_commerce_app/data/datasources/auth_remote_datasource.dart';
import 'package:e_commerce_app/data/models/login_req.dart';
import 'package:e_commerce_app/data/models/user_model_res.dart';

class AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepository(this.remoteDatasource);

  Future<UserModel> login({required String username,required String password}) async {
    if(AppConfig.useMock){
      return _mockLogin(username, password);
    }
    return await remoteDatasource.login(loginReq: LoginRequest(username: username, password: password));
  }

  //Mocking login for testing without actual API calls
  Future<UserModel> _mockLogin(String username,String password) async {
    await Future.delayed(const Duration(seconds: 1));

    /// Simulate failure
    if (username.isEmpty || password.isEmpty) {
      throw Exception("Please enter credentials");
    }

    /// Simulate success
    return UserModel(
      id: 1,
      username: username,
      email: 'admin123@gmail.com',
      image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      token: 'mock_token_123',
    );
  }
}
