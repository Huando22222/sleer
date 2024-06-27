import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleer/blocs/auth_bloc/auth_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/screens/components/app_text_field.dart';
import 'package:sleer/config/config_images.dart';
import 'package:sleer/config/config_routes.dart';
import 'package:sleer/services/api_service.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:sleer/services/toast_service.dart';

class LoginPage extends StatelessWidget {
  final sharedPrefService = SharedPrefService();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      final apiService = ApiService();
      try {
        final data = {
          'phone': "0948025455",
          'password': "123456789",
          // 'phone': phoneController.text,
          // 'password': passwordController.text,
        };

        final response = await apiService.request(
          '/user/login',
          data: jsonEncode(data),
          options: Options(method: 'POST'),
        );
        final statusHandlers = {
          200: (Response response /*, BuildContext context */) async {
            final responseMessage = response.data['message'];
            final responseUser = response.data['user'];
            // final responseToken = response.data['accessToken'];
            debugPrint("before ------ $responseUser");
            final User user = User.fromJson(responseUser);
            //
            await sharedPrefService.setUser(user);
            final User? haha = await sharedPrefService.getUser();
            debugPrint("haha ------ ${haha!.id}");
            showToast(
              msg: "$responseMessage",
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          },
          401: (Response response /* , BuildContext context*/) {
            final responseData = response.data;
            showToast(
              msg: "$responseData",
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.orange,
            );
            debugPrint("Account already exists: ");
          },
        };
        apiService.handleResponse(response, statusHandlers);
        // if (mounted) {}
      } catch (e) {
        // debugPrint(e.toString());
        // showToast(
        //   msg: "Something wrong!",
        //   gravity: ToastGravity.TOP,
        //   timeInSecForIosWeb: 2,
        //   backgroundColor: Colors.red,
        // );
      }
    }

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
                        // context.read<AuthBloc>().add(AuthLogoutEvent());
                        // Navigator.of(context).pushNamed(AppRoutes.signup);
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
                  // onPressed: () => login(),
                  onPressed: () {
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
