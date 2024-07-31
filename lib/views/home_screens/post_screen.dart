import 'package:flutter/material.dart';
import 'package:travelguide/models/post_model.dart';
import 'package:travelguide/views/widgets/post_card.dart';

class PostScreen extends StatelessWidget {
  final PostModel post;

  const PostScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: Center(
        child: PostCard(post: post),
      ),
    );
  }
}
