// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sleer/blocs/auth_bloc/auth_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/blocs/auth_bloc/auth_state.dart';
import 'package:sleer/blocs/contact_bloc/contact_bloc.dart';
import 'package:sleer/config/config_routes.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/screens/auth/login/login_page.dart';
import 'package:sleer/screens/home/home_page.dart';
import 'package:sleer/services/shared_pref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPrefService = SharedPrefService();
  final User? auth = await sharedPrefService.getUser();
  // if (auth != null) {
  //   BlocProvider.of<AuthBloc>(context).add(AuthKeepLoginEvent(user: auth));
  // }
  runApp(MyApp(
    auth: auth,
  ));
}

class MyApp extends StatelessWidget {
  final User? auth;
  const MyApp({
    super.key,
    this.auth,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactBloc(),
        ),
        BlocProvider(
            // create: (context) => AuthBloc(),
            create: (context) {
          if (auth != null) {
            debugPrint(auth!.phone);
            return AuthBloc()..add(AuthKeepLoginEvent(auth: auth!));
          } else {
            return AuthBloc(); // Xử lý khi auth là null
          }
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // initialRoute: "/welcome",
        routes: ConfigRoutes.pages,
        home: const StateWidget(),
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Page not found! MAIN.dart'),
              ),
            ),
          );
        },
        // home: WelComePage(),
      ),
    );
  }
}

class StateWidget extends StatelessWidget {
  const StateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return LoginPage();
        }
        if (state is AuthLoginState) {
          return const HomePage(); // PageView()
        }
        return Container();
      },
    );
  }
}
