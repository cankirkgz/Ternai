import 'package:flutter/material.dart';
import 'package:travelguide/models/post_model.dart';

class CommentWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLikePressed;
  final ScrollController scrollController;

  const CommentWidget({
    Key? key,
    required this.post,
    required this.onLikePressed,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: post.comments.length,
      itemBuilder: (context, index) {
        final comment = post.comments[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.user.profileImageUrl!),
            radius: 25,
          ),
          title: Text(comment.user.name!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.content),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: onLikePressed,
                  ),
                  Text('${comment.likeCount}'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
