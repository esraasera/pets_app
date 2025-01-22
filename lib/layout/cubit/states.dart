import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AppStates { }
class InitialAppState extends AppStates {}

class AppChangeBottomNavIndexState extends AppStates {}
class AppLoadingState extends AppStates {}


class  AppGetUserLoadingState extends AppStates{ }
class  AppGetUserSuccessState extends AppStates{ }
class  AppGetUserErrorState extends AppStates{
  final String error;
  AppGetUserErrorState(this.error);
}


class  AppSendUserPetsLoadingState extends AppStates{ }
class AppSendUserPetsErrorState extends AppStates {
  final String error;
  AppSendUserPetsErrorState(this.error);
}


class  AppPickedPetImageSuccessState extends AppStates{ }
class  AppPickedPetImageErrorState extends AppStates{ }


class  AppUploadPetImageLoadingState extends AppStates{ }
class  AppUploadPetImageSuccessState extends AppStates{ }
class  AppUploadPetImageErrorState extends AppStates{ }




class  AppGetPetLoadingState extends AppStates{ }
class  AppGetPetSuccessState extends AppStates{ }
class  AppPetUpdateErrorState extends AppStates{
  final String error;
  AppPetUpdateErrorState(this.error);
}


class  AppDeletePetLoadingState extends AppStates{ }
class  AppDeletePetSuccessState extends AppStates{ }
class  AppDeletePetErrorState extends AppStates{
  final String error;
  AppDeletePetErrorState(this.error);
}


class  AppGetAllPetsLoadingState extends AppStates{ }
class  AppGetAllPetsSuccessState extends AppStates{ }
class  AppGetAllPetsErrorState extends AppStates{
  final String error;
  AppGetAllPetsErrorState(this.error);
}



class  AppPetUpdateLoadingState extends AppStates{ }
class  AppGetPetErrorState extends AppStates{
  final String error;
  AppGetPetErrorState(this.error);
}
class  AppPetLogOutSuccessState extends AppStates{ }
class  AppUserLogOutSuccessState extends AppStates{ }



class  AppSendingUserMessageSuccessfulState extends AppStates{ }
class  AppGetGeminiMessageSuccessfulState extends AppStates{ }
class  AppSendingUserMessageErrorState extends AppStates{
  final String error;
  AppSendingUserMessageErrorState(this.error);
}
class  AppGetMessagesSuccessState extends AppStates{ }
class  AppGetMessagesErrorState extends AppStates{
  final String error;
  AppGetMessagesErrorState(this.error);
}




class LocationLoading extends AppStates {}
class LocationLoaded extends AppStates {
  CameraPosition cameraPosition;
  List<Marker> markers;

  LocationLoaded(this.cameraPosition, this.markers);
}
class LocationError extends AppStates {
  final String error;

  LocationError(this.error);
}




class NotificationLoadingState extends AppStates {}
class NotificationInitializedState extends AppStates {}
class NotificationErrorState extends AppStates {
  final String error;
  NotificationErrorState(this.error);
}



class AppAddNotificationSuccessState extends AppStates {}
class AppAddNotificationErrorState extends AppStates {
  final String error;
  AppAddNotificationErrorState(this.error);
}



class GetNotificationsSuccessState extends AppStates {}
class GetNotificationsErrorState extends AppStates {
  final String error;
  GetNotificationsErrorState(this.error);
}

class NotificationScheduledState extends AppStates {
  final String title;
  final String body;
  final DateTime scheduledDate;

  NotificationScheduledState(this.title, this.body, this.scheduledDate);
}
class NotificationDeletedSuccessState extends AppStates {
  final String notificationId;
  NotificationDeletedSuccessState(this.notificationId);
}
