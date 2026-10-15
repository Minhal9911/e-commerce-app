import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddressLocalDatasource {
  final GetStorage storage;

  AddressLocalDatasource(this.storage);

  /// SAVE ADDRESS--------------------------------------------------------------
  Future<void> saveAddress(AddressModel address)async{
    final addresses= getAddresses();
    final index = addresses.indexWhere((e)=> e.id == address.id);
    if(index == -1){
      addresses.add(address);  // new address -> insert
    }else{
      addresses[index] = address; //exits -> update
    }
    final jsonList = addresses.map((e)=>e.toJson()).toList();
    await storage.write(StorageKeys.addressKey, jsonList);
    debugPrint("Address Saved");
  }

  /// SAVE ADDRESSES------------------------------------------------------------
  Future<void> replaceAddresses(List<AddressModel> addresses)async{
    final jsonList = addresses.map((e)=> e.toJson()).toList();
    await storage.write(StorageKeys.addressKey, jsonList);
  }

  /// GET ALL ADDRESS-----------------------------------------------------------
  List<AddressModel> getAddresses(){
    final data = storage.read<List>(StorageKeys.addressKey);
    if(data==null) return [];
    return data.map((e)=>AddressModel.fromJson(Map<String,dynamic>.from(e))).toList();
  }

  /// UPDATE ADDRESS------------------------------------------------------------
  Future<void> updateAddress(AddressModel address)async {
    final addresses = getAddresses();
    final index = addresses.indexWhere((e)=> e.id == address.id);
    if(index == -1)return;
    addresses[index] = address; //replace at same index
    final jsonList = addresses.map((e)=>e.toJson()).toList();
    await storage.write(StorageKeys.addressKey, jsonList);
  }

  /// DELETE ADDRESS------------------------------------------------------------
  Future<void> deleteAddress(String id)async{
    final addresses = getAddresses();
    addresses.removeWhere((e)=> e.id == id);
    final jsonList = addresses.map((e)=>e.toJson()).toList();
    await storage.write(StorageKeys.addressKey, jsonList);
  }

  /// SET DEFAULT ADDRESS-------------------------------------------------------
  Future<void> setDefaultAddress(String id)async{
    final addresses = getAddresses();
    final updated= addresses.map((e)=> e.copyWith(isDefault: e.id == id)).toList();
    final jsonList = updated.map((e)=> e.toJson()).toList();
    await storage.write(StorageKeys.addressKey, jsonList);
  }

  /// GET DEFAULT ADDRESS-------------------------------------------------------
  AddressModel? getDefaultAddress(){
    final addresses = getAddresses();
    try{
      return addresses.firstWhere((e)=>e.isDefault);
    }catch(_){
      return null;
    }
  }

  /// CLEAR---------------------------------------------------------------------
  Future<void> clearAddresses()async{
    await storage.remove(StorageKeys.addressKey);
  }
}
