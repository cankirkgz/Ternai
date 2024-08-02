import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/models/post_model.dart';
import 'package:travelguide/models/user_model.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/post_viewmodel.dart';
import 'package:travelguide/models/comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  int _currentImageIndex = 0;
  final TextEditingController _commentController = TextEditingController();
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  UserModel? _userModel;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _pageController = PageController(initialPage: _currentImageIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.3)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);
    _fetchUserData();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
  }

  @override
  void dispose() {
    _commentController.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkIfLiked() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user?.userId;
    if (userId != null && widget.post.likedUserIds.contains(userId)) {
      setState(() {
        isLiked = true;
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
        setState(() {
          isLiked = !isLiked;
          if (isLiked) {
            widget.post.likes += 1;
            _animationController
                .forward()
                .then((_) => _animationController.reverse());
          } else {
            widget.post.likes -= 1;
          }
        });
        postViewModel.toggleLike(widget.post, userId).catchError((error) {
          setState(() {
            isLiked = !isLiked;
            if (isLiked) {
              widget.post.likes += 1;
            } else {
              widget.post.likes -= 1;
            }
          });
        });
      }
    }
  }

  Future<void> _fetchUserData() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    UserModel user = await authViewModel.getUserWithId(widget.post.userId);
    if (mounted) {
      setState(() {
        _userModel = user;
      });
    }
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, locale: 'tr');
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
      _showComments(context);
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
                        height: 300,
                        child: PageView.builder(
                          controller: _pageController,
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
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _userModel == null
                    ? const CircularProgressIndicator()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: _userModel!.profileImageUrl !=
                                        null
                                    ? NetworkImage(_userModel!.profileImageUrl!)
                                    : const AssetImage(
                                            'assets/images/default_profile.png')
                                        as ImageProvider,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: constraints.maxWidth * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _userModel!.name!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.post.country.name,
                                      style: TextStyle(color: Colors.grey[600]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: _toggleLike,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _animation.value,
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: isLiked
                                                ? [Colors.pink, Colors.red]
                                                : [Colors.grey, Colors.grey],
                                            tileMode: TileMode.mirror,
                                          ).createShader(bounds);
                                        },
                                        child: Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Paylaşıldı: ${timeAgo(widget.post.postDate)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => _showComments(context),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: const Text(
                          'Yorumları gör',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
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
                    style: const TextStyle(color: Colors.white, fontSize: 14),
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
