import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:equatable/equatable.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

final class LoadAddresses extends AddressEvent {}

final class AddAddress extends AddressEvent {
  final AddressModel address;

  const AddAddress(this.address);

  @override
  List<Object?> get props => [address];
}

final class UpdateAddress extends AddressEvent {
  final AddressModel address;

  const UpdateAddress(this.address);

  @override
  List<Object?> get props => [address];
}

final class DeleteAddress extends AddressEvent {
  final String id;

  const DeleteAddress(this.id);

  @override
  List<Object?> get props => [id];
}

final class SetDefaultAddress extends AddressEvent {
  final String id;

  const SetDefaultAddress(this.id);

  @override
  List<Object?> get props => [id];
}
