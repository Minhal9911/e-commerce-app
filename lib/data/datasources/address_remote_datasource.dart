import 'package:e_commerce_app/data/models/address_model.dart';

class AddressRemoteDatasource {
  Future<List<AddressModel>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<void> saveAddress(AddressModel address) async {}

  Future<void> updateAddress(AddressModel address) async {}

  Future<void> deleteAddress(String id) async {}

  Future<void> setDefaultAddress(String id) async {}
}
