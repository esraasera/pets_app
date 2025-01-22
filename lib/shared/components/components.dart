import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/layout_screen.dart';
import 'package:your_pets/styles/colors.dart';

Widget defaultButton({
  Color? backgroundColor,
  double radius = 15.0,
  double materialbuttonWidth = 400.0,
  required String text,
  Function? function,
}) => Container(
  height: 50.0,
  padding: EdgeInsets.all(1),
  decoration: BoxDecoration(
    color: backgroundColor != null ? backgroundColor:HexColor('9c580b'),
    borderRadius: BorderRadius.circular(radius),
  ),
  child: Center(
    child: MaterialButton(
      minWidth: materialbuttonWidth ,
      child:Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize:18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed:(){
        function!();
      },
    ),
  ),
);


Widget defaultTextFormField({
  required TextEditingController controller,
  bool isPassword = false,
  required TextInputType type,
  Function? onFieldSubmitte,
  String? Function(String?)? validate,
  bool fill = false ,
  Color? fillColor ,
  required String text,
  required IconData prefix ,
  IconData? suffix ,
  Function? suffixPress,
  context,

}) =>Theme(
  data: Theme.of(context).copyWith(
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: defaultColor,
      selectionHandleColor: defaultColor,
    ),
  ),
  child: TextFormField(
    controller:controller,
    obscureText: isPassword,
    keyboardType:type,
    onFieldSubmitted:(s){
      onFieldSubmitte!(s);
    } ,
    cursorColor:HexColor('9c580b') ,
    validator:validate,
    decoration: InputDecoration(
      filled: fill,
      fillColor: fill ? fillColor : null ,
      focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: HexColor('9c580b'))
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      hintText: text,
      prefixIcon: Icon(
        prefix,
        color: Colors.grey,
      ),
      suffixIcon: suffix != null ? IconButton(
        icon: Icon(
          suffix,
          color:HexColor('9c580b') ,
        ),
        onPressed: () {
          suffixPress!();
        },
      ):null,
    ),
  ),
);

void navigationTo(context,widget)=> Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
);

void navigateAndFinish(context,widget)=> Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
      (Route<dynamic>route) => false,
);

Widget myDivider()=> Container(
  width: double.infinity,
  height: 1.0,
  color:defaultColor,
);

void showToast({
  required String text,
  required Toaststate state,
}) =>  Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: changeToastColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

enum Toaststate {SUCCESS,ERROR,WARNING}


Color? changeToastColor(Toaststate state){

  Color color;
  switch(state){
    case Toaststate.SUCCESS:
      color =defaultColor;
      break;
    case Toaststate.ERROR:
      color = Colors.red;
      break;
    case Toaststate.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

void navigateToLayoutScreenWithPetData(BuildContext context) {
  AppCubit.get(context).changeNavCurrentIndex(0);
  navigateAndFinish(
    context,
    LayoutScreen(
      petModel:AppCubit.get(context).petModel,
    ),
  );
}