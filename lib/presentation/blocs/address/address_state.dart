import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:equatable/equatable.dart';

final class AddressState extends Equatable {
  final List<AddressModel> addresses;
  final bool isLoading;
  final String? error;

  const AddressState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  AddressState copyWith({
    List<AddressModel>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  AddressModel? get defaultAddress{
    try{
      return addresses.firstWhere((e)=>e.isDefault);
    }catch(_){
      return null;
    }
  }

  @override
  List<Object?> get props => [addresses, isLoading, error];
}
