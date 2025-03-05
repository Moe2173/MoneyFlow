// import 'package:flutter/material.dart';
// import 'package:projects/pages/signUp.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _logoAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//     _logoAnimation = Tween<Offset>(
//       begin: Offset(0, 0),
//       end: Offset(0, -0.1),
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _controller.forward();
//
//     Future.delayed(Duration(milliseconds: 2000), () {
//       Navigator.of(context).pushReplacement(PageRouteBuilder(
//         transitionDuration: Duration(milliseconds: 800),
//         pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(
//             opacity: animation,
//             child: child,
//           );
//         },
//       ));
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: SlideTransition(
//           position: _logoAnimation,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/image-removebg-preview.png', width: 150),
//               SizedBox(height: 30),
//               Text(
//                 "MoneyFlow",
//                 style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _logoAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _logoAnimation = Tween<Offset>(
//       begin: Offset(0, -0.1),
//       end: Offset(0, 0),
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SlideTransition(
//                 position: _logoAnimation,
//                 child: Image.asset('assets/image-removebg-preview.png', width: 150),
//               ),
//               SizedBox(height: 30),
//               Text(
//                 "MoneyFlow",
//                 style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Master Your Money, Own Your Future.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               ),
//               SizedBox(height: 30),
//               SizedBox(
//                 width: 200,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: Text("Log In", style: TextStyle(fontSize: 16, color: Colors.white)),
//                 ),
//               ),
//               SizedBox(height: 10),
//               SizedBox(
//                 width: 200,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[300],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.black)),
//                 ),
//               ),
//               SizedBox(height: 15),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   "Forgot Password?",
//                   style: TextStyle(color: Colors.black54, fontSize: 14),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }