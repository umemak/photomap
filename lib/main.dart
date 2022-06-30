import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MapDetailPage.dart';
import 'NewMapPage.dart';
import 'NewPostPage.dart';
import 'firebase_options.dart';

import 'LoginPage.dart';
import 'UserState.dart';
import 'MapListPage.dart';

void main() async {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.userChanges().first;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final userState = UserState();
  late final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MapListPage(),
        ),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        name: 'map list',
        path: '/maps',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MapListPage(),
        ),
      ),
      GoRoute(
        name: 'new map',
        path: '/newmap',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const NewMapPage(),
        ),
      ),
      GoRoute(
        name: 'map detail',
        path: '/map/:id',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: MapDetailPage(state.params['id']!),
        ),
      ),
      GoRoute(
        name: 'new post',
        path: '/newpost/:id',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: NewPostPage(state.params['id']!),
        ),
      ),
    ],
    redirect: (GoRouterState state) {
      final bool loggedIn = (userState.user != null);
      final bool loggingIn = state.subloc == '/login';
      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn) {
        return '/';
      }
      return null;
    },
    refreshListenable: userState,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'PhotoMap',
        theme: ThemeData(
          textTheme:
              GoogleFonts.sawarabiGothicTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
        ),
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
      ),
    );
  }
}
