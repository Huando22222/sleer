// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sleer/blocs/auth_bloc/auth_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/blocs/auth_bloc/auth_state.dart';
import 'package:sleer/blocs/connectivity_bloc.dart/connectivity_bloc.dart';
import 'package:sleer/blocs/connectivity_bloc.dart/connectivity_state.dart';
import 'package:sleer/blocs/contact_bloc/contact_bloc.dart';
import 'package:sleer/config/config_routes.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/screens/auth/login/login_page.dart';
import 'package:sleer/screens/page_view_screen.dart';
import 'package:sleer/services/api_service.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sleer/services/util_service.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => Connectivity());
}

void main() async {
  setup();
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
          create: (context) => ConnectivityBloc(getIt<Connectivity>()),
        ),
        BlocProvider(
          create: (context) => ContactBloc(),
        ),
        BlocProvider(
          // create: (context) => AuthBloc(),
          create: (context) {
            if (auth != null) {
              debugPrint(auth!.phone);
              final apiService = GetIt.instance<ApiService>();
              final sharedPrefService = SharedPrefService();
              sharedPrefService.getToken().then((token) {
                if (token != null) {
                  apiService.updateToken(token);
                }
              }).catchError((error) {
                debugPrint('Failed to get token: $error');
              });
              return AuthBloc()..add(AuthKeepLoginEvent(auth: auth!));
            } else {
              return AuthBloc();
            }
          },
        )
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
        // home: const StateWidget(),
        home: BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityDisconnected) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('No internet connection'),
                  backgroundColor: Colors.grey,
                  duration: const Duration(days: 365),
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
              debugPrint("Disconnectivity");
            } else if (state is ConnectivityConnected) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              debugPrint("connectivity");
            }
          },
          child: const StateWidget(),
        ),
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Page not found! MAIN.dart'),
              ),
            ),
          );
        },
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
          return const PageViewScreen();
        }
        if (state is AuthErrorState) {
          UtilService.showToast(
            backgroundColor: Colors.orange,
            msg: state.message,
          );
          return LoginPage();
        }
        return Container();
      },
    );
  }
}
