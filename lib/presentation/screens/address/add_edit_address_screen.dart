import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/address_model.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/address/address_event.dart';
import 'package:e_commerce_app/presentation/widgets/app_button.dart';
import 'package:e_commerce_app/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  //Global key gives us direct access to a widget's state from anywhere in the class

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _address1Controller;
  late final TextEditingController _address2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _countryController;
  late final TextEditingController _postalController;

  late final ValueNotifier<bool> _isDefaultNotifier;

  bool get isEdit => widget.address != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.address?.fullName ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _address1Controller = TextEditingController(text: widget.address?.addressLine1 ?? '');
    _address2Controller = TextEditingController(text: widget.address?.addressLine2 ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _countryController = TextEditingController(text: widget.address?.country ?? '');
    _postalController = TextEditingController(text: widget.address?.postalCode ?? '');
    _isDefaultNotifier = ValueNotifier(widget.address?.isDefault ?? false);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalController.dispose();
    _isDefaultNotifier.dispose();
    super.dispose();
  }

  //VALIDATORS------------------------------------------------------------------
  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Full name is required";
    if (value.trim().length < 3) return "Name must be at least 3 characters";
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Phone is required";
    if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
  }

  String? _postalValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Postal code is required";
    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return "Enter a valid 6-digit postal code";
    }
    return null;
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "This field is required";
    return null;
  }

  //SAVE------------------------------------------------------------------------
  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final address = AddressModel(
      id: widget.address?.id ?? const Uuid().v4(),
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine1: _address1Controller.text.trim(),
      addressLine2: _address2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      postalCode: _postalController.text.trim(),
      isDefault: _isDefaultNotifier.value,
    );
    if (isEdit) {
      context.read<AddressBloc>().add(UpdateAddress(address));
    } else {
      context.read<AddressBloc>().add(AddAddress(address));
    }

    context.pop();
  }

  //BUILD-----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Address" : "Add Address")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(StaticSizes.size16),
            child: Column(
              children: [
                // FULL NAME
                AppTextField(
                  controller: _fullNameController,
                  label: "Full Name",
                  prefixIcon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  validator: _nameValidator,
                ),
                SizedBox(height: 16.h),

                // PHONE
                AppTextField(
                  controller: _phoneController,
                  label: "Phone",
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: _phoneValidator,
                ),
                SizedBox(height: 16.h),

                // ADDRESS LINE 1
                AppTextField(
                  controller: _address1Controller,
                  label: "Address Line 1",
                  prefixIcon: Icons.location_on_outlined,
                  validator: _requiredValidator,
                ),
                SizedBox(height: 16.h),

                // ADDRESS LINE 2 (optional)
                AppTextField(
                  controller: _address2Controller,
                  label: "Address Line 2 (Optional)",
                  prefixIcon: Icons.location_on_outlined,
                ),
                SizedBox(height: 16.h),

                // CITY + STATE
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _cityController,
                        label: "City",
                        validator: _requiredValidator,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppTextField(
                        controller: _stateController,
                        label: "State",
                        validator: _requiredValidator,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // COUNTRY + POSTAL CODE
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _countryController,
                        label: "Country",
                        prefixIcon: Icons.flag_outlined,
                        validator: _requiredValidator,
                      ),
                    ),
                    SizedBox(width: StaticSizes.size12),
                    Expanded(
                      child: AppTextField(
                        controller: _postalController,
                        label: "Postal Code",
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: _postalValidator,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: StaticSizes.size16),

                // SET DEFAULT SWITCH
                Card(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isDefaultNotifier,
                    builder: (context, isDefault, _) {
                      return SwitchListTile(
                        value: isDefault,
                        title: const Text("Set as Default Address"),
                        subtitle: const Text("Use this address for all orders"),
                        secondary: const Icon(Icons.home_outlined),
                        onChanged: (value) => _isDefaultNotifier.value = value,
                      );
                    },
                  ),
                ),
                SizedBox(height: StaticSizes.size30),

                // SAVE / UPDATE BUTTON
                AppButton(
                  label: isEdit ? "Update Address" : "Save Address",
                  onPressed: _saveAddress,
                ),

                SizedBox(height: StaticSizes.size16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
