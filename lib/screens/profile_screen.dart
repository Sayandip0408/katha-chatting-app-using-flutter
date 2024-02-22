import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_chat/helper/dialogue.dart';
import 'package:you_chat/models/chat_user.dart';

import '../api/api.dart';
import '../main.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
          ),
          title: const Text("Your Profile"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            Dialogue.showProgressBar(context);
            await APIs.updateActiveStatus(false);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
                APIs.auth = FirebaseAuth.instance;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              });
            });
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          label: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
              child: Column(
                children: [
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.1),
                              child: Image.file(
                                File(_image!),
                                height: mq.height * 0.2,
                                width: mq.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.1),
                              child: CachedNetworkImage(
                                height: mq.height * 0.2,
                                width: mq.height * 0.2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: const CircleBorder(),
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty
                        ? null
                        : "Required fields",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: Theme.of(context).colorScheme.secondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "eg. John Doe",
                      label: const Text("Name"),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty
                        ? null
                        : "Required fields",
                    decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.info,color: Theme.of(context).colorScheme.secondary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "eg. Hey there, I am using BaatCheet",
                      label: const Text("About"),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                    width: mq.width,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * 0.5, mq.height * 0.06)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogue.showSnackBar(
                              context, "Profile updated successfully");
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black87,
                    ),
                    label: const Text(
                      "Update",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: mq.height * 0.03, bottom: mq.height * 0.05),
            children: [
              const Text(
                "Choose any option...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        debugPrint(
                            "Image Path: ${image.path} -- MimeType: ${image.mimeType}");
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePic(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                      shape: const CircleBorder(),
                    ),
                    child: Image.asset(
                      "images/camera.png",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        debugPrint(
                            "Image Path: ${image.path} -- MimeType: ${image.mimeType}");
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePic(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                      shape: const CircleBorder(),
                    ),
                    child: Image.asset(
                      "images/gallery.png",
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
