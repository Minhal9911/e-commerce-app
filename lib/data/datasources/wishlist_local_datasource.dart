import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:get_storage/get_storage.dart';

class WishlistLocalDatasource {
  final GetStorage storage;

  WishlistLocalDatasource(this.storage);

  Future<void> saveWishlist(List<ProductModel> products)async{
    final jsonList=products.map((e)=> e.toJson()).toList();
    await storage.write(StorageKeys.wishlistKey,jsonList);
  }

  Future<List<ProductModel>> getWishlist()async{
    final data=storage.read<List>(StorageKeys.wishlistKey);
    if(data==null) return [];
    return data.map((e)=>ProductModel.fromJson(Map<String,dynamic>.from(e))).toList();
  }
}
