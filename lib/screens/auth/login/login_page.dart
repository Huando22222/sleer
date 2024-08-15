import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleer/blocs/auth_bloc/auth_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/screens/components/app_text_field.dart';
import 'package:sleer/config/config_images.dart';
import 'package:sleer/config/config_routes.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:sleer/services/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LoginPage extends StatelessWidget {
  final sharedPrefService = SharedPrefService();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: SvgPicture.asset(
                    ConfigImages.logo,
                    width: 100,
                    height: 100,
                  ),
                ),
                AppTextField(
                  hintText: "phone",
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                ),
                AppTextField(
                  hintText: "password",
                  controller: passwordController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("new to sleer"),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          ConfigRoutes.signup,
                        );
                      },
                      child: const Text(
                        "SignUp",
                        // style: AppText.subtitle1,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<AuthBloc>(context).add(
                      AuthLoginEvent(
                        phone: phoneController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    maximumSize: const Size(300, 80),
                    minimumSize: const Size(200, 40),
                  ),
                  child: const Text("Login"),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
