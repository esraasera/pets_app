import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/modules/login/cubit/cubit.dart';
import 'package:your_pets/modules/login/cubit/states.dart';
import 'package:your_pets/modules/register/register_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/styles/colors.dart';


class LoginScreen extends StatelessWidget {

  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit,AppLoginStates>(
        listener: (BuildContext context, AppLoginStates state) {  },
        builder: (BuildContext context, AppLoginStates state) {
          var cubit = AppLoginCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              body:Container(
                padding:EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
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
                                'SIGN IN',
                                style:TextStyle(
                                  fontWeight:FontWeight.bold,
                                  fontSize: 55.0,
                                  letterSpacing: 5.0,
                                ),
                              ),
                              Image.asset(
                                'images/rb_161004.png',
                                height: 300.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height:10.0 ,
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
                            validate: (String? value)
                            {
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
                              isPassword:cubit.isPassword,
                              text: 'Password',
                              prefix:Icons.lock,
                              suffix: cubit.suffixIcon,
                              suffixPress:(){
                                cubit.changeSuffixIcon();
                              } ,
                              fill: true,
                              fillColor: Colors.white,
                              validate:(String? value)
                              {
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
                            condition: state is! AppLoginLoadingState,
                            builder: (BuildContext context) =>defaultButton(
                                text: 'sign in',
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context,
                                    );
                                  }
                                }
                            ),
                            fallback: (BuildContext context) =>Center(child: CircularProgressIndicator(color: defaultColor,),),
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
                                  navigateAndFinish(context, RegisterScreen());
                                },
                                child: Text(
                                  'sign up ',
                                  style: TextStyle(
                                    color: defaultColor,
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