import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/models/user_model.dart';
import 'package:your_pets/modules/login/cubit/states.dart';
import 'package:your_pets/modules/pets_profiles_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/shared/components/constants.dart';

class AppLoginCubit extends Cubit<AppLoginStates> {

  AppLoginCubit() : super(AppLoginInitialState());

  static AppLoginCubit get(context) => BlocProvider.of(context);


  void userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(AppLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      uId = value.user!.uid;
      print('uId after login: $uId');
      FirebaseFirestore.instance.collection('users').doc(uId).get().then((doc) {
        if (doc.exists) {
          AppCubit.get(context).userModel = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        }
      }).catchError((error) {
      });
      AppCubit.get(context).getUserData();
      AppCubit.get(context).getUserPets();
      navigateAndFinish(context, PetsProfilesScreen());
      emit(AppLoginSuccessState(uId!));
    }).catchError((error) {
      showToast(text: 'user not found', state: Toaststate.ERROR);
      emit(AppLoginErrorState(error.toString()));
    });
  }


  bool isPassword = true ;
  IconData suffixIcon =Icons.visibility_outlined ;

  void changeSuffixIcon(){
    isPassword = ! isPassword ;
    suffixIcon = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined  ;
    emit(AppChangeSuffixIconState());
  }

}