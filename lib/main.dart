import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/colors.dart';
import 'package:whatasppflutterapp/commons/Widgets/error.dart';
import 'package:whatasppflutterapp/commons/Widgets/loader.dart';
import 'package:whatasppflutterapp/features/Auth/controllers/auth_controller.dart';
import 'package:whatasppflutterapp/features/Landing/screens/landing_screen.dart';
import 'package:whatasppflutterapp/firebase_options.dart';
import 'package:whatasppflutterapp/router.dart';
import 'package:whatasppflutterapp/screens/mobile_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // const ProviderScope(child: MyApp())
  return runApp(
    DevicePreview(
      builder: (context) => const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Whatsapp Chat',
      theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: appBarColor,
          ),
          scaffoldBackgroundColor: backgroundColor),
      // routeInformationParser: AppRoutes.routes.routeInformationParser,
      // routeInformationProvider: AppRoutes.routes.routeInformationProvider,
      // routerDelegate: AppRoutes.routes.routerDelegate,
      onGenerateRoute: generateRoute,
      home: ref.watch(getUserDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              } else {
                return const MobileLayoutScreen();
              }
            },
            error: (error, trace) {
              return ErrorScreen(
                errorText: error.toString(),
              );
            },
            loading: () => const Loader(),
          ),

      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileLayoutScreen(),
      //   webScreenLayout: WebLayoutScreen(),
      // ),
    );
  }
}
