import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import '../store/todocomments.dart';
import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fastter/fastter_bloc.dart';
import '../models/todocomment.model.dart';

import '../helpers/todouihelpers.dart';
import 'imageviewer.dart';

class TodoCommentItem extends StatelessWidget {
  const TodoCommentItem({
    super.key,
    required this.todoComment,
    required this.onLongPress,
    required this.onTap,
    required this.selected,
  });

  final TodoComment todoComment;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) => _TodoCommentItem(
        todoComment: todoComment,
        deleteComment: () {
          final action = DeleteEvent<TodoComment>(todoComment.id);
          fastterTodoComments.add(action);
          return action.completer.future;
        },
        addComment: (comment) =>
            fastterTodoComments.add(AddEvent<TodoComment>(comment)),
        onLongPress: onLongPress,
        onTap: onTap,
        selected: selected,
      );
}

class _TodoCommentItem extends StatelessWidget {
  const _TodoCommentItem({
    required this.todoComment,
    required this.deleteComment,
    required this.addComment,
    required this.onLongPress,
    required this.onTap,
    required this.selected,
  });

  final TodoComment todoComment;
  final Future<TodoComment> Function() deleteComment;
  final void Function(TodoComment) addComment;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool selected;

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are You sure?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );

  Widget _buildContent(BuildContext context) {
    if (todoComment.type == TodoCommentType.image) {
      final imageProvider = NetworkImage(todoComment.content);
      return ImageViewer(
        imageProvider,
      );
    } else if (todoComment.type == TodoCommentType.video) {
      const videoEmbedders = <Map<String, dynamic>>[
        <String, dynamic>{
          'startsWith': 'https://vimeo.com/',
          'link': 'https://player.vimeo.com/video/{{id}}',
        },
        <String, dynamic>{
          'startsWith': 'https://www.youtube.com/watch?v=',
          'link': 'https://www.youtube.com/embed/{{id}}',
        },
      ];
      for (final videoEmbedder in videoEmbedders) {
        if (todoComment.content.startsWith(videoEmbedder['startsWith'])) {
          final id = todoComment.content.split(videoEmbedder['startsWith'])[1];
          if (Platform.isAndroid || Platform.isIOS) {
            final width = MediaQuery.of(context).size.width;
            final height = (width * 9) / 16;
            final String initialUrl =
                videoEmbedder['link'].replaceAll('{{id}}', id);
            return Container(
              width: width,
              height: height,
              child: WebViewWidget(
                controller: WebViewController()
                  ..setNavigationDelegate(NavigationDelegate(
                      onNavigationRequest: (navigationRequest) {
                    if (navigationRequest.url.startsWith(
                        videoEmbedder['link'].replaceAll('{{id}}', ''))) {
                      return NavigationDecision.navigate;
                    } else {
                      launch(navigationRequest.url);
                      return NavigationDecision.prevent;
                    }
                  }))
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(initialUrl)),
              ),
            );
          } else {
            return Linkify(
              onOpen: (link) => launch(link.url),
              text: todoComment.content,
            );
          }
        }
      }
      return VideoPlayer(VideoPlayerController.network(todoComment.content));
      // return Chewie(
      //   controller: ChewieController(
      //     videoPlayerController: VideoPlayerController.network(
      //       todoComment.content,
      //     ),
      //     allowFullScreen: true,
      //     autoInitialize: true,
      //     looping: true,
      //   ),
      // );
    }
    return Linkify(
      onOpen: (link) => launch(link.url),
      text: todoComment.content,
    );
  }

  Future<void> _onDismissed(
      BuildContext context, DismissDirection direction) async {
    final deletedComment = await deleteComment();
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${todoComment.content} deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              this.addComment(
                TodoComment(
                  type: deletedComment.type,
                  content: deletedComment.content,
                  todo: deletedComment.todo,
                ),
              );
            },
          ),
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Dismissible(
        key: Key(todoComment.id),
        confirmDismiss: (direction) => _confirmDelete(context),
        onDismissed: (direction) => _onDismissed(context, direction),
        background: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Icon(Icons.delete),
            ),
            Flexible(
              child: Container(),
            ),
          ],
        ),
        secondaryBackground: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Icon(Icons.delete),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            onLongPress: onLongPress,
            onTap: onTap,
            selected: selected,
            title: _buildContent(context),
            subtitle: Text(dateFromNowFormatter(todoComment.createdAt)),
          ),
        ),
      );
}
