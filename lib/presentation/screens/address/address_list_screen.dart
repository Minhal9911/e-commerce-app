import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_event.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_state.dart';
import 'package:e_commerce_app/presentation/widgets/address_card.dart';
import 'package:e_commerce_app/presentation/widgets/app_empty_view.dart';
import 'package:e_commerce_app/presentation/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Addresses")),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if(state.isLoading){
            return const AppLoader();
          }
          if(state.addresses.isEmpty){
            return const AppEmptyView(
              icon: Icons.location_off_outlined,
              message: "No addresses found",
              subMessage: "Add a delivery address to get started",
            );
          }

          return ListView.builder(
            itemCount: state.addresses.length,
            padding: EdgeInsets.all(StaticSizes.size16),
            itemBuilder: (BuildContext context, int index) {
              final address = state.addresses[index];

              return AddressCard(address: address,
                  onEdit: (){
                context.push(RouteConst.addEditAddressPath,extra: {
                  "bloc" : context.read<AddressBloc>(),
                  "address" : address,
                });
              }, onDelete: (){
                context.read<AddressBloc>().add(DeleteAddress(address.id));
              }, onSetDefault: (){
                context.read<AddressBloc>().add(SetDefaultAddress(address.id));
              });

          },);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.push(RouteConst.addEditAddressPath,
          extra:{
            "bloc" : context.read<AddressBloc>(),
            "address" : null,
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
