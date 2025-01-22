import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/models/user_model.dart';
import 'package:your_pets/modules/pet_profile_screen.dart';
import 'package:your_pets/modules/register/cubit/states.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/shared/components/constants.dart';

class AppRegisterCubit extends Cubit<AppRegisterStates> {

  AppRegisterCubit() : super(AppRegisterInitialState());
  static AppRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(AppRegisterLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        showToast(
          text: 'User already exists. Please sign in.',
          state: Toaststate.ERROR,
        );
        emit(AppRegisterErrorState('User already exists.'));
      }else {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value)async {
          uId = value.user!.uid;
          userCreate(
            uId: uId!,
            email: email,
            name: name,
            context: context,
          );
          navigateAndFinish(context, PetProfile());
        }).catchError((error) {
          print(error.toString());
          showToast(
            text: 'something wrong .try again later.',
            state: Toaststate.ERROR,
          );
          emit(AppRegisterErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      print(error.toString());
      emit(AppRegisterErrorState(error.toString()));
    });
  }

  void userCreate ({
    required String name,
    required String email,
    required String uId,
    required BuildContext context,
  })async{
    UserModel model =UserModel(
      name: name,
      email: email,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value){
      AppCubit.get(context).getUserData();
      emit(AppCreateUserSuccessState(uId));
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