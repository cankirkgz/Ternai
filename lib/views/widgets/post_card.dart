import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/models/post_model.dart';
import 'package:travelguide/models/user_model.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/post_viewmodel.dart';
import 'package:travelguide/models/comment_model.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int _currentImageIndex = 0;
  final TextEditingController _commentController = TextEditingController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _pageController = PageController(initialPage: _currentImageIndex);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _checkIfLiked() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user?.userId;

    if (userId != null && widget.post.likedUserIds.contains(userId)) {
      setState(() {
        isLiked = true;
        print("isAnonymous: ${authViewModel.user?.isAnonymous}");
      });
    }
  }

  void _toggleLike() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    if (user != null) {
      if (user.isAnonymous) {
        _showAnonymousWarning();
      } else {
        final postViewModel =
            Provider.of<PostViewModel>(context, listen: false);
        final userId = user.userId;

        postViewModel.toggleLike(widget.post, userId);
        setState(() {
          isLiked = !isLiked;
        });
      }
    }
  }

  String timeAgo(DateTime date) {
    Duration diff = DateTime.now().difference(date);

    if (diff.inDays > 7) {
      return DateFormat.yMMMd().format(date); // Tarihi normal şekilde formatla
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} gün önce';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} saat önce';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} dakika önce';
    } else {
      return 'az önce';
    }
  }

  void _showComments(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    if (user != null && user.isAnonymous) {
      _showAnonymousWarning();
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.5,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<CommentModel>>(
                    future: Provider.of<PostViewModel>(context, listen: false)
                        .fetchComments(widget.post.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Yorumlar yüklenirken hata oluştu.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Henüz bir yorum yok.'));
                      }

                      final comments = snapshot.data!;
                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          CommentModel comment = comments[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: comment.user.profileImageUrl !=
                                        null
                                    ? NetworkImage(
                                        comment.user.profileImageUrl!)
                                    : const AssetImage(
                                            'assets/images/default_profile.png')
                                        as ImageProvider,
                                radius: 25,
                              ),
                              title: Text(
                                comment.user.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                comment.content,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListTile(
                    title: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Yorum Yaz',
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        _addComment(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _addComment(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    if (user != null &&
        !user.isAnonymous &&
        _commentController.text.isNotEmpty) {
      final newComment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _commentController.text,
        user: user,
        post: widget.post,
        date: DateTime.now(),
      );
      postViewModel.addComment(widget.post, newComment);

      if (mounted) {
        setState(() {
          widget.post.comments.add(newComment);
        });
      }

      _commentController.clear();
      Navigator.of(context).pop();
      _showComments(context); // Yorum eklendikten sonra yorumları tekrar göster
    } else if (user != null && user.isAnonymous) {
      _showAnonymousWarning();
    }
  }

  void _showAnonymousWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Anonim Kullanıcı'),
          content: const Text(
              'Anonim kullanıcı olarak sadece fiyat araması yapabilirsiniz. Diğer özelliklere erişmek için kayıt olmalısınız.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel =
        Provider.of<AuthViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.post.photoUrls.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _showFullScreenImages(context);
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 300, // Kare görünüm için sabit yükseklik
                        child: PageView.builder(
                          itemCount: widget.post.photoUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      widget.post.photoUrls[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1} / ${widget.post.photoUrls.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<UserModel>(
                  future: authViewModel.getUserWithId(widget.post.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Yükleme göstergesi
                    } else if (snapshot.hasError) {
                      return const Text(
                          "Kullanıcı yüklenirken hata oluştu"); // Hata mesajı
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text(
                          "Kullanıcı bulunamadı"); // Veri yok mesajı
                    }

                    UserModel user = snapshot.data!;
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : const AssetImage(
                                      'assets/images/default_profile.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.post.country.name,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : null,
                          ),
                          onPressed: _toggleLike,
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            _showComments(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.memories,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Paylaşıldı: ${timeAgo(widget.post.postDate)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => _showComments(context),
                      child: const Text(
                        'Yorumları gör',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16, // Daha büyük font
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImages(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView.builder(
                itemCount: widget.post.photoUrls.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(
                        widget.post.photoUrls[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1} / ${widget.post.photoUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
