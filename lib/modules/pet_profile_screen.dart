import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/styles/colors.dart';

class PetProfile extends StatelessWidget {
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();
  var kindController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        var petModel = cubit.petModel;
        var petImage = cubit.petImage;
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.26,
                      width: double.infinity,
                      color: defaultColor,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 80.0,
                        right: 120.0,
                        left: 120.0,
                      ),
                      width: 130.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: petImage != null
                              ? FileImage(petImage)
                              : CachedNetworkImageProvider(
                            petModel?.image ??
                                'https://img.freepik.com/premium-vector/cartoon-dog-with-happy-expression-its-face_1249027-448.jpg?w=740',
                          ) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                InkWell(
                  onTap: () {
                    cubit.getPetImage();
                  },
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      width: 200.0,
                      padding: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                          color: defaultColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child:const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'add your pet\'s photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: defaultColor,
                              selectionHandleColor: defaultColor,
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color: defaultColor,
                              fontSize: 15.0,
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'enter your pet pet\'s name';
                              }
                              return null;
                            },
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            cursorColor: defaultColor,
                            decoration: InputDecoration(
                              hintText: ' pet\'s name',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: defaultColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: defaultColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: defaultColor)),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    selectionColor: defaultColor,
                                    selectionHandleColor: defaultColor,
                                  ),
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 15.0,
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter your pet\'s age';
                                    }
                                    return null;
                                  },
                                  controller: ageController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: defaultColor,
                                  decoration: InputDecoration(
                                    hintText: 'Pet\'s age',
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: defaultColor,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:
                                      BorderSide(color: defaultColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:
                                      BorderSide(color: defaultColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                            Expanded(
                              flex: 2,
                              child: PopupMenuButton<String>(
                                color: Colors.white,
                                onSelected: (String value) {
                                  if (ageController.text.isNotEmpty) {
                                    final ageOnly =
                                        ageController.text.split(' ').first;
                                    ageController.text = '$ageOnly $value';
                                  } else {
                                    ageController.text = '0 $value';
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: defaultColor,
                                ),
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'Day',
                                    child: Text('Day',
                                      style: TextStyle(
                                        color: defaultColor,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Week',
                                    child: Text('Week',
                                      style: TextStyle(
                                        color: defaultColor,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Month',
                                    child: Text('Month',
                                      style: TextStyle(
                                        color: defaultColor,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Year',
                                    child: Text('Year',
                                      style: TextStyle(
                                        color: defaultColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                        Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: defaultColor,
                              selectionHandleColor: defaultColor,
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color: defaultColor,
                              fontSize: 15.0,
                            ),
                            controller: genderController,
                            cursorColor: defaultColor,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'enter your pet\'s gender';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: ' pet\'s gender',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: defaultColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: defaultColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: defaultColor),
                              ),
                              suffixIcon: PopupMenuButton<String>(
                                color: Colors.white,
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: defaultColor,
                                  size: 35.0,
                                ),
                                onSelected: (String value) {
                                  genderController.text = value;
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'Male',
                                    child: Text(
                                      'Male',
                                      style: TextStyle(color: defaultColor),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Female',
                                    child: Text(
                                      'Female',
                                      style: TextStyle(color: defaultColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                        Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: defaultColor,
                              selectionHandleColor: defaultColor,
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color: defaultColor,
                              fontSize: 15.0,
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'enter your pet\'s kind';
                              }
                              return null;
                            },
                            controller: kindController,
                            keyboardType: TextInputType.text,
                            cursorColor: defaultColor,
                            decoration: InputDecoration(
                              hintText: ' pet\'s kind',
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: defaultColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: defaultColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: defaultColor)),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Divider(
                            color: Colors.transparent,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (cubit.petImage != null) {
                                try {
                                  cubit.toggleLoading();
                                  print("Uploading image...");
                                  final imageUrl = await cubit.uploadPetImage();
                                  if (imageUrl != null) {
                                    print(
                                        "Image uploaded successfully: $imageUrl");
                                    cubit.sendPet(
                                      image: imageUrl,
                                      name: nameController.text,
                                      age: ageController.text,
                                      gender: genderController.text,
                                      kind: kindController.text,
                                      dateTime: DateTime.now().toString(),
                                      context: context,
                                    );
                                  } else {
                                    print("Failed to get image URL.");
                                  }
                                } catch (error) {
                                  print("Image upload failed: $error");
                                }
                              } else {
                                cubit.toggleLoading();
                                print(
                                    "No image selected. Using default image.");
                                cubit.sendPet(
                                  image:
                                  'https://img.freepik.com/premium-vector/cartoon-dog-with-happy-expression-its-face_1249027-448.jpg?w=740',
                                  name: nameController.text,
                                  age: ageController.text,
                                  gender: genderController.text,
                                  kind: kindController.text,
                                  dateTime: DateTime.now().toString(),
                                  context: context,
                                );
                              }
                            } else {
                              print("Form validation failed.");
                            }
                          },
                          child: ConditionalBuilder(
                            condition: cubit.isLoading == false,
                            builder: (BuildContext context) => Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 20.0),
                                    decoration: BoxDecoration(
                                      color: defaultColor,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Done',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            fallback: (BuildContext context) => Center(
                              child: CircularProgressIndicator(
                                color: defaultColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}