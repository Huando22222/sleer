import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sleer/UI/auth/signup/signup_layout.dart';

class SignUpInputPhoneNumber extends StatefulWidget {
  const SignUpInputPhoneNumber({super.key});

  @override
  State<SignUpInputPhoneNumber> createState() => _SignUpInputPhoneNumberState();
}

class _SignUpInputPhoneNumberState extends State<SignUpInputPhoneNumber> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  debugPrint(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  //
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
                textFieldController: controller,
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
                onPressed: () {
                  formKey.currentState?.validate();
                },
                child: Text('Validate'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     formKey.currentState?.save();
              //   },
              //   child: Text('Save'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
