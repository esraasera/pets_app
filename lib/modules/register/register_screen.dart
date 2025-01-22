import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:your_pets/modules/login/login_screen.dart';
import 'package:your_pets/modules/register/cubit/cubit.dart';
import 'package:your_pets/modules/register/cubit/states.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/styles/colors.dart';


class RegisterScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppRegisterCubit(),
      child: BlocConsumer<AppRegisterCubit,AppRegisterStates>(
        listener: (BuildContext context, AppRegisterStates state) {  },
        builder: (BuildContext context, AppRegisterStates state) {
          var cubit = AppRegisterCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              body:Padding(
                padding: const EdgeInsets.only(bottom:10.0,left: 20.0,right: 20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Text(
                                'SIGN UP',
                                style:TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 55.0,
                                  letterSpacing: 5.0,
                                ),
                              ),
                              Image.asset(
                                'images/rb_161004.png',
                                height: 280.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height:10.0 ,
                          ),
                          defaultTextFormField(
                            context: context,
                            controller: nameController,
                            type: TextInputType.text,
                            text: 'Name',
                            prefix: Icons.person,
                            fill: true,
                            fillColor: Colors.white,
                            onFieldSubmitte:(value){
                              print(value);
                            },
                            validate: (String? value){
                              if(value!.isEmpty){
                                return 'name must not be embty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultTextFormField(
                            context: context,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            text: 'Email Address',
                            prefix: Icons.email,
                            fill: true,
                            fillColor: Colors.white,
                            onFieldSubmitte:(value){
                              print(value);
                            },
                            validate: (String? value){
                              if(value!.isEmpty){
                                return 'email must not be embty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultTextFormField(
                              context: context,
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              isPassword: cubit.isPassword,
                              prefix:Icons.lock,
                              text: 'Password',
                              suffix: cubit.suffixIcon,
                              suffixPress:(){
                                cubit.changeSuffixIcon();
                              },
                              fill: true,
                              fillColor: Colors.white,
                              validate:(String? value){
                                if(value!.isEmpty){
                                  return 'password is too short';
                                }
                                return null;
                              } ,
                              onFieldSubmitte: (value){
                                print(value);
                              }
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! AppRegisterLoadingState,
                            builder: (BuildContext context) => defaultButton(
                                text: 'Sign Up',
                                function: (){
                                  if(formKey.currentState!.validate()){
                                    cubit.userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name:nameController.text,
                                      context: context,
                                    );
                                  }
                                }
                            ),
                            fallback: (BuildContext context) => Center(child: CircularProgressIndicator(color: defaultColor,),),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  navigateAndFinish(context, LoginScreen());
                                },
                                child: Text(
                                  'sign in',
                                  style: TextStyle(
                                    color: HexColor('9c580b'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}