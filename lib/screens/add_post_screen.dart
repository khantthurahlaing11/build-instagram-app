
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({ Key? key }) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid,String username,String profImage) async{
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(_descriptionController.text, _file!, uid, username, profImage);
      if(res == 'Success'){
        setState(() {
          _isLoading = false;
        });
        showSnapBar('Posted', context);
         clearImage();
      }else{
         setState(() {
          _isLoading = false;
        });
        showSnapBar(res, context);
      }
    } catch (e) {
      showSnapBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context)async{
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text("Create a Post"),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text("Take a photo"),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
            SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text("Choose from gallery"),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
           SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return 
    _file == null?
    Center(
      child: IconButton(
        icon: Icon(Icons.upload),
        onPressed: () => _selectImage(context),
      ),
    )
    :
     Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(onPressed: clearImage, icon: Icon(Icons.arrow_back)),
        title: Text("New Post"),
        centerTitle: false,
        actions: [
          // IconButton(onPressed: ()=>postImage(user.uid, user.username, user.photoUrl), 
          // icon: Icon(Icons.,color: Colors.blueAccent,))
          TextButton(onPressed:()=>postImage(user.uid, user.username, user.photoUrl), 
          child: Text("Post",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 16),))
        ],
        ),
      body: Column(
        children: [
          _isLoading? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0)),
          // const Divider(),
          Row(
            
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 18,top: 18)),
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(width: 20,),
              SizedBox(
                
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none
                  ),
                maxLines: 2,
                ),
                ),
              
              // const Divider()
            ],
          ),
          SizedBox(
                height: MediaQuery.of(context).size.height *0.65,
                 width: MediaQuery.of(context).size.width*0.9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        // alignment: Alignment.center
                      )
                    ),
                  ),
                  ),
            
        ],
      ),
    );
  }
}