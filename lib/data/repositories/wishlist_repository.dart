import 'package:e_commerce_app/data/datasources/wishlist_local_datasource.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';

class WishlistRepository {
  final WishlistLocalDatasource local;

  WishlistRepository(this.local);

  Future<void> saveWishlist(List<ProductModel> products) async {
    await local.saveWishlist(products);
  }

  Future<List<ProductModel>> getWishlist() async {
    return await local.getWishlist();
  }
}
