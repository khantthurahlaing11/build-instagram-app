import 'package:flutter/material.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/signup_screen.dart';

import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser()async{
     setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
       setState(() {
      _isLoading = false;
    });
    if(res != "Success"){
      showSnapBar(res, context);
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(), 
                mobileScreenLayout: MobileScreenLayout()
                ),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(     
        padding: MediaQuery.of(context).size.width > webScreenSize? EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width/3):
        const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: primaryColor,
              height: 64,
            ),
            SizedBox(
              height: 64,
            ),
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress),
            SizedBox(
              height: 24,
            ),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Enter your password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: loginUser,
              child:  Container(
                child: _isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),) : Text("Login"),
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)
                        )
                        ),
                    color: blueColor
                        ),
              ),
            ),
            SizedBox(height: 12,),
             Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(child: Text("Don't have an account?"),padding: EdgeInsets.symmetric(vertical: 8),),
              SizedBox(width: 3,),
               GestureDetector(
                 onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen(),));
                 },
                 child: Container(
                   child: Text("Sign up.",style: TextStyle(fontWeight: FontWeight.bold),),padding: EdgeInsets.symmetric(vertical: 8),))
            ],)

          ],
        ),
      )),
    );
  }
}
