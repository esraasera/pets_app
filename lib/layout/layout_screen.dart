import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/models/pet_model.dart';
import 'package:your_pets/modules/edit_profile_screen.dart';
import 'package:your_pets/modules/login/login_screen.dart';
import 'package:your_pets/modules/not_vaccinated_screen.dart';
import 'package:your_pets/modules/pets_profiles_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/styles/colors.dart';

class LayoutScreen extends StatelessWidget {

  PetModel? petModel;
  LayoutScreen({super.key, this.petModel});

  @override
  Widget build(BuildContext context) {
       return BlocConsumer<AppCubit,AppStates>(
       listener: (BuildContext context, AppStates state) {  },
       builder: (BuildContext context, AppStates state) {
       var cubit = AppCubit.get(context);
       var petImage = AppCubit.get(context).petImage;
       return SafeArea(
       child: Scaffold(
       appBar: AppBar(
             title: Text(
             cubit.titles[cubit.currentIndex],
             style: TextStyle(
             fontSize: 25.0,
             fontWeight: FontWeight.bold,
             color: defaultColor,
              ),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: defaultColor),
              toolbarHeight: 50.0,
              ),
       drawer: Drawer(
              backgroundColor: Colors.white,
              width: 280.0,
              child:Column(
              children: [
              Stack(
              alignment: AlignmentDirectional.bottomCenter,
              clipBehavior: Clip.none,
              children: [
              Container(
              height: MediaQuery.of(context).size.height / 4.5,
              width: MediaQuery.of(context).size.width,
              color: defaultColor,
              ),
              Positioned(
              top: 85.0,
              child: Material(
              shape: const CircleBorder(),
              elevation: 5.0,
              child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
              image: petImage != null
              ? FileImage(petImage)
              : (cubit.petModel?.image != null && cubit.petModel!.image.isNotEmpty
              ? CachedNetworkImageProvider(cubit.petModel!.image)
              : const AssetImage('assets/images/default_pet_image.png')) as ImageProvider,
              fit: BoxFit.cover,
              ),
              ),
              ),
              ),
              ),
              ],
              ),
              const SizedBox(
              height: 30.0,
              ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${cubit.petModel?.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),

                      Text(
                        '${cubit.petModel?.age}',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed:(){
                                  navigationTo(context, EditProfileScreen());
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.grey
                                  ),
                                ),
                                child: Text(
                                    'Edit Profile',
                                  style: TextStyle(
                                    color: defaultColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            OutlinedButton(
                              onPressed: (){
                                navigationTo(context, EditProfileScreen());
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 18.0,
                                color: defaultColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: InkWell(
                          onTap: (){
                            openEdit(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_hospital,
                                color: defaultColor,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'Vaccines',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: defaultColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.help_center,
                              color: defaultColor,
                              size: 25.0,
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: defaultColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                            cubit.petLogOut();
                            navigationTo(context, PetsProfilesScreen());
                            },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.exit_to_app,
                                color: defaultColor,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                '${cubit.petModel?.name}  '+'Log Out',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: defaultColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          cubit.userLogOut();
                          navigateAndFinish(context, LoginScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.exit_to_app,
                                color: defaultColor,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: defaultColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ) ,
            ),
       body:cubit.screens[cubit.currentIndex],
       bottomNavigationBar:  BottomNavigationBar(
            backgroundColor: Colors.white,
            iconSize: 25.0,
            currentIndex: cubit.currentIndex,
            selectedItemColor: defaultColor,
            onTap: (index){
            cubit.changeNavCurrentIndex(index);
            },
            items: const [
            BottomNavigationBarItem(
            icon:Icon(
            Icons.notifications,
            ),
            label: 'Notification',
            ),
            BottomNavigationBarItem(
            icon:Icon(
            Icons.location_on,
            ),
            label: 'Location',
            ),
            BottomNavigationBarItem(
            icon:Icon(
            Icons.medical_services,
            ),
            label: 'Consultation',
            ),
            ],
            ),
       ),
       );
       },
       );
       }
       Future<void> openEdit(BuildContext context) async {
       await showDialog(
       context: context,
       builder: (context) => AlertDialog(
       backgroundColor: Colors.white,
       content: SingleChildScrollView(
       child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
       const SizedBox(height: 10.0),
       Text(
       'Did You Vaccinate Your Pet Before?',
        style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: defaultColor,
        ),
        ),
        const SizedBox(height: 30.0),
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20.0),
        color: defaultColor,
        child: InkWell(
        onTap: () {
        Navigator.pop(context);
        navigationTo(context, NotVaccinatedScreen());
        },
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Text(
        'No',
        style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        ),
        ),
        ),
        ),
        const SizedBox(width: 45.0),
        Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20.0),
         color: defaultColor,
         child: InkWell(
         onTap: () {
         Navigator.pop(context);
         },
         child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
         decoration: BoxDecoration(
         color: defaultColor,
         borderRadius: BorderRadius.circular(20.0),
         ),
         child: const Text(
         'Yes',
         style: TextStyle(
         color: Colors.white,
         fontSize: 16.0,
         fontWeight: FontWeight.bold,
         ),
         textAlign: TextAlign.center,
         ),
         ),
         ),
         ),
         ],
         ),
         ],
         ),
         ),
         ),
         );
         }
         }
