import 'package:flutter/material.dart';
import 'package:e_commerce_app/data/datasources/address_local_datasource.dart';
import 'package:e_commerce_app/data/datasources/address_remote_datasource.dart';
import 'package:e_commerce_app/data/models/address_model.dart';

class AddressRepository {
  final AddressLocalDatasource local;
  final AddressRemoteDatasource remote;

  AddressRepository({required this.local, required this.remote});

  /// GET ALL ADDRESS-----------------------------------------------------------
  Future<List<AddressModel>> getAddresses()async {
    try{
      final remoteAddresses = await remote.getAddresses();
      if(remoteAddresses.isNotEmpty){
        await local.replaceAddresses(remoteAddresses);
      }
      return local.getAddresses();
    }catch(e){
      debugPrint('Failed to fetch remote addresses: $e');
      return local.getAddresses();
    }
  }

  /// ADD ADDRESS---------------------------------------------------------------
  Future<void> addAddress(AddressModel address)async{
    await local.saveAddress(address);
    try{
      await remote.saveAddress(address);
    }catch(e){
      debugPrint('Failed to save address remotely: $e');
    }
  }

  /// UPDATE ADDRESS------------------------------------------------------------
  Future<void> updateAddress(AddressModel address)async{
    await local.updateAddress(address);
    try{
      await remote.updateAddress(address);
    }catch(e){
      debugPrint('Failed to update address remotely: $e');
    }
  }

  /// DELETE ADDRESS------------------------------------------------------------
  Future<void> deleteAddress(String id)async{
    await local.deleteAddress(id);
    try{
      await remote.deleteAddress(id);
    }catch(e){
      debugPrint('Failed to delete address remotely: $e');
    }
  }

  /// SET DEFAULT ADDRESS-------------------------------------------------------
  Future<void> setDefaultAddress(String id)async{
    await local.setDefaultAddress(id);
    try{
      await remote.setDefaultAddress(id);
    }catch(e){
      debugPrint('Failed to update default address remotely: $e');
    }
  }

  /// CLEAR ALL-----------------------------------------------------------------
  Future<void> clearAddresses()async{
    await local.clearAddresses();
  }
}
