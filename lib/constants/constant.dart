// ignore_for_file: file_names

// String audioPath = 'sounds/tap.mp3';
// String removeAudioPath = 'sounds/remove.mp3';
import '../models/Login/login.dart';

String myAPILink = "http://10.55.5.19/bpdb-app"; //http://10.55.5.19/bpdb-app
//String myAPILink = "https://ims.cegisbd.com/bpdb"; //online
// //String myAPILink = "https://ims.cegisbd.com/rhd005"; //live
String timeAPILink = "https://worldtimeapi.org/api/timezone/Asia/Dhaka";
String onlineTime = "00:00:00";
String poleImgPath =
    "https://ims.cegisbd.com/bpdb/ComponentPicture/Pole/pole_main";
// int taskSchedulerMinutes = 5;
// int maxCollectionHour = 48;
// int maxTimeToEditScheduleInHour = 1;

// String userId = 'app_user';
// int userLevelId = 0;
String LoginTime = '';
User? globalUser;

class GlobalVariables {
  static double? centerLatitude;
  static double? centerLongitude;
  static double? defaultZoomLevel;
}
