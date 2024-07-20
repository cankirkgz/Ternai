import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/home_screens/profile_screen.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _birthDateController;
  // late TextEditingController _contactController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _usernameController = TextEditingController(
      text: authViewModel.user?.name ?? '',
    );
    _birthDateController = TextEditingController(
      text: authViewModel.user?.birthDate.toString() ?? '',
    );
    // _contactController = TextEditingController(
    //   text: authViewModel.user?.contact ?? '',
    // );
    _emailController = TextEditingController(
      text: authViewModel.user?.email ?? '',
    );
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen isiminizi ve soyisminizi giriniz';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen e-mailinizi giriniz';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-mail giriniz';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi giriniz';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi onaylayınız';
    }
    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.user?.name ?? 'Kullanıcı';
    final userMail = authViewModel.user?.email ?? 'Kullanıcı';
    final userId = authViewModel.user?.userId ?? 'Kullanıcı';

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
    appBar: AppBar(
    
    leading: IconButton(
      
      onPressed: () {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
      },
      icon: const Icon(
        
        color: Colors.black,
        Icons.arrow_back),
    ),  
    ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        height: screenHeight * 0.97,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 230),
                  CustomTextField(
                    controller: _usernameController,
                    labelText: ' Kullanıcı Adı',
                    suffixIcon: CupertinoIcons.person,
                    validator: _usernameValidator,
                  ),
                  CustomTextField(
                    controller: _birthDateController,
                    labelText: 'Doğum Tarihi',
                    suffixIcon: CupertinoIcons.calendar_today,
                    validator: _usernameValidator,
                  ),
                  // CustomTextField(
                  //   controller: _contactController,
                  //   labelText: 'İrtibat',
                  //   suffixIcon: CupertinoIcons.phone_fill,
                  //   validator: _usernameValidator,
                  // ),
                  CustomTextField(
                    controller: _emailController,
                    labelText: "E-mail",
                    suffixIcon: CupertinoIcons.envelope,
                    validator: _emailValidator,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: "Şifre",
                    obscureText: true,
                    suffixIcon: CupertinoIcons.lock,
                    validator: _passwordValidator,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "Profili güncelle",
                    color: AppColors.primaryColor,
                    onPressed: () async {
                      if (_usernameController.text != userName) {
                        Map<String, dynamic> data = {
                          'name': _usernameController.text,
                        };
                        await authViewModel.updateUserField(userId, data);

                        
                      };
                      if (_emailController.text != userMail) {
                        Map<String, dynamic> data = {
                          'email': _emailController.text,
                        };
                        await authViewModel.updateEmail(userId, data , _emailController.text.trim());

                        
                      };
                    //   if (_passwordController.text != '') {
                    //     Map<String, dynamic> data = {
                    //       'password': _passwordController.text,
                    //     };
                    //     await authViewModel.updateUserField(userId, data);
                    //   }
                   
                      
                    },
                    width: screenWidth * 0.7,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController(
//     text: 'deneme',
//   );
//   final _birthDateController = TextEditingController();
//   final _contactController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   // final _confirmPasswordController = TextEditingController();


//   String? _usernameValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Lütfen isiminizi ve soyisminizi giriniz';
//     }
//     return null;
//   }

//   String? _emailValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Lütfen e-mailinizi giriniz';
//     }
//     final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Geçerli bir e-mail giriniz';
//     }
//     return null;
//   }

//   String? _passwordValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Lütfen şifrenizi giriniz';
//     }
//     return null;
//   }

//   String? _confirmPasswordValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Lütfen şifrenizi onaylayınız';
//     }
//     if (value != _passwordController.text) {
//       return 'Şifreler eşleşmiyor';
//     }
//     return null;
//   }

// //
//   @override
//   Widget build(BuildContext context) {
//     final authViewModel = Provider.of<AuthViewModel>(context);
//     final userName = authViewModel.user?.name ?? 'Kullanıcı';
//     final userMail = authViewModel.user?.email ?? 'Kullanıcı';

//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(60),
//             topRight: Radius.circular(60),
//           ),
//         ),
//         height: screenHeight * 0.97,
//         width: double.infinity,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 230),
//                   CustomTextField(
//                     // style: TextStyle(
//                     //   fontSize: 5
//                     // ) ,
//                     // decoration: InputDecoration(
//                     //   contentPadding: const EdgeInsets.symmetric(
//                     //     horizontal: 30,
//                     //     vertical: 20,
//                     //   ),
//                     // ),
//                     controller: _usernameController,
//                     labelText: ' Kullanıcı Adı',
//                     suffixIcon: CupertinoIcons.person,
//                     validator: _usernameValidator,
//                   ),
//                   CustomTextField(
//                     controller: _birthDateController,
//                     labelText: 'Dogum Tarihi',
//                     hintText: 'getUser/BithDay',
//                     suffixIcon: CupertinoIcons.calendar_today,
//                     validator: _usernameValidator,
//                   ),
//                   CustomTextField(
//                     controller: _contactController,
//                     labelText: 'İrtibat',
//                     hintText: 'E164 getUser Number',
//                     suffixIcon: CupertinoIcons.phone_fill,
//                     validator: _usernameValidator,
//                   ),
//                   CustomTextField(
//                     controller: _emailController,
//                     labelText: "E-mail",
//                     hintText: userMail,
//                     suffixIcon: CupertinoIcons.envelope,
//                     validator: _emailValidator,
//                   ),
//                   CustomTextField(
//                     controller: _passwordController,
//                     labelText: "Şifre",
//                     hintText: "Şifre",
//                     obscureText: true,
//                     suffixIcon: CupertinoIcons.lock,
//                     validator: _passwordValidator,
//                   ),
//                   SizedBox(height: 20),
//                   CustomButton(
//                     text: "Profili güncelle",
//                     color: AppColors.primaryColor,
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         try {
//                           await authViewModel.signUpWithEmail(
//                             _emailController.text,
//                             _passwordController.text,
//                             _usernameController.text,
//                           );
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(e.toString()),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                     width: screenWidth * 0.7,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
