import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/resources/auth_provider.dart';
import 'package:social_media_app/responsive/responsive.dart';
import 'package:social_media_app/screens/signupscreen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/global_variables.dart';
import 'package:social_media_app/utils/strings.dart';
import 'package:social_media_app/utils/utils.dart';
import 'package:social_media_app/widgets/text_field_input.dart';

import '../mobilescreenlayout.dart';
import '../webscreenlayout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            const WebScreenLayout(),
            const MobileScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: isWebScreenSize(context)
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                assetName,
                color: Colors.white,
                height: 64,
              ),
              sizedBox(64),
              TextFieldInput(
                textEditingController: emailController,
                hintText: Strings.email,
                textInputType: TextInputType.emailAddress,
              ),
              sizedBox(24),
              TextFieldInput(
                textEditingController: passwordController,
                hintText: Strings.password,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              sizedBox(24),
              userLoginButton(),
              sizedBox(24),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              loginBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Row loginBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(Strings.dont_have_account),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
        ),
        GestureDetector(
          onTap: _navigateToSignUp,
          child: Container(
            child: Text(
              Strings.sign_up,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
          ),
        )
      ],
    );
  }

  SizedBox sizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  InkWell userLoginButton() {
    return InkWell(
      onTap: loginUser,
      child: Container(
        child:
            _isLoading ? getCircularProgressIndicator() : Text(Strings.log_in),
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          color: blueColor,
        ),
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
}
