import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: _addCategories,
                child: Text('Kategorileri Ekle'),
              ),
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
                        scale: 1.0,
                        width: screenWidth,
                        height: 250,
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
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked ? AppColors.secondaryColor : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {
                                _showCommentsBottomSheet(context);
                              },
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
                            TextButton(
                              onPressed: () {
                                _showCommentsBottomSheet(context);
                              },
                              child: const Text(
                                'Yorumları Gör',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
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
      ),
      resizeToAvoidBottomInset: true, // Bu satırı ekle
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final AuthViewModel authViewModel =
        Provider.of<AuthViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: const Text(
                      'Yorumlar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: CommentWidget(
                      post: post,
                      onLikePressed: () {
                        setState(() {
                          // Like butonuna basıldığında yapılacak işlemler
                        });
                      },
                      scrollController: scrollController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: 'Yorum Yaz',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              final CommentModel newComment = CommentModel(
                                id: '',
                                content: _commentController.text,
                                user: authViewModel.user!,
                                post: post,
                                date: DateTime.now(),
                                likeCount: 0,
                              );
                              setState(() {
                                post.comments.add(newComment);
                              });
                              _commentController.clear();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addCategories() async {
    final List<Map<String, String>> categories = [
      {'id': 'accommodation', 'name': 'Konaklama'},
      {'id': 'fuel', 'name': 'Yakıt'},
      {'id': 'market', 'name': 'Market'},
      {'id': 'museum', 'name': 'Müze'},
      {'id': 'public_transport', 'name': 'Toplu Taşıma'},
      {'id': 'restaurant', 'name': 'Restoran'},
      {'id': 'shopping', 'name': 'Alışveriş'},
      {'id': 'tourist_attraction', 'name': 'Turistik Yerler'},
      {'id': 'health', 'name': 'Sağlık'},
      {'id': 'entertainment', 'name': 'Eğlence'},
      {'id': 'emergency', 'name': 'Acil Durum'},
      {'id': 'bank', 'name': 'Banka'},
    ];

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      for (var category in categories) {
        await firestore
            .collection('categories')
            .doc(category['id'])
            .set({'name': category['name']});
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler başarıyla eklendi')),
      );
    } catch (e) {
      print('Error adding categories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler eklenirken bir hata oluştu')),
      );
    }
  }
}
