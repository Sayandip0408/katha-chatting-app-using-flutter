import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user.dart';

//view profile screen -- to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          //app bar
          appBar: AppBar(
            title: Text(widget.user.name),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          floatingActionButton: //user about
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Joined On:  ',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),

          //body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: mq.width, height: mq.height * .03),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  // for adding some space
                  SizedBox(height: mq.height * .03),

                  // user email label
                  Text(widget.user.email,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16)),

                  // for adding some space
                  SizedBox(height: mq.height * .02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'About: ',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 15),
                      ),
                      Text(widget.user.about,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
