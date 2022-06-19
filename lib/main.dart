import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  // ignore: unused_local_variable
  final firebaseUser = await FirebaseAuth.instance.userChanges().first;
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
      // if the user is not logged in, they need to login
      final bool loggedIn = (userState.user != null);
      final bool loggingIn = state.subloc == '/login';
      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) {
        return '/';
      }

      // no need to redirect at all
      return null;
    },

    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: userState,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp.router(
        // debugShowCheckedModeBanner: false,
        title: 'PhotoMap',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
      ),
    );
  }
}
