


import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:faserholmak/Helper/AppApi.dart';
import 'package:faserholmak/Model/SingleServicesModel/SingleServicesModel.dart';
import 'package:faserholmak/Model/UserInfoModel/UserInfoModel.dart';
import 'package:faserholmak/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Content.dart';



final facebookLogin = FacebookLogin();

Future<bool> logOutFacebook() async {
  try {
    await facebookLogin.logOut();
    return true;
  } catch (error) {
    print(error);
    return false;
  }
}

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn1 = GoogleSignIn();
Future<String> signInWithGoogle() async {


  final GoogleSignInAccount googleSignInAccount = await googleSignIn1.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;


  print("id ${user.uid}");
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return  'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
String tokenValue;
UserInfoModel userInfo;
String fireBASETOKEN="";



String getSplit(String txt){
  if(txt==null ||txt.isEmpty) return "";
  else {
    var x=txt.split(";");
    int size=x.length;
    if(size==0) return x[0];
    else return x[x.length-1];

  }
  return "";
}

Future<String> getPassword() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("USER_PASSWORD");
}

void setPassword(String password) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("USER_PASSWORD", password);
}


Future<String> getEmail() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("USER_EMAIL");
}

void setEmail(String data) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("USER_EMAIL", data);
}

Future<String> getToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("USER_TOKEN");
}

String getZeroWithNumber(int num){
  if(num<10) return"0$num";
  else return num.toString();
}

void setToken(String data) async {
  tokenValue=data;
  token=data;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("USER_TOKEN", data);
}









 bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}


String emptyString(String txt){
  if(txt==null) return"";
  return txt;
}

String StringToBoolean(bool txt){
 if(txt==null ||!txt)  return "$no";
 else return "$yes";
}

 bool validatePassWord(password) {
   if (password
       .toString()
       .length < passwordLength)
     return false;
   return true;
 }

 bool  validationForm(GlobalKey<FormState> item){

return item.currentState.validate();
}


Country initCountry(String num){
   return new Country(
     phoneCode: CountryPickerUtils
         .getCountryByPhoneCode(num)
         .phoneCode,
   );
}

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: kPrimaryColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}



bool IsServiceProvider(String txt){
   return emptyString(txt)==interpreterTxt;
}
bool showExplnationButton({String userType,String explnation,String servicesProvider,bool fromPublicPage=false}){
// showToast(servicesProvider.toString());
 // if(fromPublicPage&&servicesProvider!=userInfo.id) return true;
  /*&& servicesProvider==userInfo.id*/
  return userInfo.id!=null&&emptyString(userType)==interpreterTxt &&emptyString(explnation)==""&&servicesProvider==userInfo.id;
}


bool showAnotherMofaser({bool fromPublicPage=false,String servicesProvider}){
print("my id= ${userInfo.id}");
print("provider id= ${servicesProvider}");
print("state id= ${fromPublicPage}");
  return userInfo.id!=null&&fromPublicPage&&servicesProvider!=userInfo.id;
}


bool showStateAndTime({String createrID}){
  if(userInfo==null) return false;

  return emptyString(userInfo.id)==createrID&&emptyString(userInfo.type)==clientTxt;
}
bool showExplnationText({String explnation}){
  return emptyString(explnation)!="";
}

bool showRating({String createrID,String explnation}){
  return(userInfo.id!=null&&createrID==userInfo.id&&showExplnationText(explnation: explnation));

}


String stateToArabic(String txt){
  if(emptyString(txt)=="Active")
    return "قيد التنفيذ";
  else if(emptyString(txt)=="Done")
    return "منتهية";
  else return txt;
}
bool showCardDreamsInDetails({String creationID,String providerID,bool forPublicPage=false}){
  if(forPublicPage) return true;

  if(userInfo==null) return false;
  return (userInfo.id==emptyString(creationID)||userInfo.id==emptyString(providerID));
}

showAreYouHurry({SingleServicesModel singleServicesModel,String creationId}){
  if(userInfo==null||singleServicesModel==null) return false;
  return (userInfo.id==creationId);
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
bool IsExplanation(String txt){
  return emptyString(txt)!="";
}


Future<File> getImageFromGallery({@required int quality}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: quality);
  return  File(pickedFile.path);
}


void openPageAndClearPrev({BuildContext context,page,String route}){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => page
      ),
      ModalRoute.withName("/$route")
  );

}


void openPage(context, page) async {
  var route = new MaterialPageRoute(builder: (BuildContext context) {
    return page;
  });
  Navigator.of(context).push(route);
}

Future<Map> openMapPage(context, page) async {
  Map result = await Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) => page));
  return result;
}

void askPermissionCamera() {
  PermissionHandler()
      .requestPermissions([PermissionGroup.camera]).then(onStatusRequsetCamera);
}

Future onStatusRequsetCamera(Map<PermissionGroup, PermissionStatus> statuses) {
  final status = statuses[PermissionGroup.camera];
  if (status != PermissionStatus.granted) {
    PermissionHandler().openAppSettings();
  }
}


