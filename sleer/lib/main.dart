import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/UI/auth/login/login_page.dart';
import 'package:sleer/UI/home/home_page.dart';
import 'package:sleer/blocs/auth_bloc/auth_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_state.dart';
import 'package:sleer/blocs/contact_bloc/contact_bloc.dart';
import 'package:sleer/config/app_routes.dart';
import 'package:sleer/UI/welcome/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
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
        routes: AppRoutes.pages,
        home: const StateWidget(),
        onUnknownRoute: (settings) {
          // Trả về một trang hoặc widget tùy thuộc vào nhu cầu của bạn.
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
          return const LoginPage();
        }
        if (state is AuthLoginState) {
          return const HomePage();
        }
        return Container();
      },
    );
  }
}
