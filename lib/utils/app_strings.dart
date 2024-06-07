import 'dart:io';

class AppStrings{
   ///All Static Strings
   static String bannerAdsId = Platform.isAndroid ? 'ca-app-pub-7278830824707729/1195700970' : 'ca-app-pub-7278830824707729/8694400126';
   // static String bannerAddsId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/9214589741' : '';
   static String bannerAddsId = Platform.isAndroid ? 'ca-app-pub-7278830824707729/4464916044' :  'ca-app-pub-7278830824707729/9815910101' ;
   static String bannerAdddsId = Platform.isAndroid ? 'ca-app-pub-7278830824707729/5850096005' : 'ca-app-pub-7278830824707729/3846749194';

   static const String weThrowGas = "“We throw gas on the fire.”";
   static const String music = "Music";
   static const String logo = "Logo";
   static const String video = "Video";
   static const String news = "News";
   static const String interview = "Interview";
   static const String podcast = "Podcast";
   static const String readMore = "Read more";
   static const String home = "Home";
   static const String viewMore = "View more";
   static const String bookmark = "Bookmark";
   static const String bookmarks = "Bookmarks";
   static const String personalInformation = "Personal Information";
   static const String termsConditions = "Terms & Conditions";
   static const String privacyPolicy = "Privacy Policy";
   static const String aboutUs = "About Us";
   static const String contactUs = "Contact Us";
   static const String uploadPicture = "Upload Picture";
   static const String myProfile = "My Profile";
   static const String name = "Name";
   static const String enterYourName = "Enter your name";
   static const String email = "Email";
   static const String enterEmail = "Enter email";
   static const String contact = "Contact";
   static const String enterContactNumber = "Enter contact number";
   static const String address = "Address";
   static const String enterAddress = "Enter address";
   static const String updateProfile = "Update Profile";
   static const String subject = "Subject";
   static const String search = "Search";
   static const String send = "Send";
   static const String editProfile = "Edit Profile";
   static const String enterSubject = "Enter email subject";
   static const String yourMessage = "Your message";
   static const String enterMessage  = "Enter message";
   static const String contactNow  = "Contact Now Entertainment";
   static const String youMayAlso = "You may also contact us at";
   static RegExp emailRegexp = RegExp(
       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

}