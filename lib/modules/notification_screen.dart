import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/models/notification_model.dart';
import 'package:your_pets/modules/vaccination_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/styles/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {
        if (state is NotificationDeletedSuccessState) {
        }
      },
      builder: (BuildContext context, state) {
        var cubit = AppCubit.get(context);
        if (state is NotificationLoadingState) {
          return Center(child: CircularProgressIndicator(color: defaultColor,));
        } else if (state is NotificationErrorState) {
          return Center(child: Text(state.error));
        }
        return Scaffold(
          body: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ConditionalBuilder(
                      condition: cubit.notifications.isNotEmpty,
                      builder: (context) => Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  buildNotificationItem(context, index, cubit.notifications[index]),
                              itemCount: cubit.notifications.length,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              navigationTo(context, VaccinationScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.add,
                                  color: defaultColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      fallback: (BuildContext context) {
                        return Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.notifications_none,
                                size: 60.0,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'No notifications available. \nPlease add some notifications.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(
                                  height: 20.0
                              ),
                              InkWell(
                                onTap: () {
                                  navigationTo(context, VaccinationScreen());
                                },
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.add,
                                    color: defaultColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNotificationItem(context, index, NotificationModel model) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Dismissible(
        key: Key(model.id!),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          AppCubit.get(context)
              .deleteNotification(model.id!)
              .then((value) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${model.body} notification dismissed', style: TextStyle(color: defaultColor)),
                  backgroundColor: Colors.white,
                ),
              );
            }
          })
              .catchError((e) {
            print("Error: $e");
          });
        },
        background: Container(
          alignment: Alignment.centerRight,
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                Text(
                  model.body ?? 'No Title',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                    height: 5.0
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.date ?? 'No Date',
                      style: TextStyle(
                        color: defaultColor,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                        width: 5.0
                    ),
                    Icon(
                      Icons.notifications_on,
                      color: defaultColor,
                      size: 20.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}