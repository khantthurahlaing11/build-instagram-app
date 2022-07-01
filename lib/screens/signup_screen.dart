import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async{
  Uint8List im = await pickImage(ImageSource.gallery);
  setState(() {
    _image = im;
  });
  }


  void signUpUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await  AuthMethods().signUpUser(
        email: _emailController.text, password: _passwordController.text, 
        username: _usernameController.text, bio: _bioController.text,
        file : _image!
      );
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
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: primaryColor,
              height: 64,
            ),
            SizedBox(
              height: 14,
            ),
            Stack(children: [
              _image != null?
              CircleAvatar(
                radius: 44,
                backgroundImage: MemoryImage(_image!),
              )
              :
               CircleAvatar(
                radius: 44,
                backgroundImage: NetworkImage('https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
              ),
              Positioned(
                bottom: -10,
                left: 50,
                child: IconButton(onPressed: selectImage, icon: Icon(Icons.add_a_photo)))
            ],),
            SizedBox(
              height: 14,
            ),
            TextFieldInput(
                textEditingController: _usernameController,
                hintText: "Enter your username",
                textInputType: TextInputType.text),
            SizedBox(
              height: 14,
            ),
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress),
            SizedBox(
              height: 14,
            ),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Enter your password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            SizedBox(
              height: 14,
            ),
            TextFieldInput(
                textEditingController: _bioController,
                hintText: "Enter your bio",
                textInputType: TextInputType.text),
            SizedBox(
              height: 14,
            ),
            InkWell(
              onTap: signUpUser,
              child: Container(
                child: _isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),) : Text("Sign up"),
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
            SizedBox(height: 6,),
             Flexible(
              child: Container(),
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(child: Text("Already have an account?"),padding: EdgeInsets.symmetric(vertical: 10),),
              SizedBox(width: 3,),
               GestureDetector(
                 onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(),));
                 },
                 child: Container(
                   child: Text("Login.",style: TextStyle(fontWeight: FontWeight.bold),),padding: EdgeInsets.symmetric(vertical: 8),))
            ],)

          ],
        ),
      )),
    );
  }
}
