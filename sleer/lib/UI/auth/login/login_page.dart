import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleer/UI/components/app_text_field.dart';
import 'package:sleer/config/config_images.dart';
import 'package:sleer/config/config_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                const AppTextField(
                  hintText: "phone",
                ),
                const AppTextField(
                  hintText: "password",
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
                  onPressed: () {},
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
