import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/blocs/design.dart';
import 'package:video_player/video_player.dart';

class SenamVideoPlayer extends StatefulWidget {
  String videoUrl;
  File file;
  int index;
    double width;
  double height;

  SenamVideoPlayer({this.videoUrl, this.file,this.index,this.width,this.height});

  @override
  _SenamVideoPlayerState createState() => _SenamVideoPlayerState();
}

class _SenamVideoPlayerState extends State<SenamVideoPlayer> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool showButton = true;
  @override
  void initState() {
    if(widget.file!=null)
        _controller = VideoPlayerController.file(widget.file
      //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );
    else
    _controller = VideoPlayerController.network(widget.videoUrl
      //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );


    // Initielize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  double volum = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:widget.width ,
      height: widget.height,
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            showButton = true;
          });
          await Future.delayed(mill2Second);
        
          setState(() {
            showButton = false;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
                child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            )),
            AnimatedOpacity(
              duration: mill0Second,
              opacity: showButton ? 1.0 : 0.0,
              child: Center(
                  child: ButtonTheme(
                      child: RaisedButton(
                padding: EdgeInsets.all(5.0),
                color: Colors.transparent,
                textColor: Colors.white,
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown.
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                      showButton = false;
                    } else {
                      // If the video is paused, play it.
                      _controller.play();
                      showButton = false;
                    }
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 25.0,
                ),
              ))),
            ),
             if(widget.index!=null)    Positioned(
                  top: 5,
                  left: 0,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white),
                      child: InkWell(
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: primary,
                          ),
                          onTap: () {
                            Map<int, File> oldVideoFileMap =
                                bloc.adVideosFilesMap();
                                Map<int,String> oldVideoUrlMap=bloc.adVideosURL();
                            Map<int, Widget> oldVideoWidgets =
                                bloc.adVideosWidgets();
                          if(widget.file!=null)
                            oldVideoFileMap.remove(widget.index);
                            if(widget.videoUrl!=null)
                            oldVideoUrlMap.remove(widget.index);
                            oldVideoWidgets.remove(widget.index);
                            bloc.onadVideosURLChange(oldVideoUrlMap);
                            bloc.addNewadVideosFilesMAp(oldVideoFileMap);
                            bloc.addNewadVideosWidgets(oldVideoWidgets);
                          })),
                )
          ],
        ),
      ),
    );
  }
}
