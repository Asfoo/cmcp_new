import 'dart:async';

import 'package:cmcp/providers/complains.dart';
import 'package:cmcp/screens/category_screen.dart';
import 'package:cmcp/screens/change_password_screen.dart';
import 'package:cmcp/screens/complain_list_screen.dart';
import 'package:cmcp/screens/complain_profile_screen.dart';
import 'package:cmcp/screens/complain_screen.dart';
import 'package:cmcp/screens/complain_track_screen.dart';
import 'package:cmcp/screens/contact_us_screen.dart';
import 'package:cmcp/screens/forgot_password_screen.dart';
import 'package:cmcp/screens/image_view_screen.dart';
import 'package:cmcp/screens/new_feedback_screen.dart';
import 'package:cmcp/screens/phone_verification_screen.dart';
import 'package:cmcp/screens/profile_screen.dart';
import 'package:cmcp/screens/registration_mobile_screen.dart';
import 'package:cmcp/screens/registration_screen.dart';
import 'package:cmcp/screens/splash_screen.dart';
import 'package:cmcp/screens/verification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cmcp/providers/auth.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import './screens/dashboard_screen.dart';
import './main_theme/utils/AppTheme.dart';
import './screens/signIn.dart';
import './main_theme/store/AppStore.dart';
import './main_theme/utils/AppConstant.dart';

/// This variable is used to get dynamic colors when theme mode is changed
AppStore appStore = AppStore();

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialize();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Complains>(
          create: null,
          update: (ctx, auth, prev) => Complains(auth),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'E-Complaint Cell',
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? DashboardScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : SignIn(),
                ),
          routes: {
            CategoryScreen.tag: (ctx) => CategoryScreen(),
            ComplainScreen.tag: (ctx) => ComplainScreen(),
            ComplainListScreen.tag: (ctx) => ComplainListScreen(),
            ComplaintProfileScreen.tag: (ctx) => ComplaintProfileScreen(),
            RegPhoneScreen.tag: (ctx) => RegPhoneScreen(),
            RegistrationScreen.tag: (ctx) => RegistrationScreen(),
            ComplaintTrackScreen.tag: (ctx) => ComplaintTrackScreen(),
            EditProfileScreen.tag: (ctx) => EditProfileScreen(),
            ContactUsScreen.tag: (ctx) => ContactUsScreen(),
            ForgotPassScreen.tag: (ctx) => ForgotPassScreen(),
            ChangePasswordScreen.tag: (ctx) => ChangePasswordScreen(),
            VerificationScreen.tag: (ctx) => VerificationScreen(),
            ImageViewScreen.tag: (ctx) => ImageViewScreen(),
            NewFeedbackScreen.tag: (ctx) => NewFeedbackScreen(),
            PhoneVerificationScreen.tag: (ctx) => PhoneVerificationScreen(),
          },
        ),
      ),
    );
  }
}
