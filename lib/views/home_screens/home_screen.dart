import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/post_viewmodel.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/home_screens/new_post_screen.dart';
import 'package:travelguide/views/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Ternai',
          style: GoogleFonts.pacifico(
            color: AppColors.textColor,
          )
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              if (authViewModel.user != null &&
                  authViewModel.user!.isAnonymous) {
                _showAnonymousWarning();
              } else {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const NewPostScreen();
                }));
                Provider.of<PostViewModel>(context, listen: false).fetchPosts();
              }
            },
          ),
        ],
      ),
      body: Consumer<PostViewModel>(
        builder: (context, postViewModel, child) {
          if (postViewModel.posts.isEmpty) {
            return const Center(child: Text("Henüz gönderi yok"));
          }

          final posts = postViewModel.posts;
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 10.0,
            ),
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return const SizedBox(height: 40);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: PostCard(post: posts[index]),
              );
            },
          );
        },
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
