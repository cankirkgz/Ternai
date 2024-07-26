import 'package:flutter/material.dart';
import 'package:travelguide/models/post_model.dart';

class CommentWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLikePressed;

  const CommentWidget({
    Key? key,
    required this.post,
    required this.onLikePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: post.comments.length,
      itemBuilder: (context, index) {
        final comment = post.comments[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.user.profileImageUrl!),
          ),
          title: Text(comment.user.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.content),
              Text(
                'Beğeni: ${comment.likeCount}, ${comment.date.hour} saat önce',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: onLikePressed,
          ),
        );
      },
    );
  }
}
