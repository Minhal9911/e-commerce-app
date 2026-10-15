
import 'package:e_commerce_app/data/models/order_model.dart';

class OrderRemoteDatasource {

  //PLACE ORDER----------------------------------------------------------------
  Future<void> placeOrder(OrderModel order)async{
    await Future.delayed(const Duration(milliseconds: 500));
    //TODO:call api here - For now we mocking the data
  }

  //GET ORDERS------------------------------------------------------------------
  Future<List<OrderModel>> getOrders()async{
    await Future.delayed(const Duration(milliseconds: 500),
    );
    //TODO: call api here - For now we mocking the data
    return [];
  }

  //CANCEL ORDER----------------------------------------------------------------
  Future<void> cancelOrder(String orderId)async{
    await Future.delayed(const Duration(milliseconds: 500));
    //TODO:call api here - For now we mocking the data

  }
}