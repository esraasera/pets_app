import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:your_pets/models/notification_model.dart';
import 'package:your_pets/models/pet_model.dart';
import 'package:your_pets/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:your_pets/modules/consultation_screen.dart';
import 'package:your_pets/modules/location_screen.dart';
import 'package:your_pets/modules/notification_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/shared/components/constants.dart';
import '../../shared/network/remote/dio_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

  class AppCubit extends Cubit<AppStates> {


  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeNavCurrentIndex(int index) {
  currentIndex = index;
  emit(AppChangeBottomNavIndexState());
  }

  List<Widget>screens = [
  const NotificationScreen(),
  const LocationScreen(),
  ColsultationScreen(),
  ];

  List<String>titles = [
  'Notifications Screen',
  'Nearby Vet Clinics',
  'Vet Screen',
  ];

  UserModel? userModel ;

  void getUserData(){
  emit(AppGetUserLoadingState());
   FirebaseFirestore.instance
   .collection("users")
   .doc(uId)
   .get()
   .then((value){
   userModel= UserModel.fromJson(value.data() as Map<String, dynamic>);
   emit(AppGetUserSuccessState());
    })
    .catchError((error){
    emit(AppGetUserErrorState(error.toString()));
    }
    );
    }

    bool isLoading = false;

    void toggleLoading() {
    isLoading = !isLoading;
    emit(AppLoadingState());
    }

   PetModel? petModel;

    void sendPet({
    required String image,
    required String name,
    required String age,
    required String gender,
    required String kind,
    required String dateTime,
    required BuildContext context,
    }) {
    emit(AppSendUserPetsLoadingState());
    petModel = PetModel(
      image: image,
      name: name,
      age: age,
      gender: gender,
      kind: kind,
      dateTime: dateTime,
      id: '',
    );
    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .collection('pets')
    .add(petModel!.toMap())
    .then((value) {
         id = value.id;
      petModel = petModel!.copyWith(id: id);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('pets')
          .doc(id)
          .set(petModel!.toMap())
          .then((value){
        showToast(text: 'Add successfully', state: Toaststate.SUCCESS);
        navigateToLayoutScreenWithPetData(context);
        getPetData();
        getUserPets();
      });
    }).catchError((error) {
    emit(AppSendUserPetsErrorState(error.toString()));
    });
    }


    List<PetModel> petList = [];

    void getUserPets() {
    emit(AppGetAllPetsLoadingState());
    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .collection('pets')
    .orderBy('dateTime')
    .get()
    .then((querySnapshot) {
    petList=[];
    for (var doc in querySnapshot.docs) {
    petList.add(PetModel.fromJson(doc.data()));
    }
    emit(AppGetAllPetsSuccessState());
    }).catchError((error) {
    emit(AppGetAllPetsErrorState(error.toString()));
    });
    }


    void getPetData(){
     emit(AppGetPetLoadingState());
     FirebaseFirestore.instance
     .collection("users")
     .doc(uId)
     .collection('pets')
     .doc(id)
     .get().
     then((value){
     petModel= PetModel.fromJson(value.data() as Map<String, dynamic>);
     toggleLoading();
     emit(AppGetPetSuccessState());
     })
     .catchError((error){
     emit(AppGetPetErrorState(error.toString()));
     }
     );
     }


    File? file;
    List messages=[];

     void getPetDataById(String petId, BuildContext context) {
     emit(AppGetPetLoadingState());
     FirebaseFirestore.instance
     .collection("users")
     .doc(uId)
     .collection("pets")
     .doc(petId)
     .get()
     .then((value) {
     id =value.id;
     getMessages(petId: id!);
     getUserNotifications();
     petModel = PetModel.fromJson(value.data() as Map<String, dynamic>);
     emit(AppGetPetSuccessState());
     navigateToLayoutScreenWithPetData(context);
     }).catchError((error) {
     emit(AppGetPetErrorState(error.toString()));
     });
     }


     void deletePet(String petId) {
      emit(AppDeletePetLoadingState());
      FirebaseFirestore.instance
      .collection("users")
      .doc(uId)
      .collection("pets")
      .doc(petId)
      .delete()
      .then((value) {
      getUserPets();
      emit(AppDeletePetSuccessState());
      }).catchError((error) {
      emit(AppDeletePetErrorState(error.toString()));
      });
      }


     File? petImage;
     var picker = ImagePicker();
      Future<void> getPetImage()async{
      final pickedFile = await picker.pickImage(
      source:ImageSource.gallery,
      );
      if(pickedFile != null){
      petImage = File(pickedFile.path);
      emit(AppPickedPetImageSuccessState());
      }else
      {
      print('No image selected');
      emit(AppPickedPetImageErrorState());
      }
      }

      Future<String?> uploadPetImage() {
      if (petImage == null) {
      print('No image to upload');
      emit(AppPickedPetImageErrorState());
      return Future.value(null);
      }
     emit(AppUploadPetImageLoadingState());
     final storageRef = firebase_storage.FirebaseStorage.instance
     .ref()
     .child('pets/${Uri.file(petImage!.path).pathSegments.last}');

     return storageRef.putFile(petImage!).then((uploadTask) {
     return uploadTask.ref.getDownloadURL().then((imageUrl) {
     updatePetImage(photoUrl: imageUrl, petId:id!).then((_) {
     emit(AppUploadPetImageSuccessState());
     }).catchError((error) {
     emit(AppUploadPetImageErrorState());
     });
     return imageUrl;
     }).catchError((error) {
     emit(AppUploadPetImageErrorState());
     throw error;
     });
     }).catchError((error) {
     emit(AppUploadPetImageErrorState());
     throw error;
     });
     }


     void add(var controller, List message) {
     if (controller.text.isNotEmpty) {
      bool sender = true;
      message.add({
      'text': controller.text,
      'sender': sender,
      });
      String conversation = "";
      for (var msg in message) {
        conversation += "${msg['sender'] ? 'User: ' : 'Gemini: '}${msg['text']}\n";
      }
      sendMessage(
      petId: id!,
      senderId: uId!,
      dateTime: DateTime.now().toString(),
      text: controller.text,
      sender: sender,
      );
      Gemini gemini = Gemini.instance;
      gemini.text(conversation).then((value) {
      message.add({
      'text': value!.output,
      'sender': false,
      });
      sendMessage(
      petId: id!,
      senderId: uId!,
      dateTime: DateTime.now().toString(),
      text: value.output!,
      sender: false,
      );
      emit(AppGetGeminiMessageSuccessfulState());
      });
      emit(AppSendingUserMessageSuccessfulState());
      }
      }


    void sendMessage({
    required String petId,
    required String senderId,
    required String dateTime,
    required String text,
    required bool sender,
    }) async {
    Map<String, dynamic> messageData = {
    'text': text,
    'sender': sender,
    'timestamp': FieldValue.serverTimestamp(),
    };
    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .collection('pets')
    .doc(petId)
    .collection('messages')
    .add(messageData)
    .then((value) {
    emit(AppSendingUserMessageSuccessfulState());
    }).catchError((error) {
    emit(AppSendingUserMessageErrorState(error.toString()));
    });
    }


    void getMessages({required String petId}) {
     FirebaseFirestore.instance
     .collection("users")
     .doc(uId)
     .collection("pets")
     .doc(petId)
     .collection("messages")
     .orderBy('timestamp', descending: false)
      .get()
     .then((querySnapshot) {
      messages.clear();
      querySnapshot.docs.forEach((doc) {
       messages.add({
      'text': doc['text'],
      'sender': doc['sender'],
      'timestamp': doc['timestamp'],
       });
       });
       emit(AppGetMessagesSuccessState());
       }).catchError((error) {
       emit(AppGetMessagesErrorState(error.toString()));
       print(error.toString());
       });
       }
       Future<void> updatePetImage({
       required String petId,
       required photoUrl,
       }) async {
       emit(AppPetUpdateLoadingState());
       if (id!.isEmpty) {
       emit(AppPetUpdateErrorState("Invalid data for update"));
       return;
       }
       FirebaseFirestore.instance
       .collection("users")
       .doc(uId)
       .collection('pets')
       .doc(id)
       .update({"image": photoUrl})
       .then((value) {
       })
       .catchError((error) {
       emit(AppPetUpdateErrorState(error.toString()));
       });
       }


      void updatePetProfile({
       required String id,
       required String name,
       String? image,
       required String age,
       required String kind,
       required String gender
       }){
       emit(AppPetUpdateLoadingState());
       toggleLoading();
       PetModel model = PetModel(
       name: name,
       image:image??petModel!.image,
       dateTime:petModel!.dateTime,
       kind: kind,
       gender: gender,
       age: age,
       id: id,
       );
       FirebaseFirestore.instance
       .collection("users")
       .doc(userModel!.uId)
       .collection('pets')
       .doc(id)
       .update(model.toMap())
       .then((value) {
        getPetData();
        getUserPets();
        })
       .catchError((error){
        emit(AppPetUpdateErrorState(error.toString()));
        });
        }

         void petLogOut() {
         id = '';
         petImage = null;
         petModel?.image ='https://img.freepik.com/premium-vector/cartoon-dog-with-happy-expression-its-face_1249027-448.jpg?w=740';
         messages=[];
         notifications=[];
         getUserPets();
         emit(AppPetLogOutSuccessState());
         }



    void userLogOut() {
    uId = '';
    id = '';
    petModel?.image ='https://img.freepik.com/premium-vector/cartoon-dog-with-happy-expression-its-face_1249027-448.jpg?w=740';
    petList=[];
    notifications=[];
    emit(AppUserLogOutSuccessState());
    }


  void initializeMap() {
  emit(LocationLoading());
  Location location = Location();
  location.serviceEnabled().then((serviceEnabled) {
   if (!serviceEnabled) {
   location.requestService().then((serviceRequested) {
   if (!serviceRequested) {
   emit(LocationError("Location service is disabled."));
   return;
   }}).catchError((error) {
   emit(LocationError("Error requesting service: $error"));
   });
   } else {
   checkPermission(location);
   }
   }).catchError((e) {
   emit(LocationError("Error checking service status: $e"));
    });
    }


     void checkPermission(Location location) {
     location.hasPermission().then((permissionGranted) {
     if (permissionGranted == PermissionStatus.denied) {
     location.requestPermission().then((permissionStatus) {
     if (permissionStatus != PermissionStatus.granted) {
     emit(LocationError("Permission denied."));
     return;
     }
     getUserLocation(location);
     }).catchError((error) {
     emit(LocationError("Error requesting permission: $error"));
     });
     } else {
     getUserLocation(location);
     }
     }).catchError((e) {
     emit(LocationError("Error checking permission status: $e"));
     });
     }

    void getUserLocation(Location location) {
    location.getLocation().then((userLocation) {
    final userLatLng = LatLng(userLocation.latitude!, userLocation.longitude!);
    final cameraPosition = CameraPosition(target: userLatLng, zoom: 14);

    final markers = [
    Marker(
    markerId: const MarkerId("user"),
    position: userLatLng,
    infoWindow: const InfoWindow(title: "You are here"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
    ];

    getNearbyVetClinics(userLatLng).then((clinicMarkers) {
    markers.addAll(clinicMarkers);
    emit(LocationLoaded(cameraPosition, markers));
    }).catchError((e) {
    emit(LocationError("Error : $e"));
    });
    }).catchError((e) {
    emit(LocationError("Error : $e"));
    });
    }


  Future<List<Marker>> getNearbyVetClinics(LatLng userLatLng) {
  const String googleApiKey = 'Add Your Key';
  const String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  final queryParams = {
  'location': '${userLatLng.latitude},${userLatLng.longitude}',
  'radius': 5000,
  'type': 'veterinary_care',
  'key': googleApiKey,
  };
  return DioHelper.getData(url: baseUrl, query: queryParams).then((response) {
  if (response.statusCode == 200) {
  final List results = response.data['results'];

  List<Marker> markers = results.map<Marker>((place) {
  final LatLng placeLatLng = LatLng(
  place['geometry']['location']['lat'],
  place['geometry']['location']['lng'],
  );
  return Marker(
  markerId: MarkerId(place['place_id']),
  position: placeLatLng,
  infoWindow: InfoWindow(title: place['name']),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );
  }).toList();

  return markers;
  } else {
  throw Exception("Failed to fetch vet clinics: ${response.statusCode}");
  }
  }).catchError((error) {
  throw Exception("Error fetching vet clinics: $error");
  });
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings =
  const AndroidInitializationSettings('@mipmap/ic_launcher');


  Future<void> init()async {
  emit(NotificationLoadingState());
  return Future(()async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  InitializationSettings initializationSettings = InitializationSettings(
  android: androidInitializationSettings,
  );

  return flutterLocalNotificationsPlugin.initialize(
  initializationSettings,
  onDidReceiveNotificationResponse: (NotificationResponse response) async {
  String? notificationId = response.payload;
  if (notificationId != null) {
  await deleteNotification(notificationId);
  }
  },
  );
  }).then((value) {
  emit(NotificationInitializedState());
  }).catchError((error) {
  emit(NotificationErrorState("Failed to initialize notifications: $error"));
  });
  }

  Future<void> addNotification({
  required String vaccineName,
  required DateTime nextDoseDate,
  }) async {
  emit(NotificationLoadingState());

  if (uId == null || uId!.isEmpty) {
  emit(AppAddNotificationErrorState("User ID is missing or invalid."));
  return;
  }

  if (id == null || id!.isEmpty) {
  emit(AppAddNotificationErrorState("Pet ID is missing or invalid."));
  return;
  }

  NotificationModel notificationModel = NotificationModel(
  title: 'Vaccination Reminder',
  body: '${petModel!.name}: $vaccineName',
  date: DateFormat.yMMMd().format(nextDoseDate),
  );

    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .collection('pets')
    .doc(id)
    .collection('notifications')
    .add(notificationModel.toMap())
    .then((docRef) {
     notificationModel.id = docRef.id;

    scheduleNotification(
    title: notificationModel.title!,
    body: notificationModel.body!,
    scheduledDate: nextDoseDate,
    notificationId: notificationModel.id!,
    )
    .then((value) {
    getUserNotifications();
    emit(AppAddNotificationSuccessState());
    })
    .catchError((error) {
    emit(AppAddNotificationErrorState("Failed notification: $error"));
    });
    })
    .catchError((error) {
    emit(AppAddNotificationErrorState("Failed to add notification: $error"));
    });
    }

  Future<void> scheduleNotification({
  required String title,
  required String body,
  required DateTime scheduledDate,
  required String notificationId,
  }) async {
  emit(NotificationLoadingState());

  tz.initializeTimeZones();

  FlutterTimezone.getLocalTimezone().then((currentTimeZone) {
   tz.setLocalLocation(tz.getLocation(currentTimeZone));

   AndroidNotificationDetails androidNotificationDetails =
   const AndroidNotificationDetails(
   "your_channel_id",
   "Vaccination Notifications",
   importance: Importance.max,
   priority: Priority.high,
   );

   NotificationDetails notificationDetails = NotificationDetails(
   android: androidNotificationDetails,
   );

   flutterLocalNotificationsPlugin
   .zonedSchedule(
   int.parse(notificationId.hashCode.toString()),
   title,
   body,
   tz.TZDateTime(
   tz.local,
   scheduledDate.year,
   scheduledDate.month,
   scheduledDate.day,
    0,
    0,
    ),
    notificationDetails,
    payload: notificationId,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exact,
    )
    .then((value) {
    emit(NotificationScheduledState(title, body, scheduledDate));
    })
    .catchError((error) {
    emit(NotificationErrorState("Failed to schedule notification: $error"));
    print("Error scheduling notification: $error");
    });
    }).catchError((error) {
    emit(NotificationErrorState("Failed to initialize timezone: $error"));
     print("Error initializing timezone: $error");
    });
    }

   List<NotificationModel> notifications = [];

   Future<void> deleteNotification(String notificationDocId) async {
   emit(NotificationLoadingState());
    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .collection('pets')
    .doc(id)
    .collection('notifications')
    .doc(notificationDocId)
    .delete()
     .then((value) async {
      await flutterLocalNotificationsPlugin.cancel(
      int.parse(notificationDocId.hashCode.toString()),
      );
      notifications.removeWhere((notification) => notification.id == notificationDocId);
      getUserNotifications();
      emit(NotificationDeletedSuccessState(notificationDocId));
      })
      .catchError((error) {
      emit(NotificationErrorState("Failed to delete notification: $error"));
      print(error.toString());
      });
      }


      void getUserNotifications() {
      emit(NotificationLoadingState());
      FirebaseFirestore.instance
      .collection('users')
      .doc(uId)
      .collection('pets')
      .doc(id)
      .collection('notifications')
      .get()
      .then((querySnapshot) {
      notifications = querySnapshot.docs.map((doc) {
      return NotificationModel.fromJson(doc.data(), id: doc.id);
      }).toList();
      emit(GetNotificationsSuccessState());
      }).catchError((error) {
      emit(GetNotificationsErrorState("Error fetching notifications: $error"));
      });
      }
      }


