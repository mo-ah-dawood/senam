import 'dart:io';
import 'package:flutter/material.dart';
import 'package:senam/blocs/design.dart';
import 'package:senam/blocs/widgets.dart';



class ProfilePicture extends StatelessWidget{
  IconData icon;
  Function onIconPressed;
  String imageURL;
  File cropped;
  ProfilePicture({this.icon,this.imageURL,this.onIconPressed,this.cropped});
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 192,
                width: 152,
                decoration: BoxDecoration(
                    border: Border.all(color: primary, width: 5),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                // key: imageKey,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                constraints: BoxConstraints(
                    maxWidth: 152,
                    maxHeight: 192),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: FadeInImage(
                            placeholder:
                                AssetImage('assets/images/placeholder.gif'),
                            image:cropped!=null? FileImage(cropped):NetworkImage(imageURL),
                            fit: BoxFit.fill,
                          ))),
            SizedBox(
              width: 15,
            )
          ],
        ),
        Positioned(
          left: -10,
          bottom: -5,
          child: BumbiIconButton(
            color: Colors.white,
            onPressed: onIconPressed,
            iconData: icon,
          ),
        ),
      ],
    );
  }
}
