import 'package:flutter/material.dart';
import 'package:your_pets/modules/login/login_screen.dart';
import 'package:your_pets/shared/components/components.dart';

class OnBoardingScreen extends StatelessWidget {
 const OnBoardingScreen({super.key});
 @override
 Widget build(BuildContext context) {
 return SafeArea(
 child: Scaffold(
 backgroundColor: Colors.grey[300],
 body: Container(
 margin: const EdgeInsets.only(bottom: 10.0),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Expanded(
   child: Image.asset(
   'images/rb_44588.png',
   ),
 ),
 Padding(
 padding: const EdgeInsets.only(left: 10.0),
 child: Container(
   height: 148.0,
   child: Text(
   'Track\nYour Pet\'s\nHealth',
   style: TextStyle(
   fontSize: 37.0,
   fontWeight: FontWeight.bold,
   color: Colors.black,
   ),
   ),
 ),
 ),
   SizedBox(
       child: Divider(
         color: Colors.transparent,
       ),
   ),
   Align(
   alignment: AlignmentDirectional.bottomEnd,
   child:Padding(
   padding: const EdgeInsets.only(right: 10.0),
   child: InkWell(
   onTap: (){
   navigateAndFinish(context, LoginScreen());
   },
   child: const Material(
   elevation: 5.0,
   shape: CircleBorder(),
   child: CircleAvatar(
   backgroundColor: Colors.black,
   radius: 44.0,
   child:Text(
   'NEXT',
   style: TextStyle(
   color: Colors.white,
   fontSize: 20.0,
   fontWeight: FontWeight.bold,
   ),
   ),
   ),
   ),
   ),
   ),
   ),
 ],
 ),
 ),
 ),
 );
 }
 }
