import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/layout/layout_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/styles/colors.dart';

class VaccinationScreen extends StatelessWidget {
  VaccinationScreen({super.key});
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppAddNotificationSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Notification added successfully!',
                style: TextStyle(
                  color: defaultColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white ,
            ),
          );
        }else if (state is AppAddNotificationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to add notification.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (BuildContext context, AppStates state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: defaultColor,
                ),
              ),
            ),
            body: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'Add Notifications',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        defaultTextFormField(
                          context: context,
                          controller: nameController,
                          type: TextInputType.text,
                          text: 'Vaccine Name',
                          onFieldSubmitte:(value){
                            print(value);
                          } ,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a vaccine name';
                            }
                            return null;
                          },
                          prefix: Icons.add_task_outlined,
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          cursorColor: defaultColor,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Enter The Date',
                            suffixIcon: Icon(
                              Icons.notifications_on,
                              color: defaultColor,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: defaultColor, width: 2.0),
                            ),
                          ),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: defaultColor,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              dateController.text = DateFormat.yMMMd().format(pickedDate);
                            }
                          },
                        ),
                        const SizedBox(height: 30.0),
                        if (state is NotificationLoadingState)
                          const CircularProgressIndicator()
                        else
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  final vaccineName = nameController.text.trim();
                                  final nextDose = dateController.text.trim();
                                  final nextDoseDate = DateFormat.yMMMd().parse(nextDose);
                                  AppCubit.get(context).addNotification(
                                    vaccineName: vaccineName,
                                    nextDoseDate: nextDoseDate,
                                  );
                                  nameController.clear();
                                  dateController.clear();
                                  navigateAndFinish(context, LayoutScreen());
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: defaultColor,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Add Notification',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}