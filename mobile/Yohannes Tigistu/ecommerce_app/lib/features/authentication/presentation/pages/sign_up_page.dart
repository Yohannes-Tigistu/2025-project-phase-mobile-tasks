import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/ecom_bage.dart';
import '../widgets/text.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();
  bool isChecked = false;
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/signin');
            
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[600],
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_left_rounded,
                          color: Color(0xFF3F51F3), // Primary color
                          size: 45.0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ecom(35.89),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text('Create your account', style: TextStyles.heading),
                  const SizedBox(height: 20),
                  // Sign Up Form
                  Form(
                    key: _signUpFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyles.subheading.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(15, 151, 148, 148),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'ex: jon smith',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email',
                            style: TextStyles.subheading.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(15, 151, 148, 148),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'ex: jon.smith@email.com',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Password',
                            style: TextStyles.subheading.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(15, 151, 148, 148),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              hintText: '*********',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Confirm Password',
                            style: TextStyles.subheading.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(15, 151, 148, 148),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              hintText: '*********',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isChecked,
                                activeColor: const Color(0xFF3F51F3),
                                side: const BorderSide(
                                  //PRIMARY COLOR
                                  color: const Color(0xFF3F51F3),
                                ),
                                splashRadius: 20.0,

                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                'I Understand the ',
                                style: TextStyles.body.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to terms and conditions page
                                  Navigator.pushNamed(context, '/terms');
                                },
                                child: Text(
                                  'Terms & Conditions',
                                  style: TextStyles.body.copyWith(
                                    color: const Color(
                                      0xFF3F51F3,
                                    ), // Primary color
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Sign Up Button
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_signUpFormKey.currentState?.validate() ??
                                  false) {
                                context.read<AuthBloc>().add(
                                  AuthSignupRequested(
                                    emailController.text.trim(),
                                    nameController.text.trim(),
                                    passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: const Color(0xFF3F51F3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : Text(
                                    'SIGN UP',
                                    style: TextStyles.subheading.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Have an account ? ',
                                style: TextStyles.subheading.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to terms and conditions page
                                  Navigator.pushNamed(context, '/terms');
                                },
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyles.subheading.copyWith(
                                    color: const Color(
                                      0xFF3F51F3,
                                    ), // Primary color
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
