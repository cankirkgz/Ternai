import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/home_screens/new_post_screen.dart';
import 'package:travelguide/models/comment_model.dart';
import 'package:travelguide/models/user_model.dart';
import 'package:travelguide/models/post_model.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/views/widgets/comment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  final PostModel post = PostModel(
    id: '1',
    user: UserModel(
      userId: '1',
      name: 'John Doe',
      profileImageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      email: "nG9kH@example.com",
      emailVerified: true,
      birthDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      createdAt: DateTime.now().subtract(Duration(days: 365 * 18)),
      updatedAt: DateTime.now().subtract(Duration(days: 365 * 18)),
    ),
    photoUrl:
        'https://images.pexels.com/photos/38238/maldives-ile-beach-sun-38238.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    country: Country(
      id: '1',
      name: 'İspanya',
      currency: 'Pesos',
      timezone: 'CET',
    ),
    daysStayed: 5,
    memories: 'Muhteşem bir gün geçirdik. Harika bir manzara!',
    postDate: DateTime.now().subtract(Duration(days: 1)),
    likes: 10,
    comments: [
      CommentModel(
        id: '1',
        content: 'Çok güzel bir yer, harika zaman geçirdik!',
        user: UserModel(
          userId: '2',
          name: 'Mehmet Yılmaz',
          profileImageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
          email: "nG9kH@example.com",
          emailVerified: true,
          birthDate: DateTime.now().subtract(Duration(days: 365 * 18)),
          createdAt: DateTime.now().subtract(Duration(days: 365 * 18)),
          updatedAt: DateTime.now().subtract(Duration(days: 365 * 18)),
        ),
        post: null, // Post'un kendisi burada yok
        date: DateTime.now().subtract(Duration(hours: 1)),
        likeCount: 5,
      ),
    ],
    lastUpdated: DateTime.now().subtract(Duration(days: 1)),
  );

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.user?.email ?? 'Kullanıcı';
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const NewPostScreen();
              }));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Kartın köşe radius'u
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(15.0), // Görselin köşe radius'u
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "https://images.pexels.com/photos/38238/maldives-ile-beach-sun-38238.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                      width: screenWidth,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              authViewModel.user?.profileImageUrl ?? '',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Can Kırkgöz",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "İspanya",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Muhteşem bir gün geçirdik. Harika bir manzara!',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Paylaşıldı: 12 Temmuz 2023',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Yorumlar',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          CommentWidget(
                            post: post,
                            onLikePressed: () {
                              setState(() {
                                // Like butonuna basıldığında yapılacak işlemler
                              });
                            },
                          ),
                          TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              labelText: 'Yorum Yaz',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  setState(() {
                                    if (_commentController.text.isNotEmpty) {
                                      post.comments.add(CommentModel(
                                        id: DateTime.now().toString(),
                                        content: _commentController.text,
                                        user: UserModel(
                                          userId: '3',
                                          email:
                                              authViewModel.user?.email ?? '',
                                          name: userName,
                                          profileImageUrl: authViewModel
                                                  .user?.profileImageUrl ??
                                              '',
                                          emailVerified: false,
                                          birthDate: DateTime.now(),
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        ),
                                        post:
                                            post, // Post'u referans olarak veriyoruz
                                        date: DateTime.now(),
                                        likeCount: 0,
                                      ));
                                      _commentController.clear();
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
