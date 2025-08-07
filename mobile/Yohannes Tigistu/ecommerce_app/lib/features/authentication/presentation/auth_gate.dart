// import '../../Products/presentation/pages/home_page.dart';
// import 'pages/sign_in_page.dart'; // Your app's home screen

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'bloc/auth_bloc.dart';

// class AuthGate extends StatelessWidget {
//   const AuthGate({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is Authenticated) {
//           // User is signed in, show the home page
//           return HomePage();
//         } else if (state is Unauthenticated || state is AuthError) {
//           // User is not signed in, show the sign-in page
//           return SignIn();
//         }
//       },
//     );
//   }
// }
