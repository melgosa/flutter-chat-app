import 'package:chat_app_flutter/pages/chat_page.dart';
import 'package:chat_app_flutter/pages/loading_page.dart';
import 'package:chat_app_flutter/pages/login_page.dart';
import 'package:chat_app_flutter/pages/register_page.dart';
import 'package:chat_app_flutter/pages/users_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => UsersPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};