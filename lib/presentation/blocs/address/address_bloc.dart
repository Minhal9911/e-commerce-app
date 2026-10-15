import 'package:e_commerce_app/data/repositories/address_repository.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_event.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState>{
  final AddressRepository repo;

  AddressBloc(this.repo): super(const AddressState()){
    on<LoadAddresses>(_loadAddresses);
    on<AddAddress>(_addAddress);
    on<UpdateAddress>(_updateAddress);
    on<DeleteAddress>(_deleteAddress);
    on<SetDefaultAddress>(_setDefaultAddress);
  }

  ///Load Address---------------------------------------------------------------
  Future<void> _loadAddresses(LoadAddresses event,Emitter<AddressState> emit)async{
    emit(state.copyWith(isLoading: true));
    try{
      final addresses =await repo.getAddresses();
      emit(state.copyWith(addresses: addresses,isLoading: false,error: null));
    }catch(e){
      debugPrint(e.toString());
      emit(state.copyWith(isLoading: false,error: e.toString()));
    }
  }

  ///Add Address----------------------------------------------------------------
  Future<void> _addAddress(AddAddress event,Emitter<AddressState>emit)async{
    debugPrint('AddAddress event received:${event.address.toJson()}');
    try{
      await repo.addAddress(event.address); //POST to server
      debugPrint('Address saved to repo');
      final addresses =await repo.getAddresses(); //GET fresh list with serve IDs
      debugPrint('Addresses count: ${addresses.length}');
      emit(state.copyWith(addresses: addresses,error: null));
      // emit(state.copyWith(addresses: [...state.addresses,event.address],error: null));//we will do this in case of addresses are managed by local storage
    }catch(e){
      debugPrint("Error adding address:${e.toString()}");
      emit(state.copyWith(error: e.toString()));
    }
  }

  ///Update Address-------------------------------------------------------------
  Future<void> _updateAddress(UpdateAddress event, Emitter<AddressState> emit)async{
    try{
      await repo.updateAddress(event.address);
      final addresses = await repo.getAddresses();
      emit(state.copyWith(addresses: addresses,error: null));
    }catch(e){
      debugPrint(e.toString());
      emit(state.copyWith(error: e.toString()));
    }
  }

  ///Delete Address-------------------------------------------------------------
  Future<void> _deleteAddress(DeleteAddress event,Emitter<AddressState> emit)async{
    try{
      await repo.deleteAddress(event.id);
      final addresses = await repo.getAddresses();
      emit(state.copyWith(addresses: addresses,error: null));
    }catch(e){
      debugPrint(e.toString());
      emit(state.copyWith(error: e.toString()));
    }
  }

  ///Default Address------------------------------------------------------------
  Future<void> _setDefaultAddress(SetDefaultAddress event, Emitter<AddressState> emit)async{
    try{
      await repo.setDefaultAddress(event.id);
      final addresses = await repo.getAddresses();
      emit(state.copyWith(addresses: addresses,error: null));
    }catch(e){
      debugPrint(e.toString());
      emit(state.copyWith(error: e.toString()));
    }
  }

}

