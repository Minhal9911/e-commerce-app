import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:e_commerce_app/data/repositories/wishlist_repository.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_event.dart';
import 'package:e_commerce_app/presentation/blocs/wishlist/wishlist_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository repo;

  WishlistBloc(this.repo):super(const WishlistState()){
    on<LoadWishlist>(_loadWishlist);
    on<ToggleWishlist>(_toggleWishlist);
  }

  Future<void> _loadWishlist(LoadWishlist event, Emitter<WishlistState> emit)async{
   try{
     final products= await repo.getWishlist();
     emit(state.copyWith(products: products));
   }catch(e){
     debugPrint('Load error :${e.toString()}');
   }
  }

  Future<void> _toggleWishlist(ToggleWishlist event, Emitter<WishlistState> emit)async{
    final products=List<ProductModel>.from(state.products);

    final exists = products.any((e)=> e.id == event.product.id);

    if(exists){
      products.removeWhere((e)=>e.id==event.product.id);
    }else{
      products.add(event.product);
    }

    emit(state.copyWith(products: products));

    await repo.saveWishlist(products);
  }
}
