// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';

import 'package:sleer/UI/auth/signup/signup_layout.dart';
import 'package:sleer/UI/components/app_button.dart';
import 'package:sleer/UI/components/app_text_field.dart';
import 'package:sleer/config/config_images.dart';
import 'package:sleer/config/config_routes.dart';
import 'package:sleer/services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phone = '';
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool passwordsMatch = false;
  bool verifyPhone = false;

  final TextEditingController phoneController = TextEditingController();
  // String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(
    isoCode: 'VN',
  );
  // void getPhoneNumber(String phoneNumber) async {
  //   PhoneNumber number =
  //       await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

  //   setState(() {
  //     this.number = number;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // Adding listeners to the controllers to validate passwords on change
    passwordController.addListener(_validatePasswords);
    confirmPasswordController.addListener(_validatePasswords);
  }

  void _validatePasswords() {
    setState(() {
      passwordsMatch = passwordController.text.isNotEmpty &&
          passwordController.text == confirmPasswordController.text &&
          passwordController.text.length >= 8;
    });
  }

  Future<void> register() async {
    final apiService = ApiService();
    try {
      final data = {
        'phone': phone,
        'password': passwordController.text,
      };

      final response = await apiService.request(
        '/user/register',
        data: jsonEncode(data),
        options: Options(method: 'POST'),
      );

      if (response.statusCode == 200) {
        debugPrint('Post data success: ${response.data}');
      } else {
        debugPrint(
            'Post data error: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      print('Post data exception: $e');
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onOTPVerified(bool isVerified) {
    setState(() {
      verifyPhone = isVerified;
    });
  }

  @override
  Widget build(BuildContext context) {
    String verifyToken = '';

    final Size size = MediaQuery.of(context).size;

    return SignUpLayout(
      page: Container(
        width: size.width,
        height: size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: verifyPhone == false
            ? Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      // <Widget>
                      [
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        phone = number.phoneNumber ?? '';
                      },
                      onInputValidated: (bool value) {
                        debugPrint("onInputValidated: $value");
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        useBottomSheetSafeArea: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: phoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputBorder: OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        debugPrint('On Saved: $number');
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // formKey.currentState?.validate();

                        if (formKey.currentState?.validate() == true) {
                          // Navigator.of(context).pushNamed(AppRoutes.login);
                          try {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '$phone',
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                verifyToken = verificationId;

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("OTP"),
                                    content: OTPDialog(
                                      onOTPVerified: onOTPVerified,
                                      verifyToken: verifyToken,
                                    ),
                                  ),
                                );
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          } catch (e) {
                            debugPrint(
                                "----------------------------didnt send OTP");
                          }
                        }
                      },
                      child: Text('Send Code'),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextField(
                      // hintText: "Password",
                      controller: passwordController,
                      onChanged: (value) => _validatePasswords(),
                      label: Row(
                        children: [
                          SvgPicture.asset(
                            ConfigImages.shield,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Password"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      controller: confirmPasswordController,
                      onChanged: (value) => _validatePasswords(),
                      label: Text("Comfirm password"),
                    ),
                    if (passwordsMatch)
                      AppButton(
                        title: "Sign Up",
                        onPressed: () {
                          try {
                            debugPrint(
                                "seef ${phone}-${passwordController.text}");
                            register();
                            Navigator.of(context).pushNamed(ConfigRoutes.login);
                            Fluttertoast.showToast(
                              msg: "Xác thực thành công!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              ConfigRoutes.login,
                              (route) => false,
                            );
                          } catch (e) {
                            debugPrint(e.toString());
                            Fluttertoast.showToast(
                              msg: "Xác thực that bai!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class OTPDialog extends StatefulWidget {
  final String verifyToken;
  final Function(bool isVerified) onOTPVerified;
  const OTPDialog({
    super.key,
    required this.verifyToken,
    required this.onOTPVerified,
  });

  @override
  State<OTPDialog> createState() => _OTPDialogState();
}

class _OTPDialogState extends State<OTPDialog> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String code = '';
    // final Size size = MediaQuery.of(context).size;
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );

    return IntrinsicHeight(
      child: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                // Specify direction if desired
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  // showCursor: true,
                  controller: pinController,
                  focusNode: focusNode,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  defaultPinTheme: defaultPinTheme,
                  validator: (value) {
                    return value!.length == 6
                        ? null
                        : 'Pin requires 6 characters';
                  },
                  separatorBuilder: (index) => const SizedBox(width: 8),

                  // onClipboardFound: (value) {
                  //   debugPrint('onClipboardFound: $value');
                  //   pinController.setText(value);
                  // },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    code = pin;
                    debugPrint('onCompleted: $pin');
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  focusNode.unfocus();
                  // formKey.currentState!.validate();
                  if (formKey.currentState!.validate() == true) {
                    try {
                      FirebaseAuth auth = FirebaseAuth.instance;

                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: widget.verifyToken,
                        smsCode: code,
                      );

                      await auth.signInWithCredential(credential);
                      if (context.mounted) {
                        widget.onOTPVerified(true);
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      debugPrint("Wrong OTP");
                    }
                  }
                },
                child: const Text('Validate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
