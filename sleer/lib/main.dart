import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/contact_bloc/contact_bloc.dart';
import 'package:sleer/config/app_routes.dart';
import 'package:sleer/UI/welcome/welcome_page.dart';

void main() {
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/welcome",
        routes: AppRoutes.pages,
        onUnknownRoute: (settings) {
          // Trả về một trang hoặc widget tùy thuộc vào nhu cầu của bạn.
          return MaterialPageRoute(
            builder: (context) => Scaffold(
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

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: "/welcome",
//       routes: AppRoutes.pages,
//       onUnknownRoute: (settings) {
//         // Trả về một trang hoặc widget tùy thuộc vào nhu cầu của bạn.
//         return MaterialPageRoute(
//           builder: (context) => Scaffold(
//             body: Center(
//               child: Text('Page not found! MAIN.dart'),
//             ),
//           ),
//         );
//       },
//       // home: WelComePage(),
//     );
//   }
// }
