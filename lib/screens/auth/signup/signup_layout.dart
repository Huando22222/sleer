import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sleer/config/config_colors.dart';
import 'package:sleer/config/config_images.dart';

class SignUpLayout extends StatelessWidget {
  final Widget page;
  const SignUpLayout({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConfigColors.signUpPageColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  bottom: size.height * 0.75,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    ConfigImages.logo,
                    width: 150,
                    height: 150,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: page,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
