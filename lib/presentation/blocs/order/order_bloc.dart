import 'package:e_commerce_app/core/enums/order_status.dart';
import 'package:e_commerce_app/core/enums/payment_method.dart';
import 'package:e_commerce_app/core/enums/payment_status.dart';
import 'package:e_commerce_app/data/models/order_model.dart';
import 'package:e_commerce_app/data/repositories/order_repository.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_event.dart';
import 'package:e_commerce_app/presentation/blocs/order/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repo;

  OrderBloc(this.repo) : super(const OrderState()) {
    on<LoadOrders>(_loadOrders);
    on<PlaceOrder>(_placeOrder);
    on<CancelOrder>(_cancelOrder);
    on<ResetOrderPlaced>(_resetOrderPlaced);
  }

  //LOAD ORDERS-----------------------------------------------------------------
  Future<void> _loadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final orders = await repo.getOrders();
      emit(state.copyWith(orders: orders, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  //PLACE ORDER-----------------------------------------------------------------
  Future<void> _placeOrder(PlaceOrder event, Emitter<OrderState>emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final order = OrderModel(
          id: const Uuid().v4(),
          items: event.items,
          address: event.address,
          orderDate: DateTime.now(),
          status: OrderStatus.pending,
          paymentMethod: event.paymentMethod,
          paymentStatus: event.paymentMethod == PaymentMethod.cod ? PaymentStatus.pending : PaymentStatus.paid
      );
      await repo.placeOrder(order);
      emit(state.copyWith(orders: [order,...state.orders],isLoading: false,orderPlaced: true));
    }catch(e){
      emit(state.copyWith(isLoading: false,orderPlaced: false,error: e.toString()));
    }
  }

  //CANCEL ORDER-----------------------------------------------------------------
  Future<void> _cancelOrder(CancelOrder event, Emitter<OrderState>emit)async{
    emit(state.copyWith(isLoading: true,error: null));
    try{
      await repo.cancelOrder(event.orderId);
      //We are looping this again bcz we want to update the state of UI from pending to cancelled
      //Alternative-- final orders= await repo.getOrders(); fetching fresh from storage instead of manual loop
      final updateOrders = state.orders.map((e){
        if(e.id == event.orderId){
          return e.copyWith(status: OrderStatus.cancelled);
        }
        return e;
      }).toList();
      emit(state.copyWith(orders: updateOrders,isLoading: false));
    }catch(e){
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  //Reset Order-----------------------------------------------------------------
  void _resetOrderPlaced(ResetOrderPlaced event, Emitter<OrderState> emit){
    emit(state.copyWith(orderPlaced: false));
  }
}
