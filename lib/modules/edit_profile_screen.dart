import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/shared/components/constants.dart';
import 'package:your_pets/styles/colors.dart';


class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();
  var kindController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        var petImage = cubit.petImage;

        nameController.text = nameController.text.isEmpty ? cubit.petModel?.name ?? '' : nameController.text;
        ageController.text = ageController.text.isEmpty ? cubit.petModel?.age ?? '' : ageController.text;
        genderController.text = genderController.text.isEmpty ? cubit.petModel?.gender ?? '' : genderController.text;
        kindController.text = kindController.text.isEmpty ? cubit.petModel?.kind ?? '' : kindController.text;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: defaultColor,
              ),
            ),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                color: defaultColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  AppCubit.get(context).updatePetProfile(
                    id: id!,
                    name: nameController.text,
                    age: ageController.text,
                    gender: genderController.text,
                    kind: kindController.text,
                  );
                  cubit.uploadPetImage();
                },
                child: Text(
                  'update',
                  style: TextStyle(
                    color: defaultColor,
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is AppPetUpdateLoadingState)
                    LinearProgressIndicator(color: defaultColor),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 4.5,
                                width: MediaQuery.of(context).size.width,
                                color: defaultColor,
                              ),
                              Positioned(
                                top: 90.0,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        cubit.getPetImage();
                                      },
                                      child: Material(
                                        shape: const CircleBorder(),
                                        elevation: 5.0,
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: petImage == null
                                                  ? CachedNetworkImageProvider(
                                                cubit.petModel!.image,
                                              ) as ImageProvider
                                                  : FileImage(petImage),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        cubit.getPetImage();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: defaultColor,
                                        radius: 16.0,
                                        child: IconButton(
                                          onPressed: () {
                                            AppCubit.get(context).getPetImage();
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(height: 10.0),
                  if (AppCubit.get(context).petImage != null)
                    Row(
                      children: [
                        if (AppCubit.get(context).petImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                TextButton(
                                  child: Text(
                                    'UPLOAD Image',
                                    style: TextStyle(
                                      color: defaultColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    AppCubit.get(context).uploadPetImage();
                                  },
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                if (state is AppPetUpdateLoadingState)
                                  LinearProgressIndicator(color: defaultColor,),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
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
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      cursorColor: defaultColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'edit your pet name',
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
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
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
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            cursorColor: defaultColor,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'edit your pet age',
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
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 10.0
                      ),
                      Expanded(
                        flex: 2,
                        child: PopupMenuButton<String>(
                          color: Colors.white,
                          onSelected: (String value) {
                            if (ageController.text.isNotEmpty) {
                              final ageOnly = ageController.text.split(' ').first;
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
                  const SizedBox(
                    height: 10.0,
                  ),
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
                      keyboardType: TextInputType.text,
                      cursorColor: defaultColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'edit your pet gender',
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
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
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
                      controller: kindController,
                      keyboardType: TextInputType.text,
                      cursorColor: defaultColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'edit your pet kind',
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}