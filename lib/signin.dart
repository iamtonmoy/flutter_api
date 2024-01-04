import 'package:apitutorials/bottom_navigation.dart';
import 'package:apitutorials/provider/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool submitClicked = false;

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String universityUuid = prefs!.getString('_selectedUniversityUuid').toString();

      await Provider.of<AuthProvider>(context, listen: false).login(
        emailController.text,
        passwordController.text,
        universityUuid,
      );

      // Add a delay of 2 seconds before navigating to the HomeScreen
      await Future.delayed(Duration(seconds: 2));

      // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 150),
                      SvgPicture.asset(
                        'lib/assets/Frame 13.svg',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 50),
                      _buildTitle(),
                      SizedBox(height: 10),
                      _buildSubtitle(),
                      SizedBox(height: 50),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        'lib/assets/login.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Log in to WebCommander',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xDD1C1C3B),
        fontSize: 18,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'A complete eCommerce platform',
      style: TextStyle(
        color: Color(0xDD1C1C3B),
        fontSize: 16,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w400,
        letterSpacing: 0.50,
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            _buildTextField(
              'Email',
              emailController,
              TextInputType.emailAddress,
              validator: (value) {
                if (value == value!.isEmpty && submitClicked) {
                  return 'Email is required';
                } else if (value!.isEmpty || !_isValidEmail(value) && submitClicked) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              labelText: 'Email Address',
            ),
            SizedBox(height: 16),
            _buildTextField(
              'Password',
              passwordController,
              TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty && submitClicked) {
                  return 'Password is required';
                }
                return null;
              },
              labelText: 'Password',
            ),
            SizedBox(height: 10),
            FutureBuilder<void>(
              future: _submitForm(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                submitClicked = true;
                              });
                              _submitForm();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.only(top: 14, left: 8, right: 6, bottom: 14),
                            ),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, TextInputType keyboardType, {bool obscureText = false, String? Function(String?)? validator, String? labelText}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              labelText: labelText ?? hintText,
              errorText: validator != null ? validator(controller.text) : null,
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);
  }
}
