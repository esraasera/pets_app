import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/modules/onboarding_screen.dart';
import 'package:your_pets/modules/pets_profiles_screen.dart';
import 'package:your_pets/shared/components/constants.dart';
import 'package:your_pets/shared/network/bloc_observer.dart';
import 'package:your_pets/shared/network/local/cache_helper.dart';
import 'package:your_pets/shared/network/remote/dio_helper.dart';
import 'package:your_pets/styles/colors.dart';

  void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  Gemini.init(apiKey: 'Add Your Key');
  Platform.isAndroid
  ?await Firebase.initializeApp(
  options: const FirebaseOptions(
  apiKey:  'Add Your Key',
  appId:  "1:913479154674:android:9321d5a11224fea3ed096b",
  messagingSenderId:"913479154674",
  projectId:"israa-2",
  storageBucket:"israa-2.firebasestorage.app"
  ))
  :await Firebase.initializeApp();

  runApp(MyApp());
  }

  class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.dark,
  ));
  late Widget widget;
  if(uId == null){
  widget = PetsProfilesScreen();
  }else
  {
  widget = OnBoardingScreen();
  }
  return MultiBlocProvider(
  providers: [
  BlocProvider(create:  (BuildContext context) => AppCubit()..getUserData()..getUserPets()..init()
  )],
  child: MaterialApp(
  debugShowCheckedModeBanner: false,
  home: widget,
  theme: ThemeData(
  appBarTheme: const AppBarTheme(
  systemOverlayStyle: SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarBrightness: Brightness.dark
  ),
  backgroundColor: Colors.white,
  elevation: 0.0
  ),
  scaffoldBackgroundColor:defaultColor,
  )
  )
  );
  }
  }
