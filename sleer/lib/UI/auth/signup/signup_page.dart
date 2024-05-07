import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sleer/UI/auth/signup/signup_input_OTP.dart';
import 'package:sleer/UI/auth/signup/signup_input_phone_number.dart';
import 'package:sleer/blocs/register_bloc/signup_bloc.dart';
import 'package:sleer/blocs/register_bloc/signup_state.dart';
import 'package:sleer/config/app_colors.dart';
import 'package:sleer/config/app_images.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.signUpPageColor,
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
                    AppImages.logo,
                    width: 150,
                    height: 150,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: BlocProvider(
                    create: (context) => SignUpBloc(),
                    child: BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) {
                        if (state is SignUpInitial) {
                          // return SignUpInputOTP();
                          return SignUpInputPhoneNumber();
                        }
                        // return Container();
                        return Placeholder();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
