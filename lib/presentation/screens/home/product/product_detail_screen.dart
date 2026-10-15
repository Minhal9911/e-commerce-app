import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/core/utils/snackbar_helper.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/cart/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: "product_${product.id}",
            child: CachedNetworkImage(
              imageUrl: product.thumbnail,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(padding: EdgeInsets.all(StaticSizes.size16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.title,
              style: TextStyle(fontSize: StaticSizes.fontSize18,
              fontWeight: FontWeight.bold),),
              SizedBox(height: StaticSizes.size8,),
              Text("\$${product.price}",style: TextStyle(fontSize: StaticSizes.fontSize16,color: Colors.green),),
              SizedBox(height: StaticSizes.size16,),
              Text("Product Description goes here....")
            ],
          ),),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(StaticSizes.size16),
            child: SizedBox(
              width: double.infinity,
                child: ElevatedButton(onPressed: (){

                  context.read<CartBloc>().add(AddToCart(product));

                  SnackBarHelper.show(context, msg: 'Added to cart');

                }, child: Text("Add to Cart"),)),
          )
        ],
      ),
    );
  }
}
