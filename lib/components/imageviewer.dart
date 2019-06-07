import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer(
    this.imageProvider, {
    this.fullImageProvider,
    this.title,
    this.width,
    this.height = 200,
  });

  final ImageProvider<dynamic> imageProvider;
  final ImageProvider<dynamic> fullImageProvider;
  final double width;
  final double height;
  final String title;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Image(
          image: imageProvider,
          height: height,
          width: width,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                    body: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FadeInImage(
                              image: fullImageProvider ?? imageProvider,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.contain,
                              placeholder: imageProvider,
                              fadeOutDuration: const Duration(milliseconds: 1),
                              fadeInDuration: const Duration(milliseconds: 1),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Close',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          );
        },
      );
}
