import 'package:e_commerce_app/data/datasources/product_remote_datasource.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';

class ProductRepository {
  final ProductRemoteDatasource remote;

  ProductRepository(this.remote);

  Future<List<ProductModel>> getProducts(int skip) async {
    return remote.getProducts(skip);
  }
}
