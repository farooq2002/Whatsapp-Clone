import 'package:go_router/go_router.dart';
import 'package:whatasppflutterapp/Features/SelectContact/Screens/select_contacts_screen.dart';
import 'package:whatasppflutterapp/Features/Chat/Screens/mobile_chat_screen.dart';
import 'package:whatasppflutterapp/features/Auth/screens/login_screen.dart';
import 'package:whatasppflutterapp/features/Auth/screens/user_info_screen.dart';
import 'package:whatasppflutterapp/features/Landing/screens/landing_screen.dart';
import 'package:whatasppflutterapp/Routes/route_constants.dart';

class AppRoutes {
  static final routes = GoRouter(
      // routerNeglect: true,
      initialLocation: RouteConstants.landingscreen,
      routes: [
        GoRoute(
          path: RouteConstants.landingscreen,
          builder: (context, state) => const LandingScreen(),
        ),
        GoRoute(
          path: RouteConstants.loginscreen,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteConstants.userInfoScreen,
          builder: (context, state) => const UserInformationScreen(),
        ),
        GoRoute(
          path: RouteConstants.selectcontact,
          builder: (context, state) => const SelectContactScreen(),
        ),
        GoRoute(
          path: RouteConstants.mobileChatScreen,
          builder: (context, state) =>
              const MobileChatScreen(name: "Ibrahim", uid: "12345"),
        ),
      ]);
}
