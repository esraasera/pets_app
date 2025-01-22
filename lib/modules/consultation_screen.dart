import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/styles/colors.dart';

class ColsultationScreen extends StatelessWidget {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cubit.messages.isNotEmpty
                      ? ListView.builder(
                    itemBuilder: (context, index) => messageState(
                      sender: cubit.messages[index]['sender'] ?? false,
                      text: cubit.messages[index]['text'],
                    ),
                    itemCount: cubit.messages.length,
                  )
                      : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 150.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'What is your pet\'s health condition?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 70.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: defaultColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 260.0,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: defaultColor,
                              selectionHandleColor: defaultColor,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: controller,
                              cursorColor: defaultColor,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                hintText: ' Ask Your Question...',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          onPressed: () {
                            cubit.add(controller,cubit.messages);
                            controller.clear();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 33.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class messageState extends StatelessWidget {
  bool sender;
  String text;
  messageState({super.key, required this.sender, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: sender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: sender ? defaultColor : Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}