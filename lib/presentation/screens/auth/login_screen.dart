import 'package:e_commerce_app/config/routes/route_const.dart';
import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/dependencyInjection/injection_container.dart';
import 'package:e_commerce_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/auth/auth_event.dart';
import 'package:e_commerce_app/presentation/blocs/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LoginScreen rebuilt');
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                debugPrint('Auth Failure: ${state.message}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }

              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Login Success")),
                );
                context.go(RouteConst.home);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: StaticSizes.size20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: StaticSizes.size60),

                  /// Title
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: StaticSizes.fontSize24,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.3),

                  SizedBox(height: StaticSizes.size10),

                  Text(
                    "Login to continue",
                    style: TextStyle(
                      fontSize: StaticSizes.fontSize14,
                      color: Colors.grey,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  SizedBox(height: StaticSizes.size30),

                  /// Username Field
                  _buildTextField(
                    controller: usernameController,
                    hint: "Username",
                  ).animate().fadeIn(delay: 300.ms),

                  SizedBox(height: StaticSizes.size16),

                  /// Password Field
                  _buildTextField(
                    controller: passwordController,
                    hint: "Password",
                    isPassword: false,
                  ).animate().fadeIn(delay: 400.ms),

                  SizedBox(height: StaticSizes.size30),

                  /// Button + Loader
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return SizedBox(
                        width: double.infinity,
                        height: StaticSizes.size50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                StaticSizes.borderRadius12,
                              ),
                            ),
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              LoginRequested(
                                username: usernameController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: StaticSizes.fontSize16,
                            ),
                          ),
                        ),
                      ).animate().scale(delay: 500.ms);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable TextField
  Widget _buildTextField({required TextEditingController controller,required String hint,bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(fontSize: StaticSizes.fontSize14),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(
          horizontal: StaticSizes.size16,
          vertical: StaticSizes.size14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            StaticSizes.borderRadius12,
          ),
        ),
      ),
    );
  }
}