import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/ecom_bage.dart';
import '../widgets/text.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to home page on successful login
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    ecom(85.89),
                    const SizedBox(height: 60),
                    const Text(
                      'Sign into your account',
                      style: TextStyles.heading,
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                //no outline
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
                                //regex for email validation
                                final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            //password
                            Text(
                              'Password',
                              style: TextStyles.subheading.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(15, 151, 148, 148),
                                filled: true,
                                //no outline
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: '**********',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            //sign in button
                            ElevatedButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  print('Email: ${emailController.text}');
                                  print('Password: ${passwordController.text}');
                                  // Trigger sign-in logic
                                  context.read<AuthBloc>().add(
                                    AuthLoginRequested(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),

                                      // i want to check the strings to print them
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
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'SIGN IN',
                                      style: TextStyles.subheading,
                                    ),
                            ),

                            const SizedBox(height: 100),

                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyles.subheading.copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to sign up page
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyles.body.copyWith(
                                      color: const Color(0xFF3F51F3),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
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
            ),
          );
        },
      ),
    );
  }
}
