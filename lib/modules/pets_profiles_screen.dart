import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/models/pet_model.dart';
import 'package:your_pets/modules/pet_profile_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/styles/colors.dart';


class PetsProfilesScreen extends StatelessWidget {
  const PetsProfilesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppGetAllPetsLoadingState) {
          Center(child: CircularProgressIndicator());
        }
      },
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Your Pets ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(
                top: 30.0,
                right: 30.0,
                left: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConditionalBuilder(
                    condition: cubit.petList.isNotEmpty,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) =>
                            InkWell(
                              onTap: () {
                                final pet = cubit.petList[index];
                                AppCubit.get(context).getPetDataById(pet.id!, context);
                              },
                              onLongPress: () {
                                showDeleteConfirmationDialog(context, cubit, index);
                              },
                              child: BuildYourPet(
                                  cubit.petList[index], context),
                            ),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 20.0),
                        itemCount: cubit.petList.length,
                      ),
                    ),
                    fallback: (context) => Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.menu,
                            color: Colors.grey,
                            size: 170,
                          ),
                          Text(
                            'Add Your Pets',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 50.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          navigateAndFinish(context, PetProfile());
                        },
                        child: Icon(
                          Icons.add_circle_rounded,
                          size: 45.0,
                          color: Colors.grey,
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

  void showDeleteConfirmationDialog(BuildContext context, AppCubit cubit, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:defaultColor,
          title: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Are you sure you want to delete this pet?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 40.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color:Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        cubit.deletePet(cubit.petList[index].id!);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Deleting Done',
                              style: TextStyle(
                                  fontSize: 13.0
                              ),
                            ),
                            backgroundColor: Colors.red[500],
                          ),
                        );
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget BuildYourPet(PetModel model, context) => Material(
    elevation: 10.0,
    borderRadius: BorderRadiusDirectional.only(
      bottomStart: Radius.circular(10.0),
      topStart: Radius.circular(10.0),
      topEnd: Radius.circular(10.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10.0),
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        child: Row(
          children: [
            Material(
              shape: CircleBorder(),
              elevation: 5.0,
              child: Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      '${model.image}',
                      errorListener: (value) {},
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                Text(
                  '${model.age}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
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