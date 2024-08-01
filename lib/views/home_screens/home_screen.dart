import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/post_viewmodel.dart';
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

  Future<void> _refreshPosts() async {
    await Provider.of<PostViewModel>(context, listen: false).fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              automaticallyImplyLeading: false,
              snap: true,
              leading: null, // Geri ikonunu kaldırır
              backgroundColor: Colors.white, // Arka planı beyaz yapar
              elevation: 0, // Yükseklik efekti yok
              centerTitle: true,
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  'Ternai',
                  style: GoogleFonts.pacifico(
                    color: Colors.white, // Gradient için beyaz metin
                    fontSize: 25,
                  ),
                ),
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
                      Provider.of<PostViewModel>(context, listen: false)
                          .fetchPosts();
                    }
                  },
                ),
              ],
            ),
          ];
        },
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor,
                    Colors.white,
                  ],
                ),
              ),
            ),
            Consumer<PostViewModel>(
              builder: (context, postViewModel, child) {
                return RefreshIndicator(
                  onRefresh: _refreshPosts,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: 10.0,
                    ),
                    itemCount: postViewModel.isLoading
                        ? 10
                        : postViewModel.posts.isEmpty
                            ? 1
                            : postViewModel.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (postViewModel.isLoading) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 150,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }

                      if (postViewModel.posts.isEmpty) {
                        return const Center(child: Text("Henüz gönderi yok"));
                      }

                      if (index == postViewModel.posts.length) {
                        return const SizedBox(height: 40);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: PostCard(post: postViewModel.posts[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
